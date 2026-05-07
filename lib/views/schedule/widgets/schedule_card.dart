import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/models/schedule/schedule.dart';
import 'package:schoolapp/views/schedule/controller.dart';
import 'package:schoolapp/views/schedule/widgets/schedule_class_item.dart';

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

  static const List<String> _dayLabels = [
    'ចន្ទ',
    'អង្គារ',
    'ពុធ',
    'ព្រហស្បតិ៍',
    'សុក្រ',
    'សៅរ៍',
    'អាទិត្យ',
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
      final isTeacherMode = !UserRepository.shared.isDriver;
      final classInfo = controller.classInfo.value;
      final parentClassLabel = [
        classInfo?.className.trim() ?? '',
        classInfo?.sectionName.trim() ?? '',
      ].where((e) => e.isNotEmpty).join(' - ');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isTeacherMode)
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 16, 36, 10),
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
                  'Class:  ${parentClassLabel.isEmpty ? 'No class' : parentClassLabel}',
                  style: const TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          if (isTeacherMode) const SizedBox(height: 16),
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
                          isTeacherMode: isTeacherMode,
                          classLabel: _classLabelForItem(item),
                          room: item.room.isEmpty ? '-' : item.room,
                        );
                      },
                    ),
          ),
        ],
      );
    });
  }

  String _classLabelForItem(ScheduleItem item) {
    final label = [
      item.className.trim(),
      item.sectionName.trim(),
    ].where((e) => e.isNotEmpty).join(' - ');
    return label.isEmpty ? '-' : label;
  }
}
