import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/configs/app_style.dart';

class CustomizeAppBar extends StatelessWidget {
  const CustomizeAppBar({
    super.key,
    required this.title,
    this.subTitle,
    this.trailing, // Added optional
  });

  final String title;
  final String? subTitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                ),
                Text(title, style: AppTextStyle.mediumPrimaryGreenBold),
                if (trailing != null) const Spacer(),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
            if ((subTitle ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  subTitle!,
                  style: AppTextStyle.smallPrimaryGreenBold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
