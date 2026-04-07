import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/views/views.dart';

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
              title: 'លទ្ធផលការសិក្សា',
              subTitle: 'លោកអ្នកអាចពិនិត្យ',
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  // image: DecorationImage(
                  // image: AssetImage("assets/images/sc-background.jpg"),
                  // fit: BoxFit.fill,
                  // ),
                ),
                child: AttendanceCardWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
