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
      final isParent = UserRepository.shared.isDriver;
      final studentId = isParent ? await StudentIdResolver.resolve() : null;
      if (isParent && studentId == null) {
        schedules.clear();
        classInfo.value = null;
        error.value = 'Student ID is required.';
        return;
      }

      final res = await Get.find<ApiService>().get(
        isParent ? EndPoints.studentTimeSheet : EndPoints.teacherTimeSheet,
        queryParameters: isParent ? {'student_id': studentId} : null,
        isShowLoading: false,
      );

      if (res.data is! Map) {
        schedules.clear();
        classInfo.value = null;
        error.value = 'Invalid response data.';
        return;
      }

      _setScheduleFromJson(Map<String, dynamic>.from(res.data as Map));
    } catch (e) {
      debugPrint('Failed to load schedule: $e');
      schedules.clear();
      classInfo.value = null;
      error.value = 'Failed to load schedule.';
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
}
