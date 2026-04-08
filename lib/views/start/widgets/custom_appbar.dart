import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String imagePath;
  final double height;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.imagePath,
    this.height = 110,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),

            Container(color: Colors.black.withOpacity(0.3)),
          ],
        ),
        centerTitle: true,
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
