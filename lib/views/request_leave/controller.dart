import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/models/models.dart';
import 'package:schoolapp/models/parent/parent.dart';
import 'package:schoolapp/models/requestleave/model.dart';

class RequestLeaveController extends GetxController {
  static const String _pendingCachePrefix = 'pending_leave_requests_';
  static const String _lastLeaveStudentKey = 'last_leave_student_id';
  final TextEditingController searchCtl = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxList<TrackingModel> trackings = <TrackingModel>[].obs;
  final RxList<RequestLeaveModel> requests = <RequestLeaveModel>[].obs;
  final RxString studentIdText = ''.obs;
  final RxString studentNameText = ''.obs;
  final RxString studentGradeText = ''.obs;
  final RxString studentImageUrl = ''.obs;
  final RxBool isLoadingRequests = true.obs;
  final Map<String, Student> _studentsById = <String, Student>{};

  bool isDone = false;
  var selectedClass = 'Grade 5'.obs;
  var selectedShift = ''.obs;
  var leaveType = ''.obs;
  var startDate = ''.obs;
  var endDate = ''.obs;
  var isloading = false.obs;
  final RxString reasonError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSelectedStudentInfo();
    fetchRequests();
  }

  @override
  void onClose() {
    searchCtl.dispose();
    reasonController.dispose();
    super.onClose();
  }

  final List<String> classes = <String>[
    'Grade 1',
    'Grade 2',
    'Grade 3',
    'Grade 4',
    'Grade 5',
    'Grade 6',
  ];

  Future<void> pickStartDate() async {
    final context = Get.overlayContext!;

    final DateTime? picked = await showDatePicker(
      context: context,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      startDate.value =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
    }
  }

  Future<void> pickEndDate() async {
    final context = Get.overlayContext!;

    final DateTime? picked = await showDatePicker(
      context: context,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      endDate.value =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
    }
  }

  int get totalDays {
    if (startDate.value.isEmpty || endDate.value.isEmpty) return 0;

    final start = _parseDate(startDate.value);
    final end = _parseDate(endDate.value);

    if (start == null || end == null) return 0;

    return end.difference(start).inDays + 1;
  }

  String get _mappedLeaveType {
    final raw = leaveType.value.trim().toLowerCase();
    if (raw == 'sick' || raw == 'ill' || raw == 'illness') {
      return 'Sick';
    }
    if (raw == 'busy' || raw == 'business' || raw == 'personal') {
      return 'Personal';
    }
    if (raw == 'other') {
      return 'Other';
    }
    return 'General';
  }

  Future<void> fetchRequests() async {
    await _ensureStudentLookup();
    final selectedRaw = await _selectedStudentId();
    final selectedResolved = await _resolveStudentIdForRequest(selectedRaw);
    final cacheScopes = _requestCacheScopes(selectedRaw, selectedResolved);

    var cachedPending = <RequestLeaveModel>[];
    isLoadingRequests.value = true;
    try {
      cachedPending = await _loadCachedPendingForScopes(cacheScopes);

      final res = await Get.find<ApiService>().get(
        EndPoints.parentLeaveRequests,
        queryParameters:
            selectedResolved.isNotEmpty
                ? <String, dynamic>{'student_id': selectedResolved}
                : null,
        isShowLoading: false,
      );

      final rows = _filterRowsBySelectedStudent(
        rows: _extractRows(res.data),
        selectedRaw: selectedRaw,
        selectedResolved: selectedResolved,
      );
      final backend =
          rows.map(RequestLeaveModel.fromJson).map(_withStudentInfo).toList();
      final merged = _mergeRequests(backend, cachedPending);
      requests.assignAll(merged);

      // keep only unsynced pending cache items
      final unsynced =
          cachedPending
              .where((p) => !backend.any((b) => _sameRequestKey(b, p)))
              .toList();
      await _saveCachedPendingForScopes(unsynced);
    } catch (e) {
      // Preserve pending items on transient failures.
      final fallback =
          cachedPending.isNotEmpty
              ? cachedPending
              : await _loadCachedPendingForScopes(cacheScopes);
      if (fallback.isNotEmpty) {
        requests.assignAll(fallback);
      }
      ExceptionHandler.handleException(e, alert: false);
    } finally {
      isLoadingRequests.value = false;
    }
  }

  Future<void> fetchSelectedStudentInfo() async {
    try {
      final selectedId = await _selectedStudentId();
      final res = await Get.find<ApiService>().get(
        EndPoints.parentStudentInfo,
        isShowLoading: false,
      );
      if (res.data is! Map) {
        return;
      }
      final model = ParentWithChild.fromJson(
        Map<String, dynamic>.from(res.data),
      );
      final students = model.data?.student ?? const <Student>[];
      _updateStudentLookup(students);
      if (students.isEmpty) {
        return;
      }

      Student student = students.first;
      if (selectedId.isNotEmpty) {
        for (final s in students) {
          if ((s.id?.toString() ?? '').trim() == selectedId) {
            student = s;
            break;
          }
        }
      }

      final className = (student.className ?? '').trim();
      studentIdText.value =
          (student.admissionNo ?? student.id?.toString() ?? '').trim();
      studentNameText.value = (student.nameKh ?? student.name ?? '').trim();
      studentGradeText.value = className;
      studentImageUrl.value = (student.profile ?? '').trim();

      if (className.isNotEmpty) {
        selectedClass.value = className;
      }
    } catch (_) {
      // Keep UI stable with existing placeholders.
    }
  }

  Future<RequestLeaveModel?> submitRequest() async {
    final reason = reasonController.text.trim();
    if (reason.isEmpty) {
      reasonError.value = LocaleKeys.cannotBeEmpty.tr;
      Get.snackbar(
        LocaleKeys.error.tr,
        '${LocaleKeys.reason.tr} ${LocaleKeys.cannotBeEmpty.tr}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
    reasonError.value = '';

    if (startDate.value.isEmpty ||
        endDate.value.isEmpty ||
        leaveType.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please complete all required fields.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }

    final selectedStudent = await _selectedStudentId();
    if (selectedStudent.isEmpty) {
      Get.snackbar(
        'Error',
        'No selected student.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
    final studentId = await _resolveStudentIdForRequest(selectedStudent);
    if (studentId.isEmpty) {
      Get.snackbar(
        'Error',
        'Invalid selected student.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
    await SharedPreferencesManager.setValue(_lastLeaveStudentKey, studentId);

    isloading.value = true;
    final basePayload = <String, dynamic>{
      'date_start': _formatToApiDate(startDate.value),
      'date_end': _formatToApiDate(endDate.value),
      'leave_type': _mappedLeaveType,
      'reason': reason,
    };

    try {
      await Get.find<ApiService>().post(
        EndPoints.parentLeaveRequest(studentId),
        basePayload,
        isShowLoading: false,
      );

      // Immediate local feedback so AllRequestedCard shows "pending" right away.
      final submitName = studentNameText.value.trim();
      final rawGrade = studentGradeText.value.trim();
      final normalizedGrade = rawGrade.toLowerCase();
      final submitGrade =
          rawGrade.isEmpty ||
                  normalizedGrade == 'n/a' ||
                  normalizedGrade == 'na' ||
                  normalizedGrade == 'null' ||
                  normalizedGrade == '-'
              ? ''
              : rawGrade;
      final pendingRequest = RequestLeaveModel(
        studentId: studentId,
        name: submitName.isEmpty ? 'Student' : submitName,
        grade: submitGrade,
        dateStart: startDate.value,
        dateEnd: endDate.value,
        leaveType: _mappedLeaveType,
        reason: reason,
        status: 'pending',
      );
      requests.insert(0, pendingRequest);
      await _appendCachedPending(studentId, pendingRequest);

      reasonController.clear();
      startDate.value = '';
      endDate.value = '';
      leaveType.value = '';
      return pendingRequest;
    } catch (e) {
      ExceptionHandler.handleException(e);
      return null;
    } finally {
      isloading.value = false;
    }
  }

  Future<void> fetchTracking() async {
    try {
      final Map<String, dynamic> param = {'invoice': searchCtl.text};
      final res = await Get.find<ApiService>().get(
        EndPoints.tracking,
        queryParameters: param,
        isShowLoading: true,
      );
      final data = getPropertyFromJson(res.data, 'data');
      trackings.value = List.from(
        (data as List).map((e) => TrackingModel.fromJson(e)).toList(),
      );

      isDone = true;
      DialogManager.hideLoading();
    } catch (e) {
      ExceptionHandler.handleException(e);
    }
  }

  Future<void> _ensureStudentLookup() async {
    if (_studentsById.isNotEmpty) {
      return;
    }
    await fetchSelectedStudentInfo();
  }

  void _updateStudentLookup(List<Student> students) {
    _studentsById.clear();
    for (final student in students) {
      final id = (student.id?.toString() ?? '').trim();
      final admissionNo = (student.admissionNo ?? '').trim();
      if (id.isNotEmpty) {
        _studentsById[id] = student;
      }
      if (admissionNo.isNotEmpty) {
        _studentsById[admissionNo] = student;
      }
    }
  }

  RequestLeaveModel _withStudentInfo(RequestLeaveModel item) {
    final studentKey = (item.studentId ?? '').trim();
    final student = studentKey.isEmpty ? null : _studentsById[studentKey];
    if (student == null) {
      return item;
    }

    final name = (item.name ?? '').trim();
    final grade = (item.grade ?? '').trim();
    return RequestLeaveModel(
      studentId: item.studentId,
      name: _isPlaceholderName(name) ? _studentDisplayName(student) : name,
      grade: _isValidText(grade) ? grade : (student.className ?? '').trim(),
      dateStart: item.dateStart,
      dateEnd: item.dateEnd,
      leaveType: item.leaveType,
      reason: item.reason,
      status: item.status,
    );
  }

  String _studentDisplayName(Student student) {
    final khmerName = (student.nameKh ?? '').trim();
    if (khmerName.isNotEmpty) {
      return khmerName;
    }
    return (student.name ?? '').trim();
  }

  bool _isValidText(String value) {
    final text = value.trim().toLowerCase();
    return text.isNotEmpty && text != 'n/a' && text != 'na' && text != 'null' && text != '-';
  }

  bool _isPlaceholderName(String value) {
    final text = value.trim().toLowerCase();
    return text.isEmpty ||
        text == 'student' ||
        text == 'n/a' ||
        text == 'na' ||
        text == 'null' ||
        text == '-';
  }

  Future<String> _selectedStudentId() async {
    final selected =
        (await SharedPreferencesManager.get('selected_child_id') ?? '')
            .toString()
            .trim();
    if (selected.isNotEmpty) {
      return selected;
    }
    return (await SharedPreferencesManager.get(_lastLeaveStudentKey) ?? '')
        .toString()
        .trim();
  }

  List<Map<String, dynamic>> _extractRows(dynamic raw) {
    if (raw is! Map) {
      return const <Map<String, dynamic>>[];
    }

    final map = Map<String, dynamic>.from(raw);
    final candidates = <dynamic>[
      map['data'],
      map['leave_requests'],
      map['requests'],
      map['rows'],
      map['data'] is Map ? map['data']['data'] : null,
      map['data'] is Map ? map['data']['leave_requests'] : null,
      map['data'] is Map ? map['data']['requests'] : null,
    ];

    for (final candidate in candidates) {
      if (candidate is List) {
        return candidate
            .whereType<dynamic>()
            .map((e) {
              if (e is Map<String, dynamic>) return e;
              if (e is Map) return Map<String, dynamic>.from(e);
              return null;
            })
            .whereType<Map<String, dynamic>>()
            .toList();
      }
    }

    return const <Map<String, dynamic>>[];
  }

  String _formatToApiDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    final date = _parseDate(dateStr);
    if (date == null) return '';
    // Backend expects local datetime format without trailing timezone suffix.
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(date);
  }

  DateTime? _parseDate(String date) {
    try {
      final parts = date.split('/');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  List<RequestLeaveModel> _mergeRequests(
    List<RequestLeaveModel> backend,
    List<RequestLeaveModel> cachedPending,
  ) {
    final merged = <RequestLeaveModel>[...backend];
    for (final pending in cachedPending) {
      if (!merged.any((e) => _sameRequestKey(e, pending))) {
        merged.insert(0, pending);
      }
    }
    return merged;
  }

  bool _sameRequestKey(RequestLeaveModel a, RequestLeaveModel b) {
    final aStudent = (a.studentId ?? '').trim();
    final bStudent = (b.studentId ?? '').trim();
    if (aStudent.isNotEmpty && bStudent.isNotEmpty && aStudent != bStudent) {
      return false;
    }

    final aStart = _normalizeDateKey(a.dateStart);
    final bStart = _normalizeDateKey(b.dateStart);
    final aEnd = _normalizeDateKey(a.dateEnd);
    final bEnd = _normalizeDateKey(b.dateEnd);
    final aType = (a.leaveType ?? '').trim().toLowerCase();
    final bType = (b.leaveType ?? '').trim().toLowerCase();
    final sameDateWindow = aStart == bStart && aEnd == bEnd;

    // Keep matching lenient so backend-approved records replace local pending
    // even when reason text or formatting differs.
    if (!sameDateWindow) {
      return false;
    }
    if (aType.isEmpty || bType.isEmpty) {
      return true;
    }
    return aType == bType;
  }

  String _normalizeDateKey(String? input) {
    final raw = (input ?? '').trim();
    if (raw.isEmpty) {
      return '';
    }

    final slash = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(raw);
    if (slash != null) {
      return '${slash.group(3)}-${slash.group(2)}-${slash.group(1)}';
    }

    // Prefer extracting date part directly to avoid timezone/day shifts.
    final dateOnly = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(raw);
    if (dateOnly != null) {
      return '${dateOnly.group(1)}-${dateOnly.group(2)}-${dateOnly.group(3)}';
    }

    final parsed = DateTime.tryParse(raw);
    if (parsed != null) {
      return '${parsed.year.toString().padLeft(4, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
    }

    return raw;
  }

  Future<void> _appendCachedPending(
    String studentId,
    RequestLeaveModel request,
  ) async {
    final current = await _loadCachedPending(studentId);
    if (!current.any((e) => _sameRequestKey(e, request))) {
      current.insert(0, request);
      await _saveCachedPending(studentId, current);
    }
  }

  Future<List<RequestLeaveModel>> _loadCachedPending(String studentId) async {
    final raw = await SharedPreferencesManager.get(_cacheKey(studentId));
    if (raw is! String || raw.trim().isEmpty) {
      return <RequestLeaveModel>[];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return <RequestLeaveModel>[];
      }
      return decoded
          .whereType<dynamic>()
          .map((e) {
            if (e is Map<String, dynamic>) {
              return RequestLeaveModel.fromJson(e);
            }
            if (e is Map) {
              return RequestLeaveModel.fromJson(Map<String, dynamic>.from(e));
            }
            return null;
          })
          .whereType<RequestLeaveModel>()
          .map(_withStudentInfo)
          .toList();
    } catch (_) {
      return <RequestLeaveModel>[];
    }
  }

  Future<void> _saveCachedPending(
    String studentId,
    List<RequestLeaveModel> list,
  ) async {
    final encoded = jsonEncode(
      list
          .map(
            (e) => <String, dynamic>{
              'name': e.name ?? '',
              'student_id': e.studentId ?? '',
              'grade': e.grade ?? '',
              'date_start': e.dateStart ?? '',
              'date_end': e.dateEnd ?? '',
              'leave_type': e.leaveType ?? '',
              'reason': e.reason ?? '',
              'status': e.status ?? 'pending',
            },
          )
          .toList(),
    );
    await SharedPreferencesManager.setValue(_cacheKey(studentId), encoded);
  }

  String _cacheKey(String studentId) => '$_pendingCachePrefix$studentId';

  List<String> _requestCacheScopes(String selectedRaw, String selectedResolved) {
    final scopes = <String>{};
    if (selectedRaw.trim().isNotEmpty) {
      scopes.add(selectedRaw.trim());
    }
    if (selectedResolved.trim().isNotEmpty) {
      scopes.add(selectedResolved.trim());
    }
    if (scopes.isEmpty) {
      scopes.add('all');
    }
    return scopes.toList();
  }

  Future<List<RequestLeaveModel>> _loadCachedPendingForScopes(
    List<String> scopes,
  ) async {
    final result = <RequestLeaveModel>[];
    for (final scope in scopes) {
      final rows = await _loadCachedPending(scope);
      for (final row in rows) {
        if (!result.any((e) => _sameRequestKey(e, row))) {
          result.add(row);
        }
      }
    }
    return result;
  }

  Future<void> _saveCachedPendingForScopes(
    List<RequestLeaveModel> pending,
  ) async {
    final grouped = <String, List<RequestLeaveModel>>{};
    for (final item in pending) {
      final scope = (item.studentId ?? '').trim();
      final key = scope.isEmpty ? 'all' : scope;
      grouped.putIfAbsent(key, () => <RequestLeaveModel>[]).add(item);
    }

    final scopes = <String>{..._studentsById.keys, ...grouped.keys};
    if (scopes.isEmpty) {
      scopes.add('all');
    }
    for (final scope in scopes) {
      await _saveCachedPending(scope, grouped[scope] ?? <RequestLeaveModel>[]);
    }
  }

  List<Map<String, dynamic>> _filterRowsBySelectedStudent({
    required List<Map<String, dynamic>> rows,
    required String selectedRaw,
    required String selectedResolved,
  }) {
    final raw = selectedRaw.trim();
    final resolved = selectedResolved.trim();
    if (raw.isEmpty && resolved.isEmpty) {
      return rows;
    }

    bool matches(Map<String, dynamic> row) {
      final candidates = <String>[
        (row['student_id'] ?? '').toString().trim(),
        (row['studentId'] ?? '').toString().trim(),
        (row['student'] is Map ? row['student']['id'] : '').toString().trim(),
        (row['admission_no'] ?? '').toString().trim(),
        (row['student_code'] ?? '').toString().trim(),
      ]..removeWhere((e) => e.isEmpty || e.toLowerCase() == 'null');

      if (resolved.isNotEmpty && candidates.contains(resolved)) {
        return true;
      }
      if (raw.isNotEmpty && candidates.contains(raw)) {
        return true;
      }
      return false;
    }

    final filtered = rows.where(matches).toList();
    return filtered;
  }

  Future<String> _resolveStudentIdForRequest(String selected) async {
    final raw = selected.trim();
    if (raw.isEmpty) {
      return '';
    }
    if (RegExp(r'^\d+$').hasMatch(raw)) {
      return raw;
    }

    try {
      final res = await Get.find<ApiService>().get(
        EndPoints.parentStudentInfo,
        isShowLoading: false,
      );
      if (res.data is! Map) {
        return '';
      }
      final model = ParentWithChild.fromJson(
        Map<String, dynamic>.from(res.data),
      );
      final students = model.data?.student ?? const <Student>[];
      for (final s in students) {
        final id = (s.id?.toString() ?? '').trim();
        final admission = (s.admissionNo ?? '').trim();
        if (id == raw || admission == raw) {
          return id;
        }
      }
    } catch (_) {
      return '';
    }
    return '';
  }
}
