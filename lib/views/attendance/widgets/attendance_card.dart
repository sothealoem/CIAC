import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  controller.summaries
                      .map((item) => _buildCard(item))
                      .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCard(attendance_summary.Data item) {
    final className = (item.classroom ?? '').trim();
    final section = (item.section ?? '').trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (item.firstnamekh ?? item.firstname ?? 'Student').trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Class: ${className.isEmpty ? '-' : className}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                ),
                Text(
                  'Section: ${section.isEmpty ? '-' : section}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            height: 30,
            width: 82,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _statusColor(item),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _statusText(item),
              style: const TextStyle(color: Colors.white, fontSize: 11),
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

  Widget _buildAvatar() {
    return const CircleAvatar(
      radius: 21,
      child: Icon(Icons.person, size: 22),
    );
  }
}
