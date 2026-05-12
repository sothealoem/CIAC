class ScheduleResponse {
  ScheduleResponse({
    required this.classInfo,
    required this.data,
  });

  final ScheduleClassInfo? classInfo;
  final Map<String, List<ScheduleItem>> data;

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    final rawClassInfo = json['class_info'];
    final rawData = json['data'];
    final schedules = <String, List<ScheduleItem>>{};

    if (rawData is Map) {
      for (final entry in rawData.entries) {
        final value = entry.value;
        if (value is List) {
          schedules[entry.key.toString()] =
              value
                  .whereType<Map>()
                  .map(
                    (e) => ScheduleItem.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList();
        } else {
          schedules[entry.key.toString()] = <ScheduleItem>[];
        }
      }
    }

    return ScheduleResponse(
      classInfo:
          rawClassInfo is Map
              ? ScheduleClassInfo.fromJson(
                Map<String, dynamic>.from(rawClassInfo),
              )
              : null,
      data: schedules,
    );
  }
}

class ScheduleClassInfo {
  ScheduleClassInfo({
    required this.className,
    required this.sectionName,
  });

  final String className;
  final String sectionName;

  factory ScheduleClassInfo.fromJson(Map<String, dynamic> json) {
    return ScheduleClassInfo(
<<<<<<< HEAD
      className: (json['class_name'] ?? json['class'] ?? '').toString(),
      sectionName: (json['section_name'] ?? json['section'] ?? '').toString(),
=======
      className: (json['class_name'] ?? '').toString(),
      sectionName: (json['section_name'] ?? '').toString(),
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
    );
  }
}

class ScheduleItem {
  ScheduleItem({
    required this.session,
    required this.time,
    required this.subject,
    required this.teacher,
<<<<<<< HEAD
    required this.className,
    required this.sectionName,
=======
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
    required this.room,
  });

  final String session;
  final String time;
  final String subject;
  final String teacher;
<<<<<<< HEAD
  final String className;
  final String sectionName;
=======
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
  final String room;

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      session: _pick(json, [
        'session',
        'session_name',
        'period',
        'period_name',
        'time_name',
      ]),
      time: _time(json),
      subject: _pick(json, [
        'subject',
        'subject_name',
        'course',
        'course_name',
      ]),
<<<<<<< HEAD
      teacher: _teacherName(json),
      className: _pick(json, [
        'class_name',
        'class',
        'grade',
        'grade_name',
      ]),
      sectionName: _pick(json, [
        'section_name',
        'section',
        'group',
        'group_name',
      ]),
      room: _pick(json, [
        'room',
        'room_no',
=======
      teacher: _pick(json, [
        'teacher',
        'teacher_name',
        'staff',
        'staff_name',
      ]),
      room: _pick(json, [
        'room',
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
        'room_name',
        'classroom',
      ]),
    );
  }

<<<<<<< HEAD
  static String _teacherName(Map<String, dynamic> json) {
    final direct = _pick(json, [
      'teacher',
      'teacher_name',
      'staff',
      'staff_name',
      'full_name',
    ]);
    if (direct.isNotEmpty) return direct;

    final firstName = _pick(json, ['first_name', 'firstname']);
    final lastName = _pick(json, ['last_name', 'lastname']);
    return [firstName, lastName].where((part) => part.isNotEmpty).join(' ');
  }

=======
>>>>>>> d40f443f6abd648abf33b013d71b0d2ff622a576
  static String _time(Map<String, dynamic> json) {
    final direct = _pick(json, [
      'time',
      'time_range',
      'study_time',
      'start_end_time',
    ]);
    if (direct.isNotEmpty) return direct;

    final start = _pick(json, ['start_time', 'from_time']);
    final end = _pick(json, ['end_time', 'to_time']);
    if (start.isNotEmpty && end.isNotEmpty) {
      return '${_formatTime(start)} - ${_formatTime(end)}';
    }
    return _formatTime(start.isNotEmpty ? start : end);
  }

  static String _formatTime(String value) {
    final parts = value.split(':');
    if (parts.length < 2) return value;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return value;

    return '$hour:${minute.toString().padLeft(2, '0')}';
  }

  static String _pick(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key]?.toString().trim() ?? '';
      if (value.isNotEmpty && value.toLowerCase() != 'null') {
        return value;
      }
    }
    return '';
  }
}
