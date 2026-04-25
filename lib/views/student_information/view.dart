import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/views/start/widgets/customize_app_bar.dart';
import 'package:schoolapp/views/views.dart';

class StudentInformationView extends GetView<StudentInformationController> {
  const StudentInformationView({super.key});

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
            child: CustomizeAppBar(
              title: 'ព័ត៌មានប្រវត្ដិរូបសិស្ស',
              subTitle: 'សូមត្រួតពិនិត្យ',
            ),
          ),
          StudentProfileWidget(),
        ],
      ),
    );
  }
}
