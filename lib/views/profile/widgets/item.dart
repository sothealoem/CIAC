import 'package:flutter/material.dart';
import 'package:swis_school/core/core.dart';

class ProfileItemWidget extends StatelessWidget {
  const ProfileItemWidget({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor = AppColor.black,
    this.style = AppTextStyle.normalPrimaryRegular,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final Color iconColor;
  final TextStyle style;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColor.lightGrey,
                child: Icon(icon, color: iconColor),
              ),
              16.width,
              Text(text, style: style),
            ],
          ),
        ],
      ),
    );
  }
}
