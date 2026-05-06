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
          Obx(
            () => _ProfileActionBar(
              title:
                  controller.isTeacherMode.value
                      ? 'Teacher Profile'
                      : 'Student Profile',
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

class _ProfileActionBar extends StatelessWidget {
  const _ProfileActionBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
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
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF006E6D),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
