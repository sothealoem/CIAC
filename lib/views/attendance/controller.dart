import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/models/attendance_summery/attendance_summery.dart'
    as attendance_summary;
import 'package:schoolapp/models/models.dart';

class AttendanceController extends GetxController {
  final TextEditingController searchCtl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxList<TrackingModel> trackings = <TrackingModel>[].obs;
  final RxList<attendance_summary.Data> summaries =
      <attendance_summary.Data>[].obs;
  final RxBool isLoadingSummary = true.obs;
  final RxString summaryError = ''.obs;
  final RxnString selectedStatusFilter = RxnString();

  bool isDone = false;
  var selectedMonth = 'Jan'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceSummary();
  }

  @override
  void onClose() {
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

  void toggleStatusFilter(String status) {
    if (selectedStatusFilter.value == status) {
      selectedStatusFilter.value = null;
      return;
    }
    selectedStatusFilter.value = status;
  }

  Future<void> fetchAttendanceSummary() async {
    isLoadingSummary.value = true;
    summaryError.value = '';
    try {
      final studentId = await _resolveStudentId();
      final queryParams = <String, dynamic>{
        'student_id': studentId,
        'class_id': null,
        'start_date': null,
        'end_date': null,
      };

      final res = await Get.find<ApiService>().get(
        EndPoints.attendanceSummary,
        queryParameters: queryParams,
        isShowLoading: false,
      );

      if (res.data is! Map) {
        summaries.value = const <attendance_summary.Data>[];
        return;
      }

      final model = attendance_summary.AttendanceSummery.fromJson(
        Map<String, dynamic>.from(res.data as Map),
      );
      final summary = model.summary ?? const <attendance_summary.Data>[];
      final data = model.data ?? const <attendance_summary.Data>[];
      final listData =
          model.attendancesList?.data ?? const <attendance_summary.Data>[];

      if (summary.isNotEmpty) {
        summaries.value = summary;
      } else if (listData.isNotEmpty) {
        summaries.value = listData;
      } else {
        summaries.value = data;
      }
    } catch (e) {
      summaries.value = const <attendance_summary.Data>[];
      summaryError.value = 'Failed to load attendance summary';
      ExceptionHandler.handleException(e, alert: false);
    } finally {
      isLoadingSummary.value = false;
    }
  }

  int get totalPresent => _sumBy((item) => item.totalPresence);
  int get totalPermission => _sumBy((item) => item.totalPermission);
  int get totalAbsent => _sumBy((item) => item.totalAbsent);
  int get totalLate => _sumBy((item) => item.totalLate);

  int _sumBy(String? Function(attendance_summary.Data) pick) {
    var total = 0;
    for (final item in summaries) {
      total += int.tryParse((pick(item) ?? '0').trim()) ?? 0;
    }
    return total;
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
