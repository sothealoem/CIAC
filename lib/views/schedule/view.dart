import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/core/constants/ui_constants.dart';
import 'package:schoolapp/core/extensions/int.dart';
import 'package:schoolapp/views/start/widgets/custom_indicator.dart';
import 'package:schoolapp/views/start/widgets/customize_app_bar.dart';
import 'package:schoolapp/views/views.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: CustomizeAppBar(
              title: LocaleKeys.scheduleTitle.tr,
              subTitle: LocaleKeys.scheduleSubTitle.tr,
            ),
          ),
          UIConstants.spacingSmall.height,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomIndicator(progress: 1 / 4),
            ),
          ),
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
