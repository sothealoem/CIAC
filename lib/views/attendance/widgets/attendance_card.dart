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

            final cards = <AttendanceStatusCardData>[];
            for (var i = 0; i < controller.summaries.length; i++) {
              cards.addAll(
                _expandCards(
                  controller.summaries[i],
                  includeRecordLate: i == 0,
                ),
              );
            }

            final selected = controller.selectedStatusFilter.value;
            if (selected != null && selected.isNotEmpty) {
              if (selected.toLowerCase() == 'present') {
                final filtered = cards
                    .where(
                      (card) =>
                          card.status.toLowerCase() == 'present' ||
                          card.status.toLowerCase() == 'late',
                    )
                    .toList(growable: false);
                cards
                  ..clear()
                  ..addAll(filtered);
              } else {
                final filtered = cards
                    .where(
                      (card) =>
                          card.status.toLowerCase() == selected.toLowerCase(),
                    )
                    .toList(growable: false);
                cards
                  ..clear()
                  ..addAll(filtered);
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
              children: [
                ...cards.map((card) => AttendanceStatusCard(card: card)),
                if (controller.isLoadingMoreSummary.value)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  List<AttendanceStatusCardData> _expandCards(
    attendance_summary.Data item, {
    required bool includeRecordLate,
  }) {
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
    final late =
        includeRecordLate ? controller.attendanceRecordLateCount.value : 0;
    final presentOnly =
        includeRecordLate && late > 0
            ? (present - late < 0 ? 0 : present - late)
            : present;
    final absent = int.tryParse((item.totalAbsent ?? '0').trim()) ?? 0;
    final permission = int.tryParse((item.totalPermission ?? '0').trim()) ?? 0;
    final dateText = _formatDate(item.attendanceDate ?? item.createdAt);

    final list = <AttendanceStatusCardData>[];

    void addByCount(int count, String status) {
      if (count <= 0) return;
      for (var i = 0; i < count; i++) {
        list.add(
          AttendanceStatusCardData(
            studentName: studentName,
            classSection: classSection,
            dateText: dateText,
            status: status,
            count: 1,
          ),
        );
      }
    }

    addByCount(absent, 'Absent');
    addByCount(permission, 'Permission');
    if (includeRecordLate) {
      list.addAll(_lateRecordCards(item));
    } else {
      addByCount(late, 'Late');
    }
    addByCount(presentOnly, 'Present');

    return list;
  }

  List<AttendanceStatusCardData> _lateRecordCards(
    attendance_summary.Data summaryItem,
  ) {
    final fallbackStudentName =
        (summaryItem.firstnamekh ?? summaryItem.firstname ?? 'Student').trim();
    final className = (summaryItem.classroom ?? '').trim();
    final section = (summaryItem.section ?? '').trim();
    final classSection =
        className.isEmpty && section.isEmpty
            ? '-'
            : section.isEmpty
            ? className
            : '$className "$section"';

    return controller.attendanceRecordLateItems.map((item) {
      final recordName = item.displayName.trim();
      final recordDate =
          item.attendanceDate.trim().isNotEmpty
              ? item.attendanceDate
              : item.createdAt;

      return AttendanceStatusCardData(
        studentName: recordName.isEmpty ? fallbackStudentName : recordName,
        classSection: classSection,
        dateText: _formatDate(recordDate),
        status: 'Late',
        count: 1,
      );
    }).toList(growable: false);
  }

  String _formatDate(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) {
      return DateFormat('dd MMM yyyy').format(DateTime.now());
    }

    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return raw;
    }

    return DateFormat('dd MMM yyyy').format(parsed);
  }
}
