import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/configs/configs.dart';
import 'package:schoolapp/core/widgets/month_filter_dropdown.dart';
import 'package:schoolapp/views/attendance/controller.dart';

class MonthFilterWidget extends StatelessWidget {
  final AttendanceController controller;

  const MonthFilterWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // List of Khmer months
    final List<String> khmerMonths = [
      'មករា',
      'កុម្ភៈ',
      'មីនា',
      'មេសា',
      'ឧសភា',
      'មិថុនា',
      'កក្កដា',
      'សីហា',
      'កញ្ញា',
      'តុលា',
      'វិច្ឆិកា',
      'ធ្នូ',
    ];

    return Obx(() {
      final selected =
          khmerMonths.contains(controller.selectedMonth.value)
              ? controller.selectedMonth.value
              : khmerMonths.first;
      return Container(
        child: MonthFilterDropdown(
          months: khmerMonths,
          selectedMonth: selected,
          height: 40,
          backgroundColor: Colors.white,
          borderColor: AppColor.primaryColor,
          onSelected: (String month) {
            controller.selectedMonth.value = month;
            controller.filter();
          },
        ),
      );
    });
  }
}
