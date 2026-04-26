class AttendanceSummery {
  bool? success;
  int? statusCode;
  String? message;
  List<Data>? data;

  AttendanceSummery({this.success, this.statusCode, this.message, this.data});

  AttendanceSummery.fromJson(Map<String, dynamic> json) {
    success = json['success'] == true;
    statusCode = _toInt(json['statusCode'] ?? json['status_code']);
    message = json['message']?.toString();

    final rawData = json['data'];
    if (rawData is List) {
      data =
          rawData
              .whereType<dynamic>()
              .map((e) {
                if (e is Map<String, dynamic>) {
                  return Data.fromJson(e);
                }
                if (e is Map) {
                  return Data.fromJson(Map<String, dynamic>.from(e));
                }
                return null;
              })
              .whereType<Data>()
              .toList();
    } else {
      data = <Data>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? studentId;
  String? firstname;
  String? firstnamekh;
  String? classroom;
  String? section;
  String? totalPresence;
  String? totalLate;
  String? totalAbsent;
  String? totalPermission;

  Data({
    this.studentId,
    this.firstname,
    this.firstnamekh,
    this.classroom,
    this.section,
    this.totalPresence,
    this.totalLate,
    this.totalAbsent,
    this.totalPermission,
  });

  Data.fromJson(Map<String, dynamic> json) {
    studentId = _toInt(json['student_id']);
    firstname = json['firstname']?.toString();
    firstnamekh = json['firstnamekh']?.toString();
    classroom = json['class']?.toString();
    section = json['section']?.toString();
    totalPresence = _asCount(json['total_presence']);
    totalLate = _asCount(json['total_late']);
    totalAbsent = _asCount(json['total_absent']);
    totalPermission = _asCount(json['total_permission']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_id'] = studentId;
    data['firstname'] = firstname;
    data['firstnamekh'] = firstnamekh;
    data['class'] = classroom;
    data['section'] = section;
    data['total_presence'] = totalPresence;
    data['total_late'] = totalLate;
    data['total_absent'] = totalAbsent;
    data['total_permission'] = totalPermission;
    return data;
  }
}

int? _toInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value.trim());
  }
  return null;
}

String _asCount(dynamic value) {
  if (value == null) {
    return '0';
  }
  final raw = value.toString().trim();
  if (raw.isEmpty || raw.toLowerCase() == 'null') {
    return '0';
  }
  return raw;
}
