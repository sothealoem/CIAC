import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/models/models.dart';

class ScheduleController extends GetxController {
  final TextEditingController searchCtl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxMap<String, List<ScheduleItem>> schedules =
      <String, List<ScheduleItem>>{}.obs;
  final Rxn<ScheduleClassInfo> classInfo = Rxn<ScheduleClassInfo>();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStudentTimeSheet();
  }

  @override
  void onClose() {
    searchCtl.dispose();
    super.onClose();
  }

  Future<void> fetchStudentTimeSheet() async {
    isLoading.value = true;
    error.value = '';

    try {
<<<<<<< HEAD
      final isParent = UserRepository.shared.isDriver;
      final studentId = isParent ? await StudentIdResolver.resolve() : null;
      if (isParent && studentId == null) {
        schedules.clear();
        classInfo.value = null;
        error.value = LocaleKeys.scheduleStudentRequired.tr;
=======
      final studentId = await _resolveStudentId();
      if (studentId == null) {
        schedules.clear();
        classInfo.value = null;
        error.value = 'Student ID is required.';
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
        return;
      }

      final res = await Get.find<ApiService>().get(
<<<<<<< HEAD
        isParent ? EndPoints.studentTimeSheet : EndPoints.teacherTimeSheet,
        queryParameters: isParent ? {'student_id': studentId} : null,
=======
        EndPoints.studentTimeSheet,
        queryParameters: {'student_id': studentId},
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
        isShowLoading: false,
      );

      if (res.data is! Map) {
        schedules.clear();
        classInfo.value = null;
<<<<<<< HEAD
        error.value = LocaleKeys.invalidResponseData.tr;
=======
        error.value = 'Invalid response data.';
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
        return;
      }

      _setScheduleFromJson(Map<String, dynamic>.from(res.data as Map));
    } catch (e) {
      debugPrint('Failed to load schedule: $e');
      schedules.clear();
      classInfo.value = null;
<<<<<<< HEAD
      error.value = LocaleKeys.failedToLoadSchedule.tr;
=======
      error.value = 'Failed to load schedule.';
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
      ExceptionHandler.handleException(e, alert: false);
    } finally {
      isLoading.value = false;
    }
  }

  void _setScheduleFromJson(Map<String, dynamic> json) {
    final model = ScheduleResponse.fromJson(json);
    classInfo.value = model.classInfo;
    schedules.assignAll(model.data);
  }
<<<<<<< HEAD
=======

  Future<int?> _resolveStudentId() async {
    final keys = <String>[
      'selected_child_id',
      'student_info_id',
      'last_leave_student_id',
    ];

    for (final key in keys) {
      final raw =
          (await SharedPreferencesManager.get(key) ?? '').toString().trim();
      if (raw.isEmpty) continue;
      final parsed = int.tryParse(raw);
      if (parsed != null) return parsed;
    }
    return null;
  }
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
}
