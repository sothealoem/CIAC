import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/views/start/widgets/custom_indicator.dart';
import 'package:schoolapp/views/start/widgets/customize_app_bar.dart';
import 'package:schoolapp/views/views.dart';

class OnlineCoursesView extends GetView<OnlineCoursesController> {
  const OnlineCoursesView({super.key});

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
          const SafeArea(
            child: CustomizeAppBar(
              title: 'កម្មវិធីសិក្សាផ្សេងៗ',
              subTitle: 'សូមរៀនដោយយកចិត្តទុកដាក់',
            ),
          ),

          // UIConstants.spacingSmall.height,
          const CustomIndicator(progress: 1 / 4),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(),
              child: const OnlineCoursesCardWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
