import 'package:flutter/material.dart';
import 'package:swis_school/core/configs/app_style.dart';

class AttendanceCardWidget extends StatelessWidget {
  const AttendanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              _buildSummaryItem('មករៀន', '២៥', Colors.green),
              _buildSummaryItem('សុំច្បាប់', '២', Colors.blue),
              _buildSummaryItem('អវត្តមាន', '៣', Colors.red),
              _buildSummaryItem('មកយឺត', '១', Colors.orange),
            ],
          ),
          const SizedBox(height: 20),

          _buildAttendanceCard(
            'សុខ សាន្ត',
            'ថ្នាក់ទី ៧ "ក"',
            '07-05-2023',
            'មករៀន',
            Colors.teal,
          ),
          _buildAttendanceCard(
            'សុខ សាន្ត',
            'ថ្នាក់ទី ៧ "ក"',
            '07-05-2023',
            'សុំច្បាប់',
            Colors.blue,
          ),
          _buildAttendanceCard(
            'សុខ សាន្ត',
            'ថ្នាក់ទី ៧ "ក"',
            '07-05-2023',
            'អវត្តមាន',
            Colors.red,
          ),
          _buildAttendanceCard(
            'សុខ សាន្ត',
            'ថ្នាក់ទី ៧ "ក"',
            '07-05-2023',
            'មកយឺត',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  // Widget for the top summary statistics
  Widget _buildSummaryItem(String label, String count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),

        padding: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(2.0),
        ),

        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(2.0),
            bottomRight: Radius.circular(2.0),
          ),
          child: Column(
            children: [
              Text(label, style: AppTextStyle.mendiumPrimaryBold),
              const SizedBox(height: 4),
              Text(
                count,
                style: TextStyle(
                  fontFamily: 'battambang',
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 4,
                width: double.infinity,
                color: AppColor.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for the individual attendance rows
  Widget _buildAttendanceCard(
    String name,
    String grade,
    String date,
    String status,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$name  $grade', style: AppTextStyle.mendiumPrimary),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(date, style: AppTextStyle.mendiumPrimary),
                ],
              ),
            ],
          ),
          Container(
            width: 80,

            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(status, style: AppTextStyle.regularPrimarytext),
          ),
        ],
      ),
    );
  }
}
