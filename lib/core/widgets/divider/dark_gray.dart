import 'package:flutter/material.dart';
import 'package:swis_school/core/configs/app_style.dart';

class DarkGreyDivider extends StatelessWidget {
  const DarkGreyDivider({super.key, this.thickness, this.indent});

  final double? thickness;
  final double? indent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: indent,
      height: 0,
      color: AppColor.divider,
      thickness: thickness ?? 1,
    );
  }
}
