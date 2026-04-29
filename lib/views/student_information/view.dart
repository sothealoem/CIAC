import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/views/views.dart';

class StudentInformationView extends GetView<StudentInformationController> {
  const StudentInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF006E6D),
                    ),
                  ),
                  const Text(
                    'ពត៌មានប្រវត្តិសិស្ស',
                    style: TextStyle(
                      fontFamily: 'Battambang',
                      color: Color(0xFF006E6D),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () =>
                controller.isTeacherMode.value
                    ? const TeacherProfileWidget()
                    : const StudentProfileWidget(),
          ),
        ],
      ),
    );
  }
}
