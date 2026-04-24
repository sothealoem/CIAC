class RequestLeaveModel {
  final String? name;
  final String? grade;
  final String? dateStart;
  final String? dateEnd;
  final String? leaveType;
  final String? reason;
  final String? status;

  RequestLeaveModel({
    this.name,
    this.grade,
    this.dateStart,
    this.dateEnd,
    this.leaveType,
    this.reason,
    this.status,
  });

  // For API Submission
  Map<String, dynamic> toJson() {
    return {
      "date_start": dateStart,
      "date_end": dateEnd,
      "leave_type": leaveType,
      "reason": reason ?? "",
    };
  }
}
