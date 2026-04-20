class RequestLeave {
  final String? dateStart;
  final String? dateEnd;
  final String? leaveType;
  final String? reason;

  RequestLeave({this.dateStart, this.dateEnd, this.leaveType, this.reason});

  factory RequestLeave.fromJson(Map<String, dynamic> json) {
    return RequestLeave(
      dateStart: json['date_start'],
      dateEnd: json['date_end'],
      leaveType: json['leave_type'],
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date_start': dateStart,
      'date_end': dateEnd,
      'leave_type': leaveType,
      'reason': reason,
    };
  }
}
