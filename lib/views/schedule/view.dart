import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/constants/ui_constants.dart';
import 'package:swis_school/core/extensions/int.dart';
import 'package:swis_school/views/start/widgets/custom_indicator.dart';
import 'package:swis_school/views/start/widgets/customize_app_bar.dart';
import 'package:swis_school/views/views.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});

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
              title: 'កាលវិភាគសិក្សា',
              subTitle:
                  'លោកអ្នកអាចដឹងពីសកម្មភាពកូនៗ របស់លោកអ្នកពេលកំពុងសិក្សាបាន៖',
            ),
          ),
          UIConstants.spacingSmall.height,
          CustomIndicator(progress: 1 / 4),
          Expanded(
            child: Container(
              decoration: BoxDecoration(),
              child: ScheduleCardWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
