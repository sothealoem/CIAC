import 'package:ciac_school/core/widgets/attendance/custom_card.dart';
import 'package:ciac_school/core/widgets/attendance/summary_item.dart';
import 'package:flutter/material.dart';

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
              SummaryItem(label: 'មករៀន', count: '២៥', color: Colors.green),
              SummaryItem(label: 'សុំច្បាប់', count: '២', color: Colors.blue),
              SummaryItem(label: 'អវត្តមាន', count: '៣', color: Colors.red),
              SummaryItem(label: 'មកយឺត', count: '១', color: Colors.orange),
            ],
          ),
          const SizedBox(height: 20),

          CustomCard(
            name: 'សុខ សាន្ត',
            grade: 'ថ្នាក់ទី ៧ "ក"',
            date: '07-05-2023',
            status: 'មករៀន',
            statusColor: Colors.teal,
          ),
          CustomCard(
            name: 'ចិន​ កក្កដា',
            grade: 'ថ្នាក់ទី ៧ "ក"',
            date: '07-05-2023',
            status: 'មករៀន',
            statusColor: Colors.red,
          ),
          CustomCard(
            name: 'ឌួង រក្សា',
            grade: 'ថ្នាក់ទី ៧ "ក"',
            date: '07-05-2023',
            status: 'មករៀន',
            statusColor: Colors.yellow,
          ),
          CustomCard(
            name: 'ម៉េង ដាវី',
            grade: 'ថ្នាក់ទី ៧ "ក"',
            date: '07-05-2023',
            status: 'មករៀន',
            statusColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
