import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/flavor/app_config.dart';
import 'package:schoolapp/routes.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  static const String _childrenPath =
      '/api/v1/attendance-log/parent/children-log';

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

      final raw = res.data;
      final list = _extractChildren(raw);

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
      backgroundColor: const Color(0xFFF6F6F6),
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
              // child: Row(
              //   children: [
              //     IconButton(
              //       onPressed: () => Get.back(),
              //       icon: const Icon(Icons.close, color: Color(0xFF555555)),
              //     ),
              //     const Text(
              //       'Setting',
              //       style: TextStyle(fontSize: 30, color: Color(0xFF666666)),
              //     ),
              //     const Spacer(),
              //     //_profileCircle(size: 42),
              //   ],
              // ),
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
              profileName.isEmpty ? 'SC Smart School' : profileName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                      Image.asset('assets/images/logo.png', height: 26),
                      const SizedBox(width: 8),
                      const Text(
                        'SC International School',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0D4D45),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'App Version: V${AppConfig.shared.version}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2A2A2A),
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
      backgroundColor: const Color(0xFFF6F6F6),
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Color(0xFF555555)),
                  ),
                  const Text(
                    'Setting',
                    style: TextStyle(fontSize: 30, color: Color(0xFF666666)),
                  ),
                  const Spacer(),
                  _profileCircle(size: 42),
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
            const Text(
              'CIAC School',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                      Image.asset('assets/images/logo.png', height: 26),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'App Version: V${AppConfig.shared.version}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2A2A2A),
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
      leading: Icon(icon, color: const Color(0xFF0E5D56)),
      title: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF4A4A4A),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      // trailing:
      //     trailingText == null
      //         ? const Icon(Icons.chevron_right, color: Color(0xFF0E5D56))
      //         : Row(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Text(
      //               trailingText,
      //               style: const TextStyle(color: Color(0xFF777777)),
      //             ),
      //             const SizedBox(width: 6),
      //             const Icon(Icons.chevron_right, color: Color(0xFF0E5D56)),
      //           ],
      //         ),
    );
  }

  Widget _childCard({
    required _ChildProfile child,
    required bool active,
    required VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDADADA)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: _childAvatar(child.avatar),
        title: Text(
          child.name.isEmpty ? 'Student' : child.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
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
    final resolved = _resolveProfileUrl(avatar);
    if (resolved.isNotEmpty) {
      return CircleAvatar(
        radius: 18,
        backgroundImage:
            _isNetworkUrl(resolved)
                ? NetworkImage(resolved) as ImageProvider
                : AssetImage(resolved),
        backgroundColor: const Color(0xFFE8EEF2),
      );
    }
    return const CircleAvatar(
      radius: 18,
      backgroundColor: Color(0xFFE8EEF2),
      child: Icon(Icons.person, color: Color(0xFF6C7A86)),
    );
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
    final value = rawValue.trim();
    final lower = value.toLowerCase();
    if (value.isEmpty ||
        lower == 'n/a' ||
        lower == 'null' ||
        lower == 'undefined' ||
        lower == 'false') {
      return '';
    }
    if (_isNetworkUrl(value) || value.startsWith('assets/')) {
      return value;
    }
    final base = AppConfig.shared.baseUrl.trim();
    if (base.isEmpty) {
      return '';
    }
    final baseUri = Uri.parse(base.endsWith('/') ? base : '$base/');
    return baseUri
        .resolve(value.startsWith('/') ? value.substring(1) : value)
        .toString();
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
