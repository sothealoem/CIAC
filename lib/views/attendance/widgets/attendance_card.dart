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
                ),
                SummaryItem(
                  label: 'Late',
                  count: controller.totalLate.toString(),
                  color: Colors.orange,
                ),
                SummaryItem(
                  label: 'Absent',
                  count: controller.totalAbsent.toString(),
                  color: Colors.red,
                ),
                SummaryItem(
                  label: 'Permission',
                  count: controller.totalPermission.toString(),
                  color: Colors.blue,
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

            return Column(
              children:
                  controller.summaries.map((item) => _buildCard(item)).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCard(attendance_summary.Data item) {
    final className = (item.classroom ?? '').trim();
    final section = (item.section ?? '').trim();
    final dateText = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final studentName =
        (item.firstnamekh ?? item.firstname ?? 'Student').trim();
    final classSection =
        className.isEmpty && section.isEmpty
            ? '-'
            : section.isEmpty
            ? className
            : '$className "$section"';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD6D6D6)),
      ),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$studentName   ថ្នាក់ទី $classSection',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    fontFamily: 'Battambang',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      dateText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Battambang',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            height: 34,
            width: 88.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF006E6D),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              _statusTextKh(item),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Battambang',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(attendance_summary.Data item) {
    final absent = int.tryParse((item.totalAbsent ?? '0').trim()) ?? 0;
    final permission = int.tryParse((item.totalPermission ?? '0').trim()) ?? 0;
    final late = int.tryParse((item.totalLate ?? '0').trim()) ?? 0;

    if (absent > 0) {
      return Colors.red;
    }
    if (permission > 0) {
      return Colors.blue;
    }
    if (late > 0) {
      return Colors.orange;
    }
    return Colors.green;
  }

  String _statusText(attendance_summary.Data item) {
    final absent = int.tryParse((item.totalAbsent ?? '0').trim()) ?? 0;
    final permission = int.tryParse((item.totalPermission ?? '0').trim()) ?? 0;
    final late = int.tryParse((item.totalLate ?? '0').trim()) ?? 0;

    if (absent > 0) {
      return 'Absent';
    }
    if (permission > 0) {
      return 'Permission';
    }
    if (late > 0) {
      return 'Late';
    }
    return 'Present';
  }

  String _statusTextKh(attendance_summary.Data item) {
    final status = _statusText(item);
    switch (status) {
      case 'Late':
        return 'យឺត';
      case 'Absent':
        return 'អវត្តមាន';
      case 'Permission':
        return 'សុំច្បាប់';
      default:
        return 'វត្តមាន';
    }
  }
}
