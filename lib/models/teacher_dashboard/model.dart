class TeacherDashboardModel {
  const TeacherDashboardModel({
    required this.totalClasses,
    required this.totalStudents,
  });

  final int totalClasses;
  final int totalStudents;

  factory TeacherDashboardModel.fromJson(Map<String, dynamic> json) {
    return TeacherDashboardModel(
      totalClasses: _asInt(json['total_classes']),
      totalStudents: _asInt(json['total_students']),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse((value ?? '').toString()) ?? 0;
  }
}
