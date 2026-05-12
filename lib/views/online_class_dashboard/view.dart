import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/views/online_class_dashboard/widgets/online_class_dashboard_widget.dart';

class OnlineClassDashboardView extends StatelessWidget {
  const OnlineClassDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.onlineClassTitle.tr),
        backgroundColor: AppColor.red,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: AppColor.red,
      ),
      backgroundColor: const Color(0xFFF4F8FC),
      body: const OnlineClassDashboardWidget(),
    );
  }
}
