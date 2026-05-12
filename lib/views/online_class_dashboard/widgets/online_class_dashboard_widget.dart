import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';

part 'online_class_dashboard_parent.dart';
part 'online_class_dashboard_shared.dart';
part 'online_class_dashboard_teacher.dart';
part 'online_class_dashboard_teacher_panels.dart';

const Color _onlineClassAccent = Color(0xFF2F6FBD);
const Color _onlineClassAccentSoft = Color(0xFFEAF3FF);
const Color _onlineClassAccentLight = Colors.white;
const Color _onlineClassBorder = Color(0xFFDDE7F3);
const Color _onlineClassWarmRed = Color(0xFFE06B5A);

class OnlineClassDashboardWidget extends StatelessWidget {
  const OnlineClassDashboardWidget({super.key});

  bool get _isParentRole => UserRepository.shared.isDriver;

  @override
  Widget build(BuildContext context) {
    return _isParentRole
        ? const _ParentClassDashboard()
        : const _TeacherClassDashboard();
  }
}
