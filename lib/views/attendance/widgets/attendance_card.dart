import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/core/widgets/attendance/summary_item.dart';
import 'package:schoolapp/models/attendance_summery/attendance_summery.dart'
    as attendance_summary;
import 'package:schoolapp/views/attendance/controller.dart';
import 'package:schoolapp/views/attendance/widgets/attendance_status_card.dart';

class AttendanceCardWidget extends GetView<AttendanceController> {
  const AttendanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Obx(() {
            final present = AppStatusStyles.attendance('Present');
            final late = AppStatusStyles.attendance('Late');
            final absent = AppStatusStyles.attendance('Absent');
            final permission = AppStatusStyles.attendance('Permission');

            return Row(
              children: [
                SummaryItem(
                  label: present.label,
                  count: controller.totalPresent.toString(),
                  color: present.color,
                  isActive: controller.selectedStatusFilter.value == 'Present',
                  onTap: () => controller.toggleStatusFilter('Present'),
                ),
                SummaryItem(
                  label: late.label,
                  count: controller.totalLate.toString(),
                  color: late.color,
                  isActive: controller.selectedStatusFilter.value == 'Late',
                  onTap: () => controller.toggleStatusFilter('Late'),
                ),
                SummaryItem(
                  label: absent.label,
                  count: controller.totalAbsent.toString(),
                  color: absent.color,
                  isActive: controller.selectedStatusFilter.value == 'Absent',
                  onTap: () => controller.toggleStatusFilter('Absent'),
                ),
                SummaryItem(
                  label: permission.label,
                  count: controller.totalPermission.toString(),
                  color: permission.color,
                  isActive:
                      controller.selectedStatusFilter.value == 'Permission',
                  onTap: () => controller.toggleStatusFilter('Permission'),
                ),
              ],
            );
          }),
          20.height,
          Obx(() {
            if (controller.isLoadingSummary.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.summaries.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  LocaleKeys.noAttendanceLogsFound.tr,
                  style: const TextStyle(color: Colors.grey),
                ),
              );
            }

            var cards = controller.summaries
                .expand(_expandCards)
                .toList(growable: false);

            final selected = controller.selectedStatusFilter.value;
            if (selected != null && selected.isNotEmpty) {
              if (selected.toLowerCase() == 'present') {
                cards = cards
                    .where(
                      (card) =>
                          card.status.toLowerCase() == 'present' ||
                          card.status.toLowerCase() == 'late',
                    )
                    .toList(growable: false);
              } else {
                cards = cards
                    .where(
                      (card) =>
                          card.status.toLowerCase() == selected.toLowerCase(),
                    )
                    .toList(growable: false);
              }
            }

            if (cards.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  LocaleKeys.noAttendanceLogsFound.tr,
                  style: const TextStyle(color: Colors.grey),
                ),
              );
            }

            return Column(
              children:
                  cards
                      .map((card) => AttendanceStatusCard(card: card))
                      .toList(growable: false),
            );
          }),
        ],
      ),
    );
  }

  List<AttendanceStatusCardData> _expandCards(attendance_summary.Data item) {
    final studentName =
        (item.firstnamekh ?? item.firstname ?? 'Student').trim();
    final className = (item.classroom ?? '').trim();
    final section = (item.section ?? '').trim();
    final classSection =
        className.isEmpty && section.isEmpty
            ? '-'
            : section.isEmpty
            ? className
            : '$className "$section"';

    final present = int.tryParse((item.totalPresence ?? '0').trim()) ?? 0;
    final late = int.tryParse((item.totalLate ?? '0').trim()) ?? 0;
    final absent = int.tryParse((item.totalAbsent ?? '0').trim()) ?? 0;
    final permission = int.tryParse((item.totalPermission ?? '0').trim()) ?? 0;

    final list = <AttendanceStatusCardData>[];

    void addIfPositive(int count, String status) {
      if (count <= 0) return;
      list.add(
        AttendanceStatusCardData(
          studentName: studentName,
          classSection: classSection,
          dateText: DateFormat('dd MMM yyyy').format(DateTime.now()),
          status: status,
          count: count,
        ),
      );
    }

    addIfPositive(absent, 'Absent');
    addIfPositive(permission, 'Permission');
    addIfPositive(late, 'Late');
    addIfPositive(present, 'Present');

    return list;
  }
}
