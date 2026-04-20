import 'package:swis_school/views/attendance_record/controller.dart';
import 'package:swis_school/views/attendance_record/widgets/attendence_record_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/constants/ui_constants.dart';
import 'package:swis_school/core/extensions/int.dart';
import 'package:swis_school/views/attendance/widgets/month_filter.dart';
import 'package:swis_school/views/start/widgets/custom_indicator.dart';

import '../start/widgets/customize_app_bar.dart';

class AttendanceRecordView extends GetView<AttendanceRecordController> {
  const AttendanceRecordView({super.key});

  void onSearch() async {
    if (!controller.formKey.currentState!.validate()) {
      return;
    }
    await controller.fetchTracking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: CustomizeAppBar(
              title: 'កំណត់ត្រាវត្តមាន',
              subTitle: 'លោកអ្នកអាចដឹងពីវត្តមាន កូនៗរបស់លោកអ្នកពេលកំពុងសិក្សា',
            ),
          ),
          UIConstants.spacingSmall.height,

          CustomIndicator(progress: 1 / 4),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(),
                child: AttendenceRecordCardWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
