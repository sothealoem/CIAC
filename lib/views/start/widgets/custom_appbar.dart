import 'package:schoolapp/core/configs/app_style.dart';
import 'package:schoolapp/flavor/flavor.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double _avatarSize = 36;
  final Widget? title;
  final String? subTitle;
  final String imagePath;
  final String? profileUrl;
  final double height;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    this.profileUrl,
    this.height = 130,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        child: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset('assets/images/logo.png', height: 40)],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.primaryColor, width: 2),
                ),
                child: CircleAvatar(radius: 18, child: _buildProfileImage()),
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              Container(color: Colors.black.withOpacity(0.3)),
              Positioned(
                left: 16,
                bottom: 8,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title ?? const SizedBox(),

                    Text(
                      subTitle ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);

  Widget _buildProfileImage() {
    final resolvedUrl = _resolveProfileUrl((profileUrl ?? '').trim());
    if (resolvedUrl.isNotEmpty) {
      return _buildImageFromPath(
        resolvedUrl,
        onError: () => _avatarPlaceholder(),
      );
    }
    return _avatarPlaceholder();
  }

  Widget _buildImageFromPath(
    String path, {
    required Widget Function() onError,
  }) {
    final source = path.trim();
    final errorWidgetBuilder = (_, __, ___) => onError();

    if (_isNetworkUrl(source)) {
      return ClipOval(
        child: Image.network(
          source,
          width: _avatarSize,
          height: _avatarSize,
          fit: BoxFit.cover,
          headers: _networkHeaders(),
          errorBuilder: errorWidgetBuilder,
        ),
      );
    }

    return ClipOval(
      child: Image.asset(
        source,
        width: _avatarSize,
        height: _avatarSize,
        fit: BoxFit.cover,
        errorBuilder: errorWidgetBuilder,
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return CircleAvatar(
      radius: _avatarSize / 2,
      backgroundColor: Colors.grey.shade200,
      child: Icon(
        Icons.person,
        size: _avatarSize * 0.55,
        color: Colors.grey.shade600,
      ),
    );
  }

  String _resolveProfileUrl(String rawValue) {
    if (!_isValidValue(rawValue)) {
      return '';
    }
    if (_isNetworkUrl(rawValue) || rawValue.startsWith('assets/')) {
      return rawValue;
    }

    final base = AppConfig.shared.baseUrl.trim();
    if (base.isEmpty) {
      return '';
    }

    final baseUri = Uri.parse(base.endsWith('/') ? base : '$base/');
    return baseUri
        .resolve(rawValue.startsWith('/') ? rawValue.substring(1) : rawValue)
        .toString();
  }

  bool _isValidValue(String value) {
    if (value.isEmpty) {
      return false;
    }
    final lower = value.toLowerCase();
    return lower != 'n/a' &&
        lower != 'null' &&
        lower != 'undefined' &&
        lower != 'false';
  }

  bool _isNetworkUrl(String value) {
    if (!_isValidValue(value)) {
      return false;
    }
    final uri = Uri.tryParse(value);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Map<String, String>? _networkHeaders() {
    final token = AppConfig.shared.authorizationToken.trim();
    if (token.isEmpty) {
      return null;
    }
    return <String, String>{'Authorization': token};
  }
}
