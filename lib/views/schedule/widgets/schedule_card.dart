import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/models/schedule/schedule.dart';
import 'package:schoolapp/views/schedule/controller.dart';
import 'package:schoolapp/views/schedule/widgets/schedule_class_item.dart';
<<<<<<< HEAD
import 'package:schoolapp/views/start/widgets/custom_indicator.dart';
=======
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576

class ScheduleCardWidget extends StatefulWidget {
  const ScheduleCardWidget({super.key});

  @override
  State<ScheduleCardWidget> createState() => _ScheduleCardWidgetState();
}

class _ScheduleCardWidgetState extends State<ScheduleCardWidget> {
  final ScheduleController controller = Get.find<ScheduleController>();
  int selectedDayIndex = 0;

  static const List<String> _dayKeys = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

<<<<<<< HEAD
  List<String> get _dayLabels => [
    LocaleKeys.mondayShort.tr,
    LocaleKeys.tuesdayShort.tr,
    LocaleKeys.wednesdayShort.tr,
    LocaleKeys.thursdayShort.tr,
    LocaleKeys.fridayShort.tr,
    LocaleKeys.saturdayShort.tr,
    LocaleKeys.sundayShort.tr,
=======
  static const List<String> _dayLabels = [
    'ចន្ទ',
    'អង្គារ',
    'ពុធ',
    'ព្រហស្បតិ៍',
    'សុក្រ',
    'សៅរ៍',
    'អាទិត្យ',
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.value.isNotEmpty) {
        return NoDataWidget(text: controller.error.value);
      }

      final dayKey = _dayKeys[selectedDayIndex];
      final items = controller.schedules[dayKey] ?? const <ScheduleItem>[];
<<<<<<< HEAD
      final isTeacherMode = !UserRepository.shared.isDriver;
      final classInfo = controller.classInfo.value;
      final parentClassLabel = [
=======
      final classInfo = controller.classInfo.value;
      final classLabel = [
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
        classInfo?.className.trim() ?? '',
        classInfo?.sectionName.trim() ?? '',
      ].where((e) => e.isNotEmpty).join(' - ');

<<<<<<< HEAD
      return LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding =
              constraints.maxWidth < 380
                  ? 16.0
                  : constraints.maxWidth < 520
                  ? 24.0
                  : 36.0;
          final dayPadding = (horizontalPadding - 8).clamp(8.0, 28.0);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  8,
                  horizontalPadding,
                  12,
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: CustomIndicator(progress: 1 / 4),
                ),
              ),
              if (!isTeacherMode)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    10,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth - horizontalPadding * 2,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primaryColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${LocaleKeys.classLabel.tr}:  ${parentClassLabel.isEmpty ? LocaleKeys.noClass.tr : parentClassLabel}',
                          style: const TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              if (isTeacherMode) const SizedBox(height: 4),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: dayPadding),
                child: Row(
                  children: List.generate(_dayLabels.length, (index) {
                    final isSelected = selectedDayIndex == index;
                    return GestureDetector(
                      onTap: () => _changeDay(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 42),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color:
                                    isSelected
                                        ? AppColor.primaryColor
                                        : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            _dayLabels[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  isSelected
                                      ? AppColor.primaryColor
                                      : Colors.grey,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: const Divider(height: 1.2),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragEnd: _handleDaySwipe,
                  child:
                      items.isEmpty
                          ? const NoDataWidget()
                          : ListView.builder(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            20,
                            horizontalPadding,
                            16,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return ScheduleClassItem(
                              session:
                                  item.session.isEmpty
                                      ? '${LocaleKeys.sessionNumber.tr} ${index + 1}'
                                      : item.session,
                              time: item.time.isEmpty ? '-' : item.time,
                              subject:
                                  item.subject.isEmpty ? '-' : item.subject,
                              teacher:
                                  item.teacher.isEmpty ? '-' : item.teacher,
                              isTeacherMode: isTeacherMode,
                              classLabel: _classLabelForItem(item),
                              room: item.room.isEmpty ? '-' : item.room,
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  void _handleDaySwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < 120) {
      return;
    }

    if (velocity < 0) {
      _changeDay(selectedDayIndex + 1);
    } else {
      _changeDay(selectedDayIndex - 1);
    }
  }

  void _changeDay(int index) {
    final next = index.clamp(0, _dayKeys.length - 1).toInt();
    if (next == selectedDayIndex) {
      return;
    }
    setState(() => selectedDayIndex = next);
  }

  String _classLabelForItem(ScheduleItem item) {
    final label = [
      item.className.trim(),
      item.sectionName.trim(),
    ].where((e) => e.isNotEmpty).join(' - ');
    return label.isEmpty ? '-' : label;
=======
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(36, 16, 36, 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.primaryColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Class:  ${classLabel.isEmpty ? 'No class' : classLabel}',
                style: const TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'battambang',
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Row(
              children: List.generate(_dayLabels.length, (index) {
                final isSelected = selectedDayIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedDayIndex = index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                isSelected
                                    ? AppColor.primaryColor
                                    : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        _dayLabels[index],
                        style: TextStyle(
                          fontFamily: 'Battambang',
                          fontSize: 14,
                          color:
                              isSelected ? AppColor.primaryColor : Colors.grey,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.0),
            child: Divider(height: 1.2),
          ),
          Expanded(
            child:
                items.isEmpty
                    ? const NoDataWidget()
                    : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(36, 24, 36, 16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ScheduleClassItem(
                          session:
                              item.session.isEmpty
                                  ? 'ម៉ោងទី ${index + 1}'
                                  : item.session,
                          time: item.time.isEmpty ? '-' : item.time,
                          subject: item.subject.isEmpty ? '-' : item.subject,
                          teacher: item.teacher.isEmpty ? '-' : item.teacher,
                          room: item.room.isEmpty ? '-' : item.room,
                        );
                      },
                    ),
          ),
        ],
      );
    });
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
  }
}
