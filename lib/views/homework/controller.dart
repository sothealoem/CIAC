import 'package:get/get.dart';
import 'package:dio/dio.dart' as d;
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/models/models.dart';

class HomeworkController extends GetxController {
  final RxBool isAssignmentsLoading = false.obs;
  final RxBool isTeacherDashboardLoading = false.obs;
  final RxBool isSubmittingAssignment = false.obs;
  final Rxn<TeacherDashboardModel> teacherDashboard =
      Rxn<TeacherDashboardModel>();
  bool shouldShowAssignmentsLoading = false;

  final RxList<HomeworkAssignment> assignedHomeworkItems =
      <HomeworkAssignment>[].obs;
  final RxSet<String> submittedAssignmentIds = <String>{}.obs;

  bool get isParentRole => UserRepository.shared.isDriver;
  int get totalAssignments => assignedHomeworkItems.length;
  int get submittedAssignments => submittedAssignmentIds.length;
  int get pendingAssignments => totalAssignments - submittedAssignments;
  double get homeworkProgress =>
      totalAssignments == 0 ? 0 : submittedAssignments / totalAssignments;

  @override
  void onInit() {
    super.onInit();
    if (!isParentRole) {
      fetchTeacherDashboardStats();
      fetchTeacherHomeworks();
    }
  }

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
        (await SharedPreferencesManager.get('user_id') ?? '')
            .toString()
            .trim();
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

  HomeworkAssignment buildAssignment({
    String? id,
    required String title,
    required String className,
    required String deadline,
    required String description,
    int submitted = 0,
    int total = 0,
  }) {
    return HomeworkAssignment(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
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

  Future<void> fetchTeacherHomeworks() async {
    if (isAssignmentsLoading.value) return;

    try {
      isAssignmentsLoading.value = true;
      final res = await Get.find<ApiService>().get(
        EndPoints.teacherHomeworks,
        isShowLoading: false,
      );
      final rawData = getPropertyFromJson(res.data, 'data');
      if (rawData is! Map) {
        assignedHomeworkItems.clear();
        return;
      }

      final rows = rawData['data'];
      if (rows is! List) {
        assignedHomeworkItems.clear();
        return;
      }

      assignedHomeworkItems.assignAll(
        rows.whereType<Map>().map(
          (row) => _assignmentFromApi(Map<String, dynamic>.from(row)),
        ),
      );
    } catch (e) {
      assignedHomeworkItems.clear();
      ExceptionHandler.handleException(e, alert: false);
    } finally {
      isAssignmentsLoading.value = false;
    }
  }

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

  Future<HomeworkAssignment> createAssignment({
    required String title,
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
      className: trimmedClassName,
      deadline: trimmedDeadline,
      description: trimmedDescription,
    );

    final formMap = <String, dynamic>{
      'class_id': _classIdFor(trimmedClassName),
      'title': trimmedTitle,
      'description': trimmedDescription,
      'due_date': _deadlineForApi(trimmedDeadline),
    };
    if (imagePaths.isNotEmpty) {
      formMap['images[]'] = <d.MultipartFile>[
        for (final path in imagePaths)
          await d.MultipartFile.fromFile(path),
      ];
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
          title: _readText(map, const ['title', 'homework_title'], trimmedTitle),
          className: _readText(
            map,
            const ['class_name', 'class', 'grade', 'grade_name'],
            trimmedClassName,
          ),
          deadline: _displayDeadline(
            _readText(map, const ['deadline', 'due_date'], trimmedDeadline),
          ),
          submitted: _readInt(map, const ['submitted', 'submitted_count']),
          total: _readInt(
            map,
            const ['total', 'total_students', 'student_count'],
          ),
          description: _readText(
            map,
            const ['description', 'remark', 'instructions'],
            trimmedDescription,
          ),
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

  void updateAssignment(HomeworkAssignment item) {
    final index = assignedHomeworkItems.indexWhere(
      (current) => current.id == item.id,
    );
    if (index == -1) return;
    assignedHomeworkItems[index] = item;
  }

  bool isStudentSubmitted(String assignmentId) {
    return submittedAssignmentIds.contains(assignmentId);
  }

  void submitStudentHomework(String assignmentId) {
    submittedAssignmentIds.add(assignmentId);
  }

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
      if (text.isNotEmpty && text.toLowerCase() != 'null') {
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

  HomeworkAssignment _assignmentFromApi(Map<String, dynamic> map) {
    final submitted = _readInt(map, const ['submitted', 'submitted_count']);
    final total = _readInt(
      map,
      const ['total_students', 'total', 'student_count'],
    );
    final pending = _readInt(map, const ['pending']);

    return HomeworkAssignment(
      id: (map['id'] ?? '').toString(),
      title: _readText(map, const ['title', 'homework_title'], 'Untitled'),
      className: _readText(
        map,
        const ['class_name', 'class', 'grade', 'grade_name'],
        'N/A',
      ),
      deadline: _displayDeadline(
        _readText(map, const ['due_date', 'deadline'], ''),
      ),
      submitted: submitted,
      total: total == 0 && pending > 0 ? submitted + pending : total,
      description: _readText(
        map,
        const ['description', 'remark', 'instructions'],
        '',
      ),
    );
  }

  int? _classIdFor(String className) {
    // Replace these placeholders with the real backend class IDs.
    const classIds = <String, int>{
      'Grade 3A': 1,
      'Grade 4A': 2,
      'Grade 5B': 3,
    };
    return classIds[className.trim()];
  }
}

class HomeworkAssignment {
  const HomeworkAssignment({
    required this.id,
    required this.title,
    required this.className,
    required this.deadline,
    required this.submitted,
    required this.total,
    required this.description,
  });

  final String id;
  final String title;
  final String className;
  final String deadline;
  final int submitted;
  final int total;
  final String description;
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
  const HomeworkSubmissionStudent({
    required this.name,
    required this.status,
  });

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

    final status = firstText(
      const ['status', 'submission_status', 'submitted_status'],
      'pending',
    ).toLowerCase();

    return HomeworkSubmissionStudent(
      name: firstText(
        const [
          'name',
          'student_name',
          'fullname',
          'full_name',
          'fullname_english',
          'fullname_khmer',
        ],
        'Student',
      ),
      status: status.contains('submit') ? 'submitted' : 'pending',
    );
  }
}
