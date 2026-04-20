import 'package:flutter/material.dart';
import 'package:swis_school/core/configs/app_style.dart';
import 'package:swis_school/core/constants/ui_constants.dart';
import 'package:swis_school/core/extensions/int.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.bgColor = AppColor.primary,
    this.borderRadius = UIConstants.radius,
    this.elevation = 0,
    this.width = double.infinity,
  });

  final String text;
  final VoidCallback? onPressed;
  final int borderRadius;
  final double elevation;
  final Color bgColor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width,
      height: UIConstants.btnHeight,
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: borderRadius.radiusAll),
      disabledColor: Colors.blue[200],
      onPressed: onPressed,
      elevation: elevation,
      child: Text(text, style: AppTextStyle.normalWhiteBold),
    );
  }
}
