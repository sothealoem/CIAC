import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ciac_school/core/constants/ui_constants.dart';
import 'package:ciac_school/core/extensions/int.dart';
import 'package:ciac_school/views/attendance/widgets/month_filter.dart';
import 'package:ciac_school/views/start/widgets/custom_indicator.dart';
import 'package:ciac_school/views/views.dart';

import '../start/widgets/customize_app_bar.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

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
              title: 'ពិនិត្យវត្តមានកូនៗ',
              subTitle: 'សូមពិនិត្យវត្តមានកូនៗ​ របស់លោកអ្នកខាងក្រោមនេះ',
              trailing: MonthFilterWidget(controller: controller),
            ),
          ),
          UIConstants.spacingSmall.height,

          CustomIndicator(progress: 1 / 4),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(),
                child: AttendanceCardWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
