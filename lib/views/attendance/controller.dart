import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/models/attendance_summery/attendance_summery.dart'
    as attendance_summary;
import 'package:schoolapp/models/models.dart';
import 'package:schoolapp/models/staff/model.dart';

class AttendanceController extends GetxController {
  final TextEditingController searchCtl = TextEditingController();
  final ScrollController attendanceScrollCtl = ScrollController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxList<TrackingModel> trackings = <TrackingModel>[].obs;
  final RxList<attendance_summary.Data> summaries =
      <attendance_summary.Data>[].obs;
  final RxBool isLoadingSummary = true.obs;
  final RxString summaryError = ''.obs;
  final RxnString selectedStatusFilter = RxnString();
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxInt attendanceRecordLateCount = 0.obs;
  final RxList<StaffAttendanceItem> attendanceRecordLateItems =
      <StaffAttendanceItem>[].obs;
  final RxBool isLoadingMoreSummary = false.obs;
  final RxInt currentPage = 1.obs;
  final RxInt lastPage = 1.obs;
  final RxInt perPage = 15.obs;

  bool isDone = false;

  @override
  void onInit() {
    super.onInit();
    attendanceScrollCtl.addListener(_onAttendanceScroll);
    fetchAttendanceSummary();
  }

  @override
  void onClose() {
    attendanceScrollCtl.dispose();
    searchCtl.dispose();
    super.onClose();
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

  Future<void> filter() async {
    selectedStatusFilter.value = null;
    await fetchAttendanceSummary();
  }

  Future<void> selectMonth(MonthFilterItem item) async {
    selectedMonth.value = item.month;
    await filter();
  }

  void toggleStatusFilter(String status) {
    if (selectedStatusFilter.value == status) {
      selectedStatusFilter.value = null;
      return;
    }
    selectedStatusFilter.value = status;
  }

  Future<void> fetchAttendanceSummary({bool reset = true}) async {
    if (reset) {
      currentPage.value = 1;
      isLoadingSummary.value = true;
    } else {
      if (isLoadingMoreSummary.value || isLoadingSummary.value) {
        return;
      }
      isLoadingMoreSummary.value = true;
    }
    summaryError.value = '';
    try {
      final studentId = await _resolveStudentId();
      final month = MonthFilterItem.fromMonth(selectedMonth.value);
      final startDate = month.startDate(selectedYear.value);
      final endDate = month.endDate(selectedYear.value);
      final queryParams = <String, dynamic>{
        'student_id': studentId,
        'class_id': null,
        'start_date': _formatDate(startDate),
        'end_date': _formatDate(endDate),
        'page': currentPage.value,
        'per_page': perPage.value,
      };

      final res = await Get.find<ApiService>().get(
        EndPoints.attendanceSummary,
        queryParameters: queryParams,
        isShowLoading: false,
      );

      if (res.data is! Map) {
        if (reset) {
          summaries.value = const <attendance_summary.Data>[];
        }
        return;
      }

      final model = attendance_summary.AttendanceSummery.fromJson(
        Map<String, dynamic>.from(res.data as Map),
      );
      final summary = model.summary ?? const <attendance_summary.Data>[];
      final data = model.data ?? const <attendance_summary.Data>[];
      final listData =
          model.attendancesList?.data ?? const <attendance_summary.Data>[];
      final page = model.attendancesList;
      if (page != null && summary.isEmpty) {
        currentPage.value = page.currentPage ?? currentPage.value;
        lastPage.value = page.lastPage ?? currentPage.value;
        perPage.value = page.perPage ?? perPage.value;
      } else {
        lastPage.value = currentPage.value;
      }

      if (summary.isNotEmpty) {
        _setSummaries(_filterItemsBySelectedMonth(summary), append: !reset);
      } else if (listData.isNotEmpty) {
        _setSummaries(_filterItemsBySelectedMonth(listData), append: !reset);
      } else {
        _setSummaries(_filterItemsBySelectedMonth(data), append: !reset);
      }
      if (reset) {
        await _fetchLateCountFromAttendanceRecord(studentId);
      }
    } catch (e) {
      if (reset) {
        summaries.value = const <attendance_summary.Data>[];
        attendanceRecordLateCount.value = 0;
        attendanceRecordLateItems.clear();
      }
      summaryError.value = 'Failed to load attendance summary';
      ExceptionHandler.handleException(e, alert: false);
    } finally {
      if (reset) {
        isLoadingSummary.value = false;
      } else {
        isLoadingMoreSummary.value = false;
      }
    }
  }

  Future<void> loadMoreAttendanceSummary() async {
    if (currentPage.value >= lastPage.value) {
      return;
    }
    currentPage.value += 1;
    await fetchAttendanceSummary(reset: false);
  }

  int get totalPresent => _sumBy((item) => item.totalPresence);
  int get totalPermission => _sumBy((item) => item.totalPermission);
  int get totalAbsent => _sumBy((item) => item.totalAbsent);
  int get totalLate => attendanceRecordLateCount.value;

  int _sumBy(String? Function(attendance_summary.Data) pick) {
    var total = 0;
    for (final item in summaries) {
      total += int.tryParse((pick(item) ?? '0').trim()) ?? 0;
    }
    return total;
  }

  void _onAttendanceScroll() {
    if (!attendanceScrollCtl.hasClients) {
      return;
    }
    final position = attendanceScrollCtl.position;
    if (position.pixels >= position.maxScrollExtent - 120) {
      loadMoreAttendanceSummary();
    }
  }

  void _setSummaries(
    List<attendance_summary.Data> next, {
    required bool append,
  }) {
    if (!append) {
      summaries.assignAll(next);
      return;
    }
    summaries.addAll(next);
  }

  List<attendance_summary.Data> _filterItemsBySelectedMonth(
    List<attendance_summary.Data> items,
  ) {
    return items.where((item) {
      final date = _readItemDate(item);
      if (date == null) {
        return _hasAnyAttendanceTotal(item);
      }
      return date.month == selectedMonth.value &&
          date.year == selectedYear.value;
    }).toList(growable: false);
  }

  bool _hasAnyAttendanceTotal(attendance_summary.Data item) {
    return _toCount(item.totalPresence) > 0 ||
        _toCount(item.totalLate) > 0 ||
        _toCount(item.totalAbsent) > 0 ||
        _toCount(item.totalPermission) > 0;
  }

  int _toCount(String? value) {
    return int.tryParse((value ?? '0').trim()) ?? 0;
  }

  Future<void> _fetchLateCountFromAttendanceRecord(int? studentId) async {
    attendanceRecordLateCount.value = 0;
    attendanceRecordLateItems.clear();
    final month = MonthFilterItem.fromMonth(selectedMonth.value);
    final params = <String, dynamic>{};
    if (studentId != null) {
      params['student_id'] = studentId;
    }
    params['start_date'] = _formatDate(month.startDate(selectedYear.value));
    params['end_date'] = _formatDate(month.endDate(selectedYear.value));
    params['per_page'] = 1000;

    try {
      final res = await Get.find<ApiService>().get(
        EndPoints.parentChildrenAttendanceLog,
        queryParameters: params.isEmpty ? null : params,
        isShowLoading: false,
      );
      if (res.data is! Map) {
        return;
      }

      final model = StaffModel.fromJson(Map<String, dynamic>.from(res.data));
      final items = model.data?.items ?? const <StaffAttendanceItem>[];
      final lateItems =
          items.where((item) {
            final status = item.status.toLowerCase().trim();
            final date = _readRecordDate(item);
            return status.contains('late') &&
                date?.month == selectedMonth.value &&
                date?.year == selectedYear.value;
          }).toList(growable: false);
      attendanceRecordLateItems.assignAll(lateItems);
      attendanceRecordLateCount.value = lateItems.length;
    } catch (_) {
      attendanceRecordLateCount.value = 0;
      attendanceRecordLateItems.clear();
    }
  }

  DateTime? _readRecordDate(StaffAttendanceItem item) {
    final raw =
        (item.attendanceDate.isEmpty ? item.createdAt : item.attendanceDate)
            .trim();
    if (raw.isEmpty) {
      return null;
    }

    final parsed = DateTime.tryParse(raw);
    if (parsed != null) {
      return parsed;
    }

    final dateOnly = raw.split(' ').first;
    final slashParts = dateOnly.split('/');
    if (slashParts.length == 3) {
      final first = int.tryParse(slashParts[0]);
      final second = int.tryParse(slashParts[1]);
      final year = int.tryParse(slashParts[2]);
      if (first != null && second != null && year != null) {
        return DateTime(year, second, first);
      }
    }

    return null;
  }

  DateTime? _readItemDate(attendance_summary.Data item) {
    final raw = (item.attendanceDate ?? item.createdAt ?? '').trim();
    if (raw.isEmpty) {
      return null;
    }

    final parsed = DateTime.tryParse(raw);
    if (parsed != null) {
      return parsed;
    }

    final dateOnly = raw.split(' ').first;
    final slashParts = dateOnly.split('/');
    if (slashParts.length == 3) {
      final first = int.tryParse(slashParts[0]);
      final second = int.tryParse(slashParts[1]);
      final year = int.tryParse(slashParts[2]);
      if (first != null && second != null && year != null) {
        return DateTime(year, second, first);
      }
    }

    return null;
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<int?> _resolveStudentId() async {
    final keys = <String>[
      'selected_child_id',
      'student_info_id',
      'last_leave_student_id',
    ];

    for (final key in keys) {
      final value = (await SharedPreferencesManager.get(key) ?? '')
          .toString()
          .trim();
      if (value.isEmpty) continue;
      final parsed = int.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    return null;
  }
}
