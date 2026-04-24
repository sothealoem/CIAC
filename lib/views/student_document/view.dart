import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ciac_school/core/constants/ui_constants.dart';
import 'package:ciac_school/core/extensions/int.dart';
import 'package:ciac_school/views/start/widgets/custom_indicator.dart';
import 'package:ciac_school/views/start/widgets/customize_app_bar.dart';
import 'package:ciac_school/views/student_document/controller.dart';
import 'package:ciac_school/views/student_document/widget/student_document.dart';

class StudentDocumentView extends GetView<StudentDocumentController> {
  const StudentDocumentView({super.key});

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
              title: 'ព័ត៌មានប្រវត្ដិរូបសិស្ស',
              subTitle: 'លោកអ្នកអាចតាមដានពី ស្ថានភាពកូនៗ បាននៅខាងក្រោម៖',
            ),
          ),
          UIConstants.spacingSmall.height,
          CustomIndicator(progress: 1 / 4),
          StudentDocumentWidget(),
        ],
      ),
    );
  }
}
