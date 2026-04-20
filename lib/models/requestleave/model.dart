class RequestLeaveModel {
  String? name;
  String? grade;
  String? dateStart;
  String? dateEnd;
  String? reason;
  String? status;

  RequestLeaveModel({
    this.name,
    this.grade,
    this.dateStart,
    this.dateEnd,
    this.reason,
    this.status,
  });

  factory RequestLeaveModel.fromJson(Map<String, dynamic> json) {
    return RequestLeaveModel(
      name: json['name'],
      grade: json['grade'],
      dateStart: json['date_start'],
      dateEnd: json['date_end'],
      reason: json['reason'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'grade': grade,
      'date_start': dateStart,
      'date_end': dateEnd,
      'reason': reason,
      'status': status,
    };
  }
}
