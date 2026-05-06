class ChildProfile {
  const ChildProfile({
    required this.id,
    required this.name,
    required this.avatar,
  });

  final String id;
  final String name;
  final String avatar;

  factory ChildProfile.fromDynamic(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final id =
          (raw['id'] ?? raw['student_id'] ?? raw['code'] ?? '')
              .toString()
              .trim();
      final name =
          (raw['name'] ??
                  raw['fullname_kh'] ??
                  raw['fullname_en'] ??
                  raw['full_name'] ??
                  raw['student_name'] ??
                  '')
              .toString()
              .trim();
      final avatar =
          (raw['profile_path'] ??
                  raw['profile'] ??
                  raw['avatar'] ??
                  raw['photo'] ??
                  raw['image'] ??
                  '')
              .toString()
              .trim();
      return ChildProfile(id: id, name: name, avatar: avatar);
    }
    if (raw is Map) {
      return ChildProfile.fromDynamic(Map<String, dynamic>.from(raw));
    }
    return const ChildProfile(id: '', name: '', avatar: '');
  }
}
