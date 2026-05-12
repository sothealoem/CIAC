import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/get.dart';
=======
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
import 'package:schoolapp/core/core.dart';

class ScheduleClassItem extends StatelessWidget {
  const ScheduleClassItem({
    super.key,
    required this.session,
    required this.time,
    required this.subject,
    required this.teacher,
<<<<<<< HEAD
    required this.isTeacherMode,
    required this.classLabel,
=======
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
    required this.room,
  });

  final String session;
  final String time;
  final String subject;
  final String teacher;
<<<<<<< HEAD
  final bool isTeacherMode;
  final String classLabel;
=======
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
  final String room;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
<<<<<<< HEAD
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 330;
          final timeWidth = compact ? 74.0 : 94.0;
          final gap = compact ? 8.0 : 14.0;
          final detailPadding = compact ? 12.0 : 16.0;
          final subjectSize = compact ? 14.0 : 16.0;
          final detailSize = compact ? 12.0 : 14.0;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: timeWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    Text(
                      session,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      width: 24,
                      height: 68,
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
                        constraints: const BoxConstraints(minHeight: 68),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: detailPadding,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${LocaleKeys.sessionNumber.tr} : $subject',
                                style: AppTextStyle.mendiumPrimaryBold
                                    .copyWith(fontSize: subjectSize),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isTeacherMode
                                    ? '${LocaleKeys.classLabel.tr} : $classLabel  |  ${LocaleKeys.roomLabel.tr} $room'
                                    : '${LocaleKeys.teacherLabel.tr} : $teacher  |  ${LocaleKeys.roomLabel.tr} $room',
                                style: AppTextStyle.mendiumPrimary.copyWith(
                                  fontSize: detailSize,
                                  height: 1.25,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
          );
        },
=======
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
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
      ),
    );
  }
}
