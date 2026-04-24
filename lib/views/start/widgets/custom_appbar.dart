import 'package:ciac_school/core/configs/app_style.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? subTitle;
  final String imagePath;
  final String? profileUrl;
  final String profileFallbackAsset;
  final double height;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    this.profileUrl,
    this.profileFallbackAsset = 'assets/images/teacher.jpg',
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
    final url = (profileUrl ?? '').trim();
    final hasNetwork =
        url.isNotEmpty &&
        url != 'N/A' &&
        (url.startsWith('http://') || url.startsWith('https://'));

    if (hasNetwork) {
      return ClipOval(
        child: Image.network(
          url,
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackImage(),
        ),
      );
    }
    return _fallbackImage();
  }

  Widget _fallbackImage() {
    return ClipOval(
      child: Image.asset(
        profileFallbackAsset,
        width: 36,
        height: 36,
        fit: BoxFit.cover,
      ),
    );
  }
}
