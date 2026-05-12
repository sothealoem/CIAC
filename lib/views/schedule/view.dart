import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
=======
import 'package:schoolapp/core/constants/ui_constants.dart';
import 'package:schoolapp/core/extensions/int.dart';
import 'package:schoolapp/views/start/widgets/custom_indicator.dart';
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
import 'package:schoolapp/views/start/widgets/customize_app_bar.dart';
import 'package:schoolapp/views/views.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SafeArea(
            bottom: false,
            child: CustomizeAppBar(
              title: LocaleKeys.scheduleTitle.tr,
              subTitle: LocaleKeys.scheduleSubTitle.tr,
              teacherSubTitle: LocaleKeys.scheduleTeacherSubTitle.tr,
            ),
          ),
<<<<<<< HEAD
=======
          UIConstants.spacingSmall.height,
          const CustomIndicator(progress: 1 / 4),
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
          Expanded(
            child: Container(
              decoration: const BoxDecoration(),
              child: const ScheduleCardWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
