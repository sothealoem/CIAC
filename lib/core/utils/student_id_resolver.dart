import 'package:schoolapp/core/libraries/shared_preferences.dart';

class StudentIdResolver {
  StudentIdResolver._();

  static const List<String> _keys = <String>[
    'selected_child_id',
    'student_info_id',
    'last_leave_student_id',
  ];

  static Future<int?> resolve() async {
    for (final key in _keys) {
      final raw =
          (await SharedPreferencesManager.get(key) ?? '').toString().trim();
      if (raw.isEmpty) continue;

      final parsed = int.tryParse(raw);
      if (parsed != null) {
        return parsed;
      }
    }
    return null;
  }
}
