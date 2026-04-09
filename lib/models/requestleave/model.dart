import 'package:flutter/foundation.dart';

class RequestLeaveModel {
  String? dateStart;
  String? dateEnd;
  String? leaveType;
  String? reason;

  RequestLeaveModel({
    this.dateStart,
    this.dateEnd,
    this.leaveType,
    this.reason,
  });

  factory RequestLeaveModel.fromJson(Map<String, dynamic> json) {
    return RequestLeaveModel(
      dateStart: json['date_start'],
      dateEnd: json['date_end'],
      leaveType: json['leave_type'],
      reason: json['reason'],
    );
  }

  // RequestLeave.fromJson(Map<String, dynamic> json) {
  //   dateStart = json['date_start'];
  //   dateEnd = json['date_end'];
  //   leaveType = json['leave_type'];
  //   reason = json['reason'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['date_start'] = this.dateStart;
  //   data['date_end'] = this.dateEnd;
  //   data['leave_type'] = this.leaveType;
  //   data['reason'] = this.reason;
  //   return data;
  // }
}
