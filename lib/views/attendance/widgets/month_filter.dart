import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/configs/configs.dart';
import 'package:schoolapp/views/attendance/controller.dart'; // Adjust path

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

    return Obx(
      () {
        final selected =
            khmerMonths.contains(controller.selectedMonth.value)
                ? controller.selectedMonth.value
                : khmerMonths.first;
        return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColor.primaryColor),

          borderRadius: BorderRadius.circular(8),
        ),
        child: PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          initialValue: selected,
          onSelected: (String month) {
            controller.selectedMonth.value = month;
            controller.filter(); // Trigger API refresh
          },
          // The design of the button itself
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selected,
                style: const TextStyle(
                  color: Color(0xFF00675B),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.filter_alt_outlined,
                color: Color(0xFF00675B),
                size: 16,
              ),
            ],
          ),

          itemBuilder: (BuildContext context) {
            return khmerMonths.map((String month) {
              return PopupMenuItem<String>(
                value: month,
                child: Text(month, style: const TextStyle(fontSize: 14)),
              );
            }).toList();
          },
        ),
      );
      },
    );
  }
}
