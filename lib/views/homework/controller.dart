import 'dart:convert';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as d;
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/models/models.dart';

class HomeworkController extends GetxController {
  final RxBool isAssignmentsLoading = false.obs;
  final RxBool isTeacherAssignmentsLoadingMore = false.obs;
  final RxBool isTeacherDashboardLoading = false.obs;
  final RxBool isSubmittingAssignment = false.obs;
  final Rxn<TeacherDashboardModel> teacherDashboard =
      Rxn<TeacherDashboardModel>();
  bool shouldShowAssignmentsLoading = false;

  final RxList<HomeworkAssignment> assignedHomeworkItems =
      <HomeworkAssignment>[].obs;
  final RxList<HomeworkClassOption> teacherClassOptions =
      <HomeworkClassOption>[].obs;
  final RxBool hasHomeworkNotification = false.obs;
  final RxSet<String> submittedAssignmentIds = <String>{}.obs;
  final RxSet<String> submittingAssignmentIds = <String>{}.obs;
  final RxInt teacherHomeworkCurrentPage = 1.obs;
  final RxInt teacherHomeworkLastPage = 1.obs;
  final RxInt teacherHomeworkPerPage = 10.obs;
  final RxInt teacherHomeworkTotal = 0.obs;

  bool get isParentRole => UserRepository.shared.isDriver;
  bool get hasMoreTeacherHomeworkPages =>
      teacherHomeworkCurrentPage.value < teacherHomeworkLastPage.value;
  int get totalAssignments => assignedHomeworkItems.length;
  int get submittedAssignments => submittedAssignmentIds.length;
  int get pendingAssignments => totalAssignments - submittedAssignments;
  double get homeworkProgress =>
      totalAssignments == 0 ? 0 : submittedAssignments / totalAssignments;
  List<HomeworkAssignment> get pendingHomeworkItems =>
      assignedHomeworkItems
          .where((item) => !submittedAssignmentIds.contains(item.id))
          .toList(growable: false);
  List<HomeworkAssignment> get submittedHomeworkItems =>
      assignedHomeworkItems
          .where((item) => submittedAssignmentIds.contains(item.id))
          .toList(growable: false);

  @override
  void onInit() {
    super.onInit();
    if (isParentRole) {
      fetchStudentHomeworks();
    } else {
      fetchTeacherDashboardStats();
      fetchTeacherHomeworks();
    }
  }

  // Parent/student homework flow.
  Future<void> fetchStudentHomeworks({bool resetBeforeLoad = false}) async {
    if (isAssignmentsLoading.value) return;

    if (resetBeforeLoad) {
      assignedHomeworkItems.clear();
    }

    final classId = await _resolveStudentClassId();
    final fallbackClassName = await _resolveStudentClassName();
    final selectedStudentId = await _resolveSelectedStudentId();
    if (classId == null) {
      assignedHomeworkItems.clear();
      return;
    }

    try {
      isAssignmentsLoading.value = true;
      final cachedSubmittedIds = await _loadSubmittedHomeworkIds(
        selectedStudentId,
      );
      final res = await Get.find<ApiService>().get(
        EndPoints.studentHomeworks(classId),
        isShowLoading: false,
      );
      final rows = _extractHomeworkRows(res.data);
      final items = rows
          .whereType<Map>()
          .map(
            (row) => _assignmentFromApi(
              Map<String, dynamic>.from(row),
              fallbackClassName: fallbackClassName,
            ),
          )
          .toList(growable: false);
      assignedHomeworkItems.assignAll(items);

      final refreshedSubmittedIds = <String>{
        ...cachedSubmittedIds,
        for (final row in rows.whereType<Map>())
          if (_isAssignmentSubmittedFromApi(Map<String, dynamic>.from(row)))
            ((row['id'] ?? row['homework_id'] ?? '').toString().trim()),
      }..removeWhere((id) => id.isEmpty);

      final validIds = items.map((item) => item.id.trim()).where((id) => id.isNotEmpty).toSet();
      submittedAssignmentIds
        ..clear()
        ..addAll(refreshedSubmittedIds.where(validIds.contains));
      await _saveSubmittedHomeworkIds(selectedStudentId, submittedAssignmentIds);
      await _refreshParentHomeworkNotification(selectedStudentId);
    } catch (e) {
      assignedHomeworkItems.clear();
      ExceptionHandler.handleException(e, alert: false);
    } finally {
      isAssignmentsLoading.value = false;
    }
  }

  // Teacher dashboard summary flow.
  Future<void> fetchTeacherDashboardStats() async {
    if (isTeacherDashboardLoading.value) return;

    final teacherId = await _resolveTeacherId();
    if (teacherId.isEmpty) return;

    try {
      isTeacherDashboardLoading.value = true;
      final res = await Get.find<ApiService>().get(
        EndPoints.teacherDashboard(teacherId),
        isShowLoading: false,
      );
      final data = getPropertyFromJson(res.data, 'data');
      if (data is! Map) return;

      teacherDashboard.value = TeacherDashboardModel.fromJson(
        Map<String, dynamic>.from(data),
      );
    } catch (e) {
      ExceptionHandler.handleException(e);
    } finally {
      isTeacherDashboardLoading.value = false;
    }
  }

  Future<String> _resolveTeacherId() async {
    final storedUserId =
        (await SharedPreferencesManager.get('user_id') ?? '').toString().trim();
    if (storedUserId.isNotEmpty && storedUserId != '0') {
      return storedUserId;
    }

    final storedStaffCode =
        (await SharedPreferencesManager.get('staff_code') ?? '')
            .toString()
            .trim();
    if (storedStaffCode.isNotEmpty && storedStaffCode != '0') {
      return storedStaffCode;
    }

    try {
      final id = UserRepository.shared.profile.id.toString().trim();
      if (id.isNotEmpty && id != '0') return id;
    } catch (_) {}

    return '';
  }

  // Shared homework model builder used by teacher create/update flows.
  HomeworkAssignment buildAssignment({
    String? id,
    int? classId,
    required String title,
    required String className,
    required String deadline,
    required String description,
    int submitted = 0,
    int total = 0,
  }) {
    return HomeworkAssignment(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      classId: classId,
      title: title,
      className: className,
      deadline: deadline.trim().isEmpty ? 'No deadline' : deadline.trim(),
      submitted: submitted,
      total: total,
      description: description,
    );
  }

  void requestAssignmentsLoading() {
    shouldShowAssignmentsLoading = true;
  }

  void addAssignment(HomeworkAssignment item) {
    assignedHomeworkItems.insert(0, item);
  }

  // Teacher homework list flow.
  Future<void> fetchTeacherHomeworks({bool reset = true}) async {
    if (reset) {
      if (isAssignmentsLoading.value) return;
    } else {
      if (isAssignmentsLoading.value ||
          isTeacherAssignmentsLoadingMore.value ||
          !hasMoreTeacherHomeworkPages) {
        return;
      }
    }

    try {
      if (reset) {
        isAssignmentsLoading.value = true;
        teacherHomeworkCurrentPage.value = 1;
      } else {
        isTeacherAssignmentsLoadingMore.value = true;
      }

      final res = await Get.find<ApiService>().get(
        EndPoints.teacherHomeworks,
        queryParameters: <String, dynamic>{
          'page': teacherHomeworkCurrentPage.value,
        },
        isShowLoading: false,
      );
      final rawData = getPropertyFromJson(res.data, 'data');
      if (rawData is! Map) {
        if (reset) {
          assignedHomeworkItems.clear();
        }
        return;
      }

      final rows = rawData['data'];
      if (rows is! List) {
        if (reset) {
          assignedHomeworkItems.clear();
        }
        return;
      }

      teacherHomeworkCurrentPage.value =
          (rawData['current_page'] as num?)?.toInt() ?? 1;
      teacherHomeworkLastPage.value =
          (rawData['last_page'] as num?)?.toInt() ??
          teacherHomeworkCurrentPage.value;
      teacherHomeworkPerPage.value =
          (rawData['per_page'] as num?)?.toInt() ??
          teacherHomeworkPerPage.value;
      teacherHomeworkTotal.value =
          (rawData['total'] as num?)?.toInt() ?? rows.length;

      final parsed =
          rows.whereType<Map>().map(
            (row) => _assignmentFromApi(Map<String, dynamic>.from(row)),
          ).toList(growable: false);

      if (reset) {
        assignedHomeworkItems.assignAll(parsed);
      } else {
        assignedHomeworkItems.addAll(
          parsed.where(
            (item) =>
                !assignedHomeworkItems.any((existing) => existing.id == item.id),
          ),
        );
      }
      _updateTeacherClassOptions();
      await _refreshTeacherHomeworkNotification();
    } catch (e) {
      if (reset) {
        assignedHomeworkItems.clear();
        teacherClassOptions.clear();
      }
      ExceptionHandler.handleException(e, alert: false);
    } finally {
      if (reset) {
        isAssignmentsLoading.value = false;
      } else {
        isTeacherAssignmentsLoadingMore.value = false;
      }
    }
  }

  Future<void> loadMoreTeacherHomeworks() async {
    if (!hasMoreTeacherHomeworkPages) return;
    teacherHomeworkCurrentPage.value += 1;
    await fetchTeacherHomeworks(reset: false);
  }

  // Teacher homework detail/submission review flow.
  Future<HomeworkAssignmentDetail> fetchTeacherHomeworkDetail(String id) async {
    final res = await Get.find<ApiService>().get(
      EndPoints.teacherHomeworkDetail(id),
      isShowLoading: false,
    );
    final data = getPropertyFromJson(res.data, 'data');
    if (data is! Map) {
      throw Exception('Invalid homework detail response');
    }

    final detailMap = Map<String, dynamic>.from(data);
    final studentsRaw = res.data is Map ? (res.data as Map)['students'] : null;
    final students =
        studentsRaw is List
            ? studentsRaw
                .whereType<Map>()
                .map(
                  (row) => HomeworkSubmissionStudent.fromJson(
                    Map<String, dynamic>.from(row),
                  ),
                )
                .toList(growable: false)
            : const <HomeworkSubmissionStudent>[];

    return HomeworkAssignmentDetail(
      assignment: _assignmentFromApi(detailMap),
      students: students,
    );
  }

  // Teacher create homework flow.
  Future<HomeworkAssignment> createAssignment({
    required String title,
    required int? classId,
    required String className,
    required String deadline,
    required String description,
    List<String> imagePaths = const <String>[],
  }) async {
    final trimmedTitle = title.trim();
    final trimmedClassName = className.trim();
    final trimmedDescription = description.trim();
    final trimmedDeadline = deadline.trim();

    final localItem = buildAssignment(
      title: trimmedTitle,
      classId: classId,
      className: trimmedClassName,
      deadline: trimmedDeadline,
      description: trimmedDescription,
    );

    final formMap = <String, dynamic>{
      'class_id': classId,
      'title': trimmedTitle,
      'description': trimmedDescription,
      'due_date': _deadlineForApi(trimmedDeadline),
    };
    if (imagePaths.isNotEmpty) {
      final files = <d.MultipartFile>[
        for (final path in imagePaths) await d.MultipartFile.fromFile(path),
      ];
      formMap['images'] = files;
      formMap['images[]'] = files;
      formMap['file'] = files.first;
    }
    final payload = d.FormData.fromMap(formMap);

    try {
      isSubmittingAssignment.value = true;
      final res = await Get.find<ApiService>().post(
        EndPoints.teacherHomeworks,
        payload,
        isShowLoading: false,
      );
      final data = getPropertyFromJson(res.data, 'data');
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final createdItem = HomeworkAssignment(
          id: (map['id'] ?? map['homework_id'] ?? localItem.id).toString(),
          classId: _findClassId(map) ?? classId,
          title: _readText(map, const [
            'title',
            'homework_title',
          ], trimmedTitle),
          className: _readText(map, const [
            'class_name',
            'class',
            'grade',
            'grade_name',
          ], trimmedClassName),
          deadline: _displayDeadline(
            _readText(map, const ['deadline', 'due_date'], trimmedDeadline),
          ),
          submitted: _readInt(map, const ['submitted', 'submitted_count']),
          total: _readInt(map, const [
            'total',
            'total_students',
            'student_count',
          ]),
          description: _readText(map, const [
            'description',
            'remark',
            'instructions',
          ], trimmedDescription),
        );
        assignedHomeworkItems.insert(0, createdItem);
        return createdItem;
      }

      assignedHomeworkItems.insert(0, localItem);
      return localItem;
    } finally {
      isSubmittingAssignment.value = false;
    }
  }

  // Teacher update homework flow.
  Future<HomeworkAssignment> updateAssignment({
    required String id,
    required int? classId,
    required String title,
    required String className,
    required String deadline,
    required String description,
    int submitted = 0,
    int total = 0,
    List<String> imagePaths = const <String>[],
  }) async {
    final trimmedId = id.trim();
    if (trimmedId.isEmpty) {
      throw Exception('Homework ID is missing');
    }

    final trimmedTitle = title.trim();
    final trimmedClassName = className.trim();
    final trimmedDescription = description.trim();
    final trimmedDeadline = deadline.trim();

    final localItem = buildAssignment(
      id: trimmedId,
      classId: classId,
      title: trimmedTitle,
      className: trimmedClassName,
      deadline: trimmedDeadline,
      description: trimmedDescription,
      submitted: submitted,
      total: total,
    );

    final formMap = <String, dynamic>{
      'class_id': classId,
      'title': trimmedTitle,
      'description': trimmedDescription,
      'due_date': _deadlineForApi(trimmedDeadline),
    };
    if (imagePaths.isNotEmpty) {
      final files = <d.MultipartFile>[
        for (final path in imagePaths) await d.MultipartFile.fromFile(path),
      ];
      formMap['images'] = files;
      formMap['images[]'] = files;
      formMap['file'] = files.first;
    }
    final payload = d.FormData.fromMap(formMap);

    try {
      isSubmittingAssignment.value = true;
      final res = await Get.find<ApiService>().post(
        EndPoints.teacherHomeworkDetail(trimmedId),
        payload,
        isShowLoading: false,
      );
      final data = getPropertyFromJson(res.data, 'data');
      HomeworkAssignment updatedItem = localItem;
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        updatedItem = HomeworkAssignment(
          id: (map['id'] ?? map['homework_id'] ?? localItem.id).toString(),
          classId: _findClassId(map) ?? classId,
          title: _readText(map, const [
            'title',
            'homework_title',
          ], trimmedTitle),
          className: _readHomeworkClassName(map, trimmedClassName),
          deadline: _displayDeadline(
            _readText(map, const ['deadline', 'due_date'], trimmedDeadline),
          ),
          submitted: _readInt(map, const ['submitted', 'submitted_count']),
          total: _readInt(map, const [
            'total',
            'total_students',
            'student_count',
          ]),
          description: _readText(map, const [
            'description',
            'remark',
            'instructions',
          ], trimmedDescription),
        );
      }

      final index = assignedHomeworkItems.indexWhere(
        (current) => current.id == trimmedId,
      );
      if (index != -1) {
        assignedHomeworkItems[index] = updatedItem;
      }
      _updateTeacherClassOptions();
      return updatedItem;
    } finally {
      isSubmittingAssignment.value = false;
    }
  }

  Future<void> deleteAssignment(String id) async {
    final trimmedId = id.trim();
    if (trimmedId.isEmpty) {
      throw Exception('Homework ID is missing');
    }

    await Get.find<ApiService>().post(
      EndPoints.teacherHomeworkDelete(trimmedId),
      <String, dynamic>{},
      isShowLoading: false,
    );

    assignedHomeworkItems.removeWhere((item) => item.id == trimmedId);
    _updateTeacherClassOptions();
  }

  void replaceAssignment(HomeworkAssignment item) {
    final index = assignedHomeworkItems.indexWhere(
      (current) => current.id == item.id,
    );
    if (index == -1) return;
    assignedHomeworkItems[index] = item;
  }

  bool isStudentSubmitted(String assignmentId) {
    return submittedAssignmentIds.contains(assignmentId);
  }

  bool isStudentSubmitting(String assignmentId) {
    return submittingAssignmentIds.contains(assignmentId);
  }

  void submitStudentHomework(String assignmentId) {
    submittedAssignmentIds.add(assignmentId);
  }

  // Parent/student submission flow.
  Future<void> submitStudentHomeworkAnswer({
    required String homeworkId,
    String answerText = '',
    String? attachmentPath,
  }) async {
    final studentId = await StudentIdResolver.resolve();
    if (studentId == null) {
      throw Exception('Student ID not found');
    }

    final trimmedHomeworkId = homeworkId.trim();
    if (trimmedHomeworkId.isEmpty) {
      throw Exception('Homework ID is missing');
    }

    try {
      submittingAssignmentIds.add(trimmedHomeworkId);
      final trimmedAnswer = answerText.trim();
      final trimmedAttachmentPath = attachmentPath?.trim() ?? '';
      final hasAttachment = trimmedAttachmentPath.isNotEmpty;
      final formMap = <String, dynamic>{
        'homework_id': trimmedHomeworkId,
        'student_id': studentId.toString(),
        'submitted_by': studentId.toString(),
      };

      // Keep the payload as close as possible to the original attach-only flow.
      // When a file is attached, prefer the file submission path and avoid
      // mixing in extra text unless there is no attachment.
      if (!hasAttachment && trimmedAnswer.isNotEmpty) {
        formMap['answer_text'] = trimmedAnswer;
      }
      print('Homework submit fields: $formMap');
      print(
        'Homework submit debug -> homework_id: $trimmedHomeworkId, '
        'student_id: $studentId, '
        'submitted_by: $studentId, '
        'has_file: $hasAttachment, '
        'answer_length: ${trimmedAnswer.length}',
      );
      if (hasAttachment) {
        formMap['file'] = await d.MultipartFile.fromFile(trimmedAttachmentPath);
      }

      final payload = d.FormData.fromMap(formMap);
      final res = await Get.find<ApiService>().post(
        EndPoints.studentHomeworkSubmit,
        payload,
        isShowLoading: false,
      );
      _ensureHomeworkSubmitSucceeded(res.data);
      submittedAssignmentIds.add(trimmedHomeworkId);
      await _saveSubmittedHomeworkIds(
        studentId.toString(),
        submittedAssignmentIds,
      );
      await fetchStudentHomeworks();
    } on d.DioException catch (e) {
      print('Homework submit DioException: ${e.message}');
      print('Homework submit status: ${e.response?.statusCode}');
      print('Homework submit response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Homework submit error: $e');
      rethrow;
    } finally {
      submittingAssignmentIds.remove(trimmedHomeworkId);
    }
  }

  Future<void> markHomeworkNotificationsSeen() async {
    if (isParentRole) {
      final studentId = await _resolveSelectedStudentId();
      await _saveSeenHomeworkIds(studentId, _currentHomeworkIds());
    } else {
      await _saveSeenTeacherSubmissionCounts(_currentTeacherSubmissionCounts());
    }
    hasHomeworkNotification.value = false;
  }

  // Shared deadline formatting helpers for homework forms and API payloads.
  String formatDeadline(DateTime picked) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${picked.day} ${months[picked.month - 1]} ${picked.year}';
  }

  String _deadlineForApi(String deadline) {
    if (deadline.trim().isEmpty || deadline == 'No deadline') {
      return '';
    }
    final parsed = _parseDisplayDeadline(deadline);
    if (parsed == null) {
      return deadline.trim();
    }
    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    return '${parsed.year}-$month-$day';
  }

  String _displayDeadline(String raw) {
    final parsed = _parseDisplayDeadline(raw);
    if (parsed == null) {
      final text = raw.trim();
      if (text.isEmpty ||
          text == '0000-00-00 00:00:00' ||
          text.toLowerCase() == 'null') {
        return 'No deadline';
      }
      return text;
    }
    return formatDeadline(parsed);
  }

  DateTime? _parseDisplayDeadline(String value) {
    final text = value.trim();
    if (text.isEmpty) return null;

    final iso = DateTime.tryParse(text);
    if (iso != null) return iso;

    final parts = text.split(RegExp(r'\s+'));
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final year = int.tryParse(parts[2]);
    const months = <String, int>{
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };
    final month = months[parts[1].toLowerCase()];
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  String _readText(
    Map<String, dynamic> map,
    List<String> keys,
    String fallback,
  ) {
    for (final key in keys) {
      final text = (map[key] ?? '').toString().trim();
      final lower = text.toLowerCase();
      if (text.isNotEmpty &&
          lower != 'null' &&
          lower != 'n/a' &&
          lower != 'false' &&
          lower != 'undefined') {
        return text;
      }
    }
    return fallback;
  }

  int _readInt(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      final parsed = int.tryParse((value ?? '').toString().trim());
      if (parsed != null) {
        return parsed;
      }
    }
    return 0;
  }

  HomeworkAssignment _assignmentFromApi(
    Map<String, dynamic> map, {
    String fallbackClassName = 'N/A',
  }) {
    final submitted = _readInt(map, const ['submitted', 'submitted_count']);
    final total = _readInt(map, const [
      'total_students',
      'total',
      'student_count',
    ]);
    final pending = _readInt(map, const ['pending']);

    return HomeworkAssignment(
      id: (map['id'] ?? '').toString(),
      classId: _findClassId(map),
      title: _readText(map, const ['title', 'homework_title'], 'Untitled'),
      className: _readHomeworkClassName(map, fallbackClassName),
      deadline: _displayDeadline(
        _readText(map, const ['due_date', 'deadline'], ''),
      ),
      submitted: submitted,
      total: total == 0 && pending > 0 ? submitted + pending : total,
      description: _readText(map, const [
        'description',
        'remark',
        'instructions',
      ], ''),
    );
  }

  void _updateTeacherClassOptions() {
    final byId = <int, HomeworkClassOption>{};
    final byName = <String, HomeworkClassOption>{};

    for (final item in assignedHomeworkItems) {
      final name = item.className.trim();
      final classId = item.classId;
      if (name.isEmpty) continue;

      final option = HomeworkClassOption(id: classId, name: name);
      if (classId != null && classId > 0) {
        byId[classId] = option;
      } else {
        byName[name.toLowerCase()] = option;
      }
    }

    final options = <HomeworkClassOption>[
      ...byId.values,
      ...byName.values.where(
        (option) =>
            option.id == null ||
            !byId.containsKey(option.id),
      ),
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    teacherClassOptions.assignAll(options);
  }

  List<dynamic> _extractHomeworkRows(dynamic raw) {
    if (raw is List) {
      return raw;
    }
    if (raw is! Map) {
      return const <dynamic>[];
    }

    final data = raw['data'];
    if (data is List) {
      return data;
    }
    if (data is Map) {
      final nested = data['data'];
      if (nested is List) {
        return nested;
      }
    }

    return const <dynamic>[];
  }

  Future<int?> _resolveStudentClassId() async {
    final cachedKeys = <String>[
      'selected_child_class_id',
      'student_info_class_id',
    ];
    for (final key in cachedKeys) {
      final raw =
          (await SharedPreferencesManager.get(key) ?? '').toString().trim();
      final parsed = int.tryParse(raw);
      if (parsed != null) {
        return parsed;
      }
    }

    final selectedStudentId =
        (await SharedPreferencesManager.get('selected_child_id') ?? '')
            .toString()
            .trim();

    try {
      final res = await Get.find<ApiService>().get(
        EndPoints.parentStudentInfo,
        isShowLoading: false,
      );
      final classId = await _findClassIdForSelectedStudent(
        res.data,
        selectedStudentId,
      );
      if (classId != null) {
        await SharedPreferencesManager.setValue(
          'selected_child_class_id',
          classId.toString(),
        );
        await SharedPreferencesManager.setValue(
          'student_info_class_id',
          classId.toString(),
        );
        return classId;
      }
    } catch (_) {
      // Fall through to the profile lookup below.
    }

    try {
      final res = await Get.find<ApiService>().get(
        EndPoints.parentProfile,
        queryParameters:
            selectedStudentId.isEmpty
                ? null
                : <String, dynamic>{'student_id': selectedStudentId},
        isShowLoading: false,
      );
      final classId = _findClassId(res.data);
      if (classId != null) {
        await SharedPreferencesManager.setValue(
          'selected_child_class_id',
          classId.toString(),
        );
        await SharedPreferencesManager.setValue(
          'student_info_class_id',
          classId.toString(),
        );
        return classId;
      }
    } catch (_) {
      return null;
    }
  }

  Future<String> _resolveSelectedStudentId() async {
    final resolved = await StudentIdResolver.resolve();
    if (resolved != null) {
      return resolved.toString().trim();
    }
    return (await SharedPreferencesManager.get('selected_child_id') ?? '')
        .toString()
        .trim();
  }

  Future<String> _resolveStudentClassName() async {
    final cachedKeys = <String>[
      'selected_child_class_name',
      'student_info_class_name',
    ];
    for (final key in cachedKeys) {
      final raw =
          (await SharedPreferencesManager.get(key) ?? '').toString().trim();
      if (raw.isNotEmpty &&
          raw.toLowerCase() != 'n/a' &&
          raw.toLowerCase() != 'null') {
        return raw;
      }
    }

    final selectedStudentId =
        (await SharedPreferencesManager.get('selected_child_id') ?? '')
            .toString()
            .trim();

    try {
      final res = await Get.find<ApiService>().get(
        EndPoints.parentStudentInfo,
        isShowLoading: false,
      );
      final className = _findClassNameForSelectedStudent(
        res.data,
        selectedStudentId,
      );
      if (className.isNotEmpty) {
        await SharedPreferencesManager.setValue(
          'selected_child_class_name',
          className,
        );
        await SharedPreferencesManager.setValue(
          'student_info_class_name',
          className,
        );
        return className;
      }
    } catch (_) {}

    return 'N/A';
  }

  void _ensureHomeworkSubmitSucceeded(dynamic raw) {
    if (raw is String) {
      final text = raw.trim().toLowerCase();
      if (text.startsWith('<!doctype html') ||
          text.startsWith('<html') ||
          text.contains('<body')) {
        throw 'Homework submit did not reach the API. Please log in again and try once more.';
      }
      return;
    }

    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final success = map['success'];
      if (success == false || success == 0 || success == '0') {
        final message =
            (map['message'] ?? map['error'] ?? map['detail'] ?? '')
                .toString()
                .trim();
        throw message.isEmpty ? 'Homework submit failed.' : message;
      }
    }
  }

  Future<int?> _findClassIdForSelectedStudent(
    dynamic raw,
    String selectedStudentId,
  ) async {
    if (raw is! Map) {
      return null;
    }

    final root = Map<String, dynamic>.from(raw);
    final data = root['data'];
    if (data is! Map) {
      return _findClassId(raw);
    }

    final studentsRaw = data['student'] ?? data['students'] ?? data['children'];
    if (studentsRaw is List) {
      for (final entry in studentsRaw) {
        if (entry is! Map) continue;
        final student = Map<String, dynamic>.from(entry);
        final idText =
            (student['id'] ?? student['student_id'] ?? '').toString().trim();
        if (selectedStudentId.isEmpty || idText == selectedStudentId) {
          final classId = _findClassId(student);
          if (classId != null) {
            return classId;
          }

          final className =
              (student['class_name'] ??
                      student['class'] ??
                      student['grade'] ??
                      '')
                  .toString()
                  .trim();
          if (className.isNotEmpty) {
            final resolved = await _resolveClassIdFromClassName(className);
            if (resolved != null) {
              return resolved;
            }
          }
        }
      }
    }

    return _findClassId(raw);
  }

  String _findClassNameForSelectedStudent(dynamic raw, String selectedStudentId) {
    if (raw is! Map) {
      return '';
    }

    final root = Map<String, dynamic>.from(raw);
    final data = root['data'];
    if (data is! Map) {
      return _readHomeworkClassName(root, '');
    }

    final studentsRaw = data['student'] ?? data['students'] ?? data['children'];
    if (studentsRaw is List) {
      for (final entry in studentsRaw) {
        if (entry is! Map) continue;
        final student = Map<String, dynamic>.from(entry);
        final idText =
            (student['id'] ?? student['student_id'] ?? '').toString().trim();
        if (selectedStudentId.isEmpty || idText == selectedStudentId) {
          return _readHomeworkClassName(student, '');
        }
      }
    }

    return _readHomeworkClassName(root, '');
  }

  Future<int?> _resolveClassIdFromClassName(String className) async {
    final normalized = className.trim().toLowerCase();
    if (normalized.isEmpty) {
      return null;
    }

    final local = _classIdFor(className);
    if (local != null) {
      return local;
    }

    try {
      final res = await Get.find<ApiService>().get(
        EndPoints.teacherHomeworks,
        isShowLoading: false,
      );
      final rows = _extractHomeworkRows(res.data);
      for (final row in rows) {
        if (row is! Map) continue;
        final map = Map<String, dynamic>.from(row);
        final rowClassName =
            (map['class_name'] ?? map['class'] ?? map['grade'] ?? '')
                .toString()
                .trim()
                .toLowerCase();
        final rowClassId = _findClassId(map);
        if (rowClassName == normalized &&
            rowClassId != null &&
            rowClassId > 0) {
          return rowClassId;
        }
      }
    } catch (_) {}

    return null;
  }

  int? _findClassId(dynamic raw) {
    if (raw is List) {
      for (final item in raw) {
        final classId = _findClassId(item);
        if (classId != null) {
          return classId;
        }
      }
      return null;
    }
    if (raw is! Map) {
      return null;
    }

    final map = Map<String, dynamic>.from(raw);
    final direct = map['class_id'] ?? map['classId'];
    if (direct is int) {
      return direct;
    }
    if (direct is num) {
      return direct.toInt();
    }
    if (direct != null) {
      final parsed = int.tryParse(direct.toString().trim());
      if (parsed != null) {
        return parsed;
      }
    }

    for (final value in map.values) {
      final classId = _findClassId(value);
      if (classId != null) {
        return classId;
      }
    }
    return null;
  }

  String _readHomeworkClassName(Map<String, dynamic> map, String fallback) {
    final direct = _readText(
      map,
      const ['class_name', 'class', 'grade', 'grade_name'],
      '',
    );
    final directLower = direct.toLowerCase();
    if (direct.isNotEmpty &&
        direct != '{}' &&
        !direct.startsWith('{') &&
        directLower != 'n/a' &&
        directLower != 'null' &&
        directLower != 'false' &&
        directLower != 'undefined') {
      return direct;
    }

    final rawClass = map['class'];
    if (rawClass is Map<String, dynamic>) {
      final nested = _readText(
        rawClass,
        const ['name', 'class_name', 'title', 'label'],
        '',
      );
      if (nested.isNotEmpty) {
        return nested;
      }
    } else if (rawClass is Map) {
      final nested = _readText(
        Map<String, dynamic>.from(rawClass),
        const ['name', 'class_name', 'title', 'label'],
        '',
      );
      if (nested.isNotEmpty) {
        return nested;
      }
    }

    final fallbackText = fallback.trim();
    final fallbackLower = fallbackText.toLowerCase();
    if (fallbackText.isNotEmpty &&
        fallbackLower != 'n/a' &&
        fallbackLower != 'null' &&
        fallbackLower != 'false' &&
        fallbackLower != 'undefined') {
      return fallbackText;
    }

    return 'N/A';
  }

  bool _isAssignmentSubmittedFromApi(Map<String, dynamic> map) {
    final directBoolKeys = <String>[
      'is_submitted',
      'submitted',
      'already_submitted',
      'has_submitted',
      'student_submitted',
    ];
    for (final key in directBoolKeys) {
      final value = map[key];
      if (value is bool) {
        return value;
      }
      final text = (value ?? '').toString().trim().toLowerCase();
      if (text == '1' || text == 'true' || text == 'yes') {
        return true;
      }
      if (text == '0' || text == 'false' || text == 'no') {
        return false;
      }
    }

    final statusKeys = <String>[
      'status',
      'submission_status',
      'submitted_status',
      'homework_status',
    ];
    for (final key in statusKeys) {
      final text = (map[key] ?? '').toString().trim().toLowerCase();
      if (text.contains('submit') ||
          text == 'done' ||
          text == 'completed') {
        return true;
      }
      if (text.contains('pending') || text.contains('not submit')) {
        return false;
      }
    }

    return false;
  }

  String _submittedHomeworkCacheKey(String studentId) {
    final safeStudentId = studentId.trim().isEmpty ? 'default' : studentId.trim();
    return 'submitted_homework_ids_$safeStudentId';
  }

  Future<Set<String>> _loadSubmittedHomeworkIds(String studentId) async {
    final raw =
        (await SharedPreferencesManager.get(_submittedHomeworkCacheKey(studentId)) ??
                '')
            .toString()
            .trim();
    if (raw.isEmpty) {
      return <String>{};
    }
    return raw
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet();
  }

  Future<void> _saveSubmittedHomeworkIds(
    String studentId,
    Iterable<String> ids,
  ) async {
    final normalized = ids
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    await SharedPreferencesManager.setValue(
      _submittedHomeworkCacheKey(studentId),
      normalized.join(','),
    );
  }

  int? _classIdFor(String className) {
    const classIds = <String, int>{
      'K1': 1,
      'K2': 2,
      'K3': 3,
      'Grade 3A': 1,
      'Grade 4A': 2,
      'Grade 5B': 3,
    };
    final trimmed = className.trim();
    final direct = classIds[trimmed];
    if (direct != null) {
      return direct;
    }

    final kinder = RegExp(r'^K\s*(\d+)$', caseSensitive: false).firstMatch(
      trimmed,
    );
    if (kinder != null) {
      return int.tryParse(kinder.group(1)!);
    }

    return null;
  }

  Future<void> _refreshParentHomeworkNotification(String studentId) async {
    final currentIds = _currentHomeworkIds();
    final seenIds = await _loadSeenHomeworkIds(studentId);
    hasHomeworkNotification.value = currentIds.any((id) => !seenIds.contains(id));
  }

  Future<void> _refreshTeacherHomeworkNotification() async {
    final currentCounts = _currentTeacherSubmissionCounts();
    final seenCounts = await _loadSeenTeacherSubmissionCounts();
    hasHomeworkNotification.value = currentCounts.entries.any((entry) {
      final seen = seenCounts[entry.key] ?? 0;
      return entry.value > seen;
    });
  }

  Iterable<String> _currentHomeworkIds() {
    return assignedHomeworkItems
        .map((item) => item.id.trim())
        .where((id) => id.isNotEmpty);
  }

  Map<String, int> _currentTeacherSubmissionCounts() {
    return <String, int>{
      for (final item in assignedHomeworkItems)
        if (item.id.trim().isNotEmpty) item.id.trim(): item.submitted,
    };
  }

  String _seenHomeworkIdsKey(String studentId) {
    final safeStudentId = studentId.trim().isEmpty ? 'default' : studentId.trim();
    return 'seen_homework_ids_$safeStudentId';
  }

  Future<Set<String>> _loadSeenHomeworkIds(String studentId) async {
    final raw =
        (await SharedPreferencesManager.get(_seenHomeworkIdsKey(studentId)) ?? '')
            .toString()
            .trim();
    if (raw.isEmpty) {
      return <String>{};
    }
    return raw
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet();
  }

  Future<void> _saveSeenHomeworkIds(
    String studentId,
    Iterable<String> ids,
  ) async {
    final normalized = ids
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    await SharedPreferencesManager.setValue(
      _seenHomeworkIdsKey(studentId),
      normalized.join(','),
    );
  }

  String _seenTeacherSubmissionCountsKey() {
    return 'seen_teacher_homework_submission_counts';
  }

  Future<Map<String, int>> _loadSeenTeacherSubmissionCounts() async {
    final raw =
        (await SharedPreferencesManager.get(_seenTeacherSubmissionCountsKey()) ??
                '')
            .toString()
            .trim();
    if (raw.isEmpty) {
      return <String, int>{};
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return <String, int>{};
      }
      return <String, int>{
        for (final entry in decoded.entries)
          entry.key.toString(): int.tryParse(entry.value.toString()) ?? 0,
      };
    } catch (_) {
      return <String, int>{};
    }
  }

  Future<void> _saveSeenTeacherSubmissionCounts(Map<String, int> counts) async {
    await SharedPreferencesManager.setValue(
      _seenTeacherSubmissionCountsKey(),
      jsonEncode(counts),
    );
  }
}

class HomeworkAssignment {
  const HomeworkAssignment({
    required this.id,
    this.classId,
    required this.title,
    required this.className,
    required this.deadline,
    required this.submitted,
    required this.total,
    required this.description,
  });

  final String id;
  final int? classId;
  final String title;
  final String className;
  final String deadline;
  final int submitted;
  final int total;
  final String description;
}

class HomeworkClassOption {
  const HomeworkClassOption({required this.id, required this.name});

  final int? id;
  final String name;
}

class HomeworkAssignmentDetail {
  const HomeworkAssignmentDetail({
    required this.assignment,
    required this.students,
  });

  final HomeworkAssignment assignment;
  final List<HomeworkSubmissionStudent> students;
}

class HomeworkSubmissionStudent {
  const HomeworkSubmissionStudent({required this.name, required this.status});

  final String name;
  final String status;

  factory HomeworkSubmissionStudent.fromJson(Map<String, dynamic> json) {
    String firstText(List<String> keys, [String fallback = '']) {
      for (final key in keys) {
        final text = (json[key] ?? '').toString().trim();
        if (text.isNotEmpty && text.toLowerCase() != 'null') {
          return text;
        }
      }
      return fallback;
    }
    final status =
        firstText(const [
          'status',
          'submission_status',
          'submitted_status',
        ], 'pending').toLowerCase();

    return HomeworkSubmissionStudent(
      name: firstText(const [
        'name',
        'student_name',
        'fullname',
        'full_name',
        'fullname_english',
        'fullname_khmer',
      ], 'Student'),
      status: status.contains('submit') ? 'submitted' : 'pending',
    );
  }
}
