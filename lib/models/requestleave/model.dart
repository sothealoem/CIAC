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

  factory RequestLeaveModel.fromJson(Map<String, dynamic> json) {
    String read(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) {
          continue;
        }
        final text = value.toString().trim();
        if (text.isNotEmpty && text.toLowerCase() != 'null') {
          return text;
        }
      }
      return '';
    }

    final rawStatus = read(<String>[
      'status',
      'leave_status',
      'approval_status',
      'approve_status',
      'request_status',
      'state',
    ]);
    final normalizedStatus = _normalizeStatus(
      rawStatus: rawStatus,
      approvedFlag: read(<String>['approved', 'is_approved', 'isApproved']),
      rejectedFlag: read(<String>['rejected', 'is_rejected', 'isRejected']),
      approvedAt: read(<String>['approved_at', 'approvedAt']),
      rejectedAt: read(<String>['rejected_at', 'rejectedAt']),
    );

    return RequestLeaveModel(
      name: read(<String>['student_name', 'name', 'fullname', 'full_name']),
      grade: read(<String>['class', 'class_name', 'grade']),
      dateStart: read(<String>['date_start', 'start_date', 'from_date']),
      dateEnd: read(<String>['date_end', 'end_date', 'to_date']),
      leaveType: read(<String>['leave_type', 'type']),
      reason: read(<String>['reason', 'description', 'remark']),
      status: normalizedStatus,
    );
  }

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

String _normalizeStatus({
  required String rawStatus,
  required String approvedFlag,
  required String rejectedFlag,
  required String approvedAt,
  required String rejectedAt,
}) {
  final approved = approvedFlag.toLowerCase().trim();
  final rejected = rejectedFlag.toLowerCase().trim();
  if (rejected == '1' || rejected == 'true' || rejected == 'yes') {
    return 'rejected';
  }
  if (approved == '1' || approved == 'true' || approved == 'yes') {
    return 'approved';
  }

  final status = rawStatus.toLowerCase().trim();
  if (status.isNotEmpty) {
    if (status == '1' ||
        status.contains('approve') ||
        status.contains('accept') ||
        status == 'true') {
      return 'approved';
    }
    if (status == '2' ||
        status.contains('reject') ||
        status.contains('deny') ||
        status.contains('decline')) {
      return 'rejected';
    }
    if (status == '0' ||
        status.contains('pending') ||
        status.contains('wait') ||
        status.contains('review') ||
        status == 'false') {
      return 'pending';
    }
  }

  if (rejectedAt.trim().isNotEmpty) {
    return 'rejected';
  }
  if (approvedAt.trim().isNotEmpty) {
    return 'approved';
  }
  return 'pending';
}
