import 'package:flutter/material.dart';
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
          const SafeArea(
            bottom: false,
            child: CustomizeAppBar(
              title: 'កាលវិភាគសិក្សា',
              subTitle:
                  'លោកអ្នកអាចដឹងពីសកម្មភាពកូនៗ របស់លោកអ្នកពេលកំពុងសិក្សាបាន៖',
            ),
          ),
          UIConstants.spacingSmall.height,
          const CustomIndicator(progress: 1 / 4),
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
