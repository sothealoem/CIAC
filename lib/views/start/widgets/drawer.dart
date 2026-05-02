import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/flavor/app_config.dart';
import 'package:schoolapp/models/parent/parent.dart';
import 'package:schoolapp/routes.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  static const String _childrenPath = '/api/v1/parent/student-info';

  bool _isLoadingChildren = false;
  List<_ChildProfile> _children = const <_ChildProfile>[];
  String _selectedChildId = '';

  bool get _isParentRole => UserRepository.shared.isDriver;

  @override
  void initState() {
    super.initState();
    _loadSelectedChild();
    if (_isParentRole) {
      _fetchParentChildren();
    }
  }

  Future<void> _loadSelectedChild() async {
    final value =
        (await SharedPreferencesManager.get('selected_child_id') ?? '')
            .toString()
            .trim();
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedChildId = value;
    });
  }

  Future<void> _fetchParentChildren() async {
    setState(() {
      _isLoadingChildren = true;
    });

    try {
      final res = await Get.find<ApiService>().get(
        _childrenPath,
        isShowLoading: false,
      );

      final list = _extractChildren(res.data);

      if (!mounted) {
        return;
      }

      var selected = _selectedChildId;
      if (selected.isEmpty && list.isNotEmpty) {
        selected = list.first.id;
      }

      setState(() {
        _children = list;
        _selectedChildId = selected;
      });

      if (selected.isNotEmpty) {
        await SharedPreferencesManager.setValue('selected_child_id', selected);
        _ChildProfile? current;
        for (final child in list) {
          if (child.id == selected) {
            current = child;
            break;
          }
        }
        if (current != null) {
          await SharedPreferencesManager.setValue(
            'selected_child_name',
            current.name,
          );
          await SharedPreferencesManager.setValue(
            'selected_child_avatar',
            current.avatar,
          );
        }
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _children = const <_ChildProfile>[];
      });
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoadingChildren = false;
      });
    }
  }

  List<_ChildProfile> _extractChildren(dynamic raw) {
    if (raw is Map) {
      final model = ParentWithChild.fromJson(Map<String, dynamic>.from(raw));
      final students = model.data?.student ?? const <Student>[];
      if (students.isNotEmpty) {
        return students
            .map(
              (student) => _ChildProfile(
                id:
                    (student.id?.toString() ?? student.admissionNo ?? '')
                        .trim(),
                name:
                    (student.nameKh ??
                            student.name ??
                            student.admissionNo ??
                            '')
                        .trim(),
                avatar: (student.profile ?? '').trim(),
              ),
            )
            .where((child) => child.id.isNotEmpty || child.name.isNotEmpty)
            .toList();
      }
    }

    if (raw is! Map) {
      return const <_ChildProfile>[];
    }

    final candidates = <dynamic>[
      raw['data'],
      raw['children'],
      raw['data'] is Map ? raw['data']['children'] : null,
      raw['data'] is Map ? raw['data']['data'] : null,
    ];

    for (final candidate in candidates) {
      if (candidate is List) {
        return candidate
            .whereType<dynamic>()
            .map(_ChildProfile.fromDynamic)
            .where((child) => child.id.isNotEmpty || child.name.isNotEmpty)
            .toList();
      }
    }

    return const <_ChildProfile>[];
  }

  void _selectChild(_ChildProfile child) async {
    setState(() {
      _selectedChildId = child.id;
    });
    await SharedPreferencesManager.setValue('selected_child_id', child.id);
    await SharedPreferencesManager.setValue('selected_child_name', child.name);
    await SharedPreferencesManager.setValue(
      'selected_child_avatar',
      child.avatar,
    );
    Get.back();
    Get.snackbar(
      'Student',
      '${child.name.isEmpty ? 'Student' : child.name} selected',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(milliseconds: 1300),
    );
  }

  void languageHandleTap() {
    Get.back();
    Get.toNamed(Routes.language);
  }

  void termConditionHandleTap() {
    Get.back();
    Get.toNamed(Routes.termCondition);
  }

  void contactUsHandleTap() {
    Get.back();
    Get.toNamed(Routes.contactUs);
  }

  void logOutHandleTap() {
    Get.back();
    DialogManager.showCustom(
      PrimaryDialog(
        title: LocaleKeys.logout.tr,
        subTitle: LocaleKeys.areYouSureYourWantToLogout.tr,
        btnText: LocaleKeys.yes.tr.toUpperCase(),
        onPressed: () async {
          Get.back();
          await UserRepository.shared.logout();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isParentRole) {
      return _buildParentDrawer(context);
    }
    return _buildTeacherDrawer();
  }

  Widget _buildTeacherDrawer() {
    String profileName = '';
    try {
      profileName = UserRepository.shared.profile.name.trim();
    } catch (_) {
      profileName = '';
    }

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          children: [
            ClipOval(
              child: Image.asset(
                AssetPath.appIcon.path,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              profileName.isEmpty ? 'CIAC School' : profileName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            _parentMenuItem(
              icon: Icons.settings,
              label: LocaleKeys.termAndCondition.tr,
              onTap: termConditionHandleTap,
            ),
            _divider(),
            _parentMenuItem(
              icon: Icons.language,
              label: LocaleKeys.language.tr,
              trailingText: AppConfig.shared.language,
              onTap: languageHandleTap,
            ),
            _divider(),
            _parentMenuItem(
              icon: Icons.contact_support,
              label: LocaleKeys.contactUs.tr,
              onTap: contactUsHandleTap,
            ),
            _divider(),
            _parentMenuItem(
              icon: Icons.logout,
              label: LocaleKeys.logout.tr,
              onTap: logOutHandleTap,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo.png', height: 35),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'App Version: V${AppConfig.shared.version}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParentDrawer(BuildContext context) {
    String profileName = '';
    try {
      profileName = UserRepository.shared.profile.name.trim();
    } catch (_) {
      profileName = '';
    }

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(14, 8, 14, 6),
              child: Row(
                children: [
                  // IconButton(
                  //   onPressed: () => Get.back(),
                  //   icon: const Icon(Icons.close, color: Color(0xFF555555)),
                  // ),
                  // const Text(
                  //   'Setting',
                  //   style: TextStyle(fontSize: 30, color: Color(0xFF666666)),
                  // ),
                  // const Spacer(),
                  // _profileCircle(size: 42),
                ],
              ),
            ),
            ClipOval(
              child: Image.asset(
                AssetPath.appIcon.path,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'CIAC School',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 12),
            if (_isLoadingChildren)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            if (!_isLoadingChildren && _children.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children:
                      _children.map((child) {
                        final active = child.id == _selectedChildId;
                        return _childCard(
                          child: child,
                          active: active,
                          onTap: () => _selectChild(child),
                        );
                      }).toList(),
                ),
              ),
            if (!_isLoadingChildren &&
                _children.isEmpty &&
                profileName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _childCard(
                  child: _ChildProfile(
                    id: 'self',
                    name: profileName,
                    avatar: '',
                  ),
                  active: true,
                  onTap: null,
                ),
              ),
            const SizedBox(height: 8),
            _parentMenuItem(
              icon: Icons.settings,
              label: LocaleKeys.termAndCondition.tr,
              onTap: termConditionHandleTap,
            ),
            _divider(),
            _parentMenuItem(
              icon: Icons.language,
              label: LocaleKeys.language.tr,
              trailingText: AppConfig.shared.language,
              onTap: languageHandleTap,
            ),
            _divider(),
            _parentMenuItem(
              icon: Icons.logout,
              label: LocaleKeys.logout.tr,
              onTap: logOutHandleTap,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo.png', height: 36),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'App Version: V${AppConfig.shared.version}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Divider(height: 1),
    );
  }

  Widget _parentMenuItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    String? trailingText,
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      onTap: onTap,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _childCard({
    required _ChildProfile child,
    required bool active,
    required VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF223039) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF3A4957) : const Color(0xFFDADADA),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: _childAvatar(child.avatar),
        title: Text(
          child.name.isEmpty ? 'Student' : child.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing:
            active
                ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF3DF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                : null,
      ),
    );
  }

  Widget _childAvatar(String avatar) {
    final candidates = _resolveProfileUrlCandidates(avatar);
    if (candidates.isNotEmpty) {
      final first = candidates.first;
      if (_isNetworkUrl(first)) {
        return _networkAvatar(candidates, 0);
      }
      return CircleAvatar(
        radius: 18,
        backgroundImage: AssetImage(first),
        backgroundColor: const Color(0xFFE8EEF2),
      );
    }
    return const CircleAvatar(
      radius: 18,
      backgroundColor: Color(0xFFE8EEF2),
      child: Icon(Icons.person, color: Color(0xFF6C7A86)),
    );
  }

  Widget _networkAvatar(List<String> urls, int index) {
    if (index >= urls.length) {
      return const CircleAvatar(
        radius: 18,
        backgroundColor: Color(0xFFE8EEF2),
        child: Icon(Icons.person, color: Color(0xFF6C7A86)),
      );
    }

    return CircleAvatar(
      radius: 18,
      backgroundColor: const Color(0xFFE8EEF2),
      child: ClipOval(child: _networkAvatarImage(urls, index)),
    );
  }

  Widget _networkAvatarImage(List<String> urls, int index) {
    if (index >= urls.length) {
      return const Icon(Icons.person, color: Color(0xFF6C7A86));
    }
    return CachedNetworkImage(
      imageUrl: urls[index],
      fit: BoxFit.cover,
      width: 36,
      height: 36,
      memCacheWidth: 72,
      memCacheHeight: 72,
      maxWidthDiskCache: 72,
      maxHeightDiskCache: 72,
      httpHeaders: _imageHeaders() ?? const <String, String>{},
      useOldImageOnUrlChange: true,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      placeholder:
          (_, __) => Container(
            width: 36,
            height: 36,
            color: const Color(0xFFE8EEF2),
            alignment: Alignment.center,
            child: const Icon(Icons.person, color: Color(0xFF6C7A86)),
          ),
      errorWidget: (_, __, ___) => _networkAvatarImage(urls, index + 1),
    );
  }

  Map<String, String>? _imageHeaders() {
    final token = AppConfig.shared.authorizationToken.trim();
    if (token.isEmpty) {
      return null;
    }
    return <String, String>{'Authorization': token, 'Accept': 'image/*'};
  }

  Widget _profileCircle({double size = 40}) {
    String rawProfile = '';
    try {
      rawProfile = UserRepository.shared.profile.profile;
    } catch (_) {
      rawProfile = '';
    }
    final profile = _resolveProfileUrl(rawProfile);
    final border = Border.all(color: AppColor.primaryColor, width: 2);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, border: border),
      child: ClipOval(
        child:
            profile.isNotEmpty
                ? Image(
                  image:
                      _isNetworkUrl(profile)
                          ? NetworkImage(profile) as ImageProvider
                          : AssetImage(profile),
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) =>
                          const Icon(Icons.person, color: Colors.grey),
                )
                : const Icon(Icons.person, color: Colors.grey),
      ),
    );
  }

  String _resolveProfileUrl(String rawValue) {
    final value = rawValue.trim().replaceAll('\\', '/');
    final lower = value.toLowerCase();
    if (value.isEmpty ||
        lower == 'n/a' ||
        lower == 'null' ||
        lower == 'undefined' ||
        lower == 'false' ||
        value == '{}') {
      return '';
    }
    final unquoted = value.replaceAll('"', '').replaceAll("'", '');
    if (_isNetworkUrl(unquoted) || unquoted.startsWith('assets/')) {
      return unquoted;
    }
    if (unquoted.startsWith('//')) {
      return 'https:$unquoted';
    }
    if (unquoted.startsWith('/')) {
      final base = AppConfig.shared.baseUrl.trim();
      if (base.isEmpty) {
        return '';
      }
      final baseUri = Uri.parse(base.endsWith('/') ? base : '$base/');
      return baseUri.resolve(unquoted.substring(1)).toString();
    }
    if (unquoted.startsWith('storage/') ||
        unquoted.startsWith('uploads/') ||
        unquoted.startsWith('images/')) {
      final base = AppConfig.shared.baseUrl.trim();
      if (base.isEmpty) {
        return '';
      }
      final baseUri = Uri.parse(base.endsWith('/') ? base : '$base/');
      return baseUri.resolve(unquoted).toString();
    }
    if (RegExp(
      r'^[A-Za-z0-9_.-]+\.(png|jpg|jpeg|webp|gif)$',
    ).hasMatch(unquoted)) {
      final base = AppConfig.shared.baseUrl.trim();
      if (base.isEmpty) {
        return '';
      }
      final baseUri = Uri.parse(base.endsWith('/') ? base : '$base/');
      return baseUri.resolve('uploads/$unquoted').toString();
    }
    if (unquoted.startsWith('data:image/')) {
      return value;
    }
    final base = AppConfig.shared.baseUrl.trim();
    if (base.isEmpty) {
      return '';
    }
    final baseUri = Uri.parse(base.endsWith('/') ? base : '$base/');
    return baseUri.resolve(unquoted).toString();
  }

  List<String> _resolveProfileUrlCandidates(String rawValue) {
    final value = rawValue.trim().replaceAll('\\', '/');
    final lower = value.toLowerCase();
    if (value.isEmpty ||
        lower == 'n/a' ||
        lower == 'null' ||
        lower == 'undefined' ||
        lower == 'false' ||
        value == '{}') {
      return const <String>[];
    }

    final unquoted = value.replaceAll('"', '').replaceAll("'", '');
    if (unquoted.startsWith('assets/')) {
      return <String>[unquoted];
    }
    if (_isNetworkUrl(unquoted)) {
      return _networkUrlVariants(unquoted);
    }
    if (unquoted.startsWith('//')) {
      return <String>['https:$unquoted'];
    }

    final base = AppConfig.shared.baseUrl.trim();
    if (base.isEmpty) {
      return const <String>[];
    }
    final baseUri = Uri.parse(base.endsWith('/') ? base : '$base/');
    final path = unquoted.startsWith('/') ? unquoted.substring(1) : unquoted;

    final rawCandidates = <String>[
      path,
      if (path.startsWith('storage/')) 'public/$path',
      if (path.startsWith('uploads/')) 'public/$path',
      if (path.startsWith('images/')) 'public/$path',
      if (!path.startsWith('storage/')) 'storage/$path',
      if (!path.startsWith('uploads/')) 'uploads/$path',
      if (!path.startsWith('public/')) 'public/$path',
    ];

    final seen = <String>{};
    final resolved = <String>[];
    for (final candidate in rawCandidates) {
      final normalized = candidate.replaceAll('//', '/');
      final url = baseUri.resolve(normalized).toString();
      if (seen.add(url)) {
        resolved.add(url);
      }
    }
    return resolved;
  }

  List<String> _networkUrlVariants(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return <String>[url];
    }

    final normalizedPath = uri.path.replaceAll('\\', '/');
    final fixedUploads = _dedupeAdjacentPath(
      normalizedPath.replaceFirst('/uploads/uploads/', '/uploads/'),
    );
    final fixedPublic = _dedupeAdjacentPath(
      normalizedPath.replaceFirst('/public/public/', '/public/'),
    );
    final fixedStorage = _dedupeAdjacentPath(
      normalizedPath.replaceFirst('/storage/storage/', '/storage/'),
    );
    final deduped = _dedupeAdjacentPath(normalizedPath);
    final variants = <String>[
      uri.replace(path: fixedUploads).toString(),
      uri.replace(path: fixedPublic).toString(),
      uri.replace(path: fixedStorage).toString(),
      uri.replace(path: deduped).toString(),
      url,
    ];

    final seen = <String>{};
    return variants.where((v) => seen.add(v)).toList();
  }

  String _dedupeAdjacentPath(String path) {
    final parts = path.split('/').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) {
      return path;
    }
    final compact = <String>[];
    for (final part in parts) {
      if (compact.isEmpty || compact.last.toLowerCase() != part.toLowerCase()) {
        compact.add(part);
      }
    }
    return '/${compact.join('/')}';
  }

  bool _isNetworkUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }
}

class _ChildProfile {
  const _ChildProfile({
    required this.id,
    required this.name,
    required this.avatar,
  });

  final String id;
  final String name;
  final String avatar;

  factory _ChildProfile.fromDynamic(dynamic raw) {
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
      return _ChildProfile(id: id, name: name, avatar: avatar);
    }
    if (raw is Map) {
      return _ChildProfile.fromDynamic(Map<String, dynamic>.from(raw));
    }
    return const _ChildProfile(id: '', name: '', avatar: '');
  }
}
