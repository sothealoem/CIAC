import 'package:schoolapp/views/attendance_record/controller.dart';
import 'package:schoolapp/views/attendance_record/widgets/attendence_record_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/constants/ui_constants.dart';
import 'package:schoolapp/core/extensions/int.dart';
import 'package:schoolapp/views/start/widgets/custom_indicator.dart';
import '../start/widgets/customize_app_bar.dart';

class AttendanceRecordView extends GetView<AttendanceRecordController> {
  const AttendanceRecordView({super.key});

  void onSearch() async {
    if (!controller.formKey.currentState!.validate()) {
      return;
    }
    await controller.loadAttendanceLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SafeArea(
            bottom: false,
            child: CustomizeAppBar(
              title: 'កំណត់ត្រាវត្តមាន',
              subTitle: 'លោកអ្នកអាចដឹងពីវត្តមាន កូនៗរបស់លោកអ្នកពេលកំពុងសិក្សា',
            ),
          ),
          UIConstants.spacingSmall.height,

          const CustomIndicator(progress: 1 / 4),
          Expanded(
            child: SingleChildScrollView(
              child: Container(child: const AttendenceRecordCardWidget()),
            ),
          ),
        ],
      ),
    );
  }
}
