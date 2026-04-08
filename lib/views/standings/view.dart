import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/constants/ui_constants.dart';
import 'package:swis_school/core/extensions/int.dart';
import 'package:swis_school/views/start/widgets/custom_indicator.dart';
import 'package:swis_school/views/start/widgets/customize_app_bar.dart';
import 'package:swis_school/views/views.dart';

class StandingsView extends GetView<StandingsController> {
  const StandingsView({super.key});

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
              title: 'ពិនិត្យលទ្ធផលពិន្ទុ',
              subTitle: 'លោកអ្នកអាចពិនិត្យលទ្ធផលកូនៗ​ បាននៅខាងក្រោមនេះ',
            ),
          ),
          UIConstants.spacing.height,
          CustomIndicator(progress: 32),
          UIConstants.spacing.height,
          Expanded(
            child: SingleChildScrollView(
              child: Container(child: StandingsCardWidget()),
            ),
          ),
        ],
      ),
    );
  }
}
