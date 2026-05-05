import 'package:flutter/material.dart';
import 'package:schoolapp/core/core.dart';

class ScheduleClassItem extends StatelessWidget {
  const ScheduleClassItem({
    super.key,
    required this.session,
    required this.time,
    required this.subject,
    required this.teacher,
    required this.room,
  });

  final String session;
  final String time;
  final String subject;
  final String teacher;
  final String room;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 94,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                Text(
                  session,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Battambang',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 11,
                      color: Color(0xFF4F5A5A),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        time,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Battambang',
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  width: 26,
                  height: 66,
                  decoration: const BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      bottomLeft: Radius.circular(22),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 66),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ម៉ោង : $subject',
                                    style: AppTextStyle.mendiumPrimaryBold,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'លោកគ្រូ : $teacher  |  បន្ទប់ $room',
                                    style: AppTextStyle.mendiumPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
