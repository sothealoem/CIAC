class ProfileModel {
  final num id;
  final String name;
  final String email;
  final String profile;
  final String company;
  final String phone;
  final String type;
  final dynamic gender;
  final String emailVerifiedAt;
  final num? status;
  final num? entryBy;
  final dynamic updateBy;
  final dynamic customerId;
  final num? driverId;
  final num? branchId;
  final String createdAt;
  final String updatedAt;
  final String profilePath;
  final String policy;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profile,
    required this.company,
    required this.phone,
    required this.type,
    required this.gender,
    required this.emailVerifiedAt,
    this.status,
    this.entryBy,
    required this.updateBy,
    required this.customerId,
    this.driverId,
    this.branchId,
    required this.createdAt,
    required this.updatedAt,
    required this.profilePath,
    required this.policy,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      profile: json['profile_path'] ?? 'N/A',
      company: json['company'] ?? 'N/A',
      phone: json['phone'] ?? 'N/A',
      type: json['type'] ?? 'N/A',
      gender: json['gender'] ?? 'N/A',
      emailVerifiedAt: json['email_verified_at'] ?? 'N/A',
      status: json['status'],
      entryBy: json['entry_by'],
      updateBy: json['update_by'] ?? 'N/A',
      customerId: json['customer_id'] ?? 'N/A',
      driverId: json['driver_id'],
      branchId: json['branch_id'],
      createdAt: json['created_at'] ?? 'N/A',
      updatedAt: json['updated_at'] ?? 'N/A',
      profilePath: json['profile_path'] ?? 'N/A',
      policy: json['policy'] ?? 'N/A',
    );
  }
}
