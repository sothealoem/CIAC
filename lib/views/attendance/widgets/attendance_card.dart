import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/core/widgets/attendance/summary_item.dart';
import 'package:schoolapp/models/attendance_summery/attendance_summery.dart'
    as attendance_summary;
import 'package:schoolapp/views/attendance/controller.dart';

class AttendanceCardWidget extends GetView<AttendanceController> {
  const AttendanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Obx(
            () => Row(
              children: [
                SummaryItem(
                  label: 'Present',
                  count: controller.totalPresent.toString(),
                  color: Colors.green,
                  isActive: controller.selectedStatusFilter.value == 'Present',
                  onTap: () => controller.toggleStatusFilter('Present'),
                ),
                SummaryItem(
                  label: 'Late',
                  count: controller.totalLate.toString(),
                  color: Colors.orange,
                  isActive: controller.selectedStatusFilter.value == 'Late',
                  onTap: () => controller.toggleStatusFilter('Late'),
                ),
                SummaryItem(
                  label: 'Absent',
                  count: controller.totalAbsent.toString(),
                  color: Colors.red,
                  isActive: controller.selectedStatusFilter.value == 'Absent',
                  onTap: () => controller.toggleStatusFilter('Absent'),
                ),
                SummaryItem(
                  label: 'Permission',
                  count: controller.totalPermission.toString(),
                  color: Colors.blue,
                  isActive:
                      controller.selectedStatusFilter.value == 'Permission',
                  onTap: () => controller.toggleStatusFilter('Permission'),
                ),
              ],
            ),
          ),
          20.height,
          Obx(() {
            if (controller.isLoadingSummary.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.summaries.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No attendance logs found.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            var cards = controller.summaries
                .expand(_expandCards)
                .toList(growable: false);

            final selected = controller.selectedStatusFilter.value;
            if (selected != null && selected.isNotEmpty) {
              if (selected.toLowerCase() == 'present') {
                cards =
                    cards
                        .where(
                          (card) =>
                              card.status.toLowerCase() == 'present' ||
                              card.status.toLowerCase() == 'late',
                        )
                        .toList(growable: false);
              } else {
                cards =
                    cards
                        .where(
                          (card) =>
                              card.status.toLowerCase() ==
                              selected.toLowerCase(),
                        )
                        .toList(growable: false);
              }
            }

            if (cards.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No attendance logs found.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return Column(
              children: cards.map(_buildCard).toList(growable: false),
            );
          }),
        ],
      ),
    );
  }

  List<_AttendanceStatusCardData> _expandCards(attendance_summary.Data item) {
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

    final list = <_AttendanceStatusCardData>[];

    void addIfPositive(int count, String status) {
      if (count <= 0) return;
      list.add(
        _AttendanceStatusCardData(
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

  Widget _buildCard(_AttendanceStatusCardData card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line('និស្ស័យឈ្មោះ', card.studentName),
                const SizedBox(height: 4),
                _line('ថ្នាក់រៀន', card.classSection),
                const SizedBox(height: 4),
                _line('កាលបរិច្ឆេទ', card.dateText),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            margin: const EdgeInsets.only(top: 18),
            width: 110,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _statusColor(card.status),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${_statusTextKh(card.status)}',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Battambang',
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontFamily: 'Battambang',
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Battambang',
              fontSize: 13,
              color: Color(0xFF555555),
            ),
          ),
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Late':
        return Colors.orange;
      case 'Absent':
        return Colors.red;
      case 'Permission':
        return Colors.blue;
      default:
        return const Color(0xFF4CAF50);
    }
  }

  String _statusTextKh(String status) {
    switch (status) {
      case 'Late':
        return 'យឺត';
      case 'Absent':
        return 'អវត្តមាន';
      case 'Permission':
        return 'ច្បាប់';
      default:
        return 'វត្តមាន';
    }
  }
}

class _AttendanceStatusCardData {
  const _AttendanceStatusCardData({
    required this.studentName,
    required this.classSection,
    required this.dateText,
    required this.status,
    required this.count,
  });

  final String studentName;
  final String classSection;
  final String dateText;
  final String status;
  final int count;
}
