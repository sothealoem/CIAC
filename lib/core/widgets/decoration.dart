import 'package:flutter/material.dart';
import 'package:swis_school/core/configs/app_style.dart';
import 'package:swis_school/core/constants/ui_constants.dart';
import 'package:swis_school/core/extensions/int.dart';

Decoration customDecoration({Color color = AppColor.white}) {
  return BoxDecoration(
    borderRadius: UIConstants.radius.radiusAll,
    color: color,
    boxShadow: [
      BoxShadow(
        color: AppColor.grey.withOpacity(0.5),
        spreadRadius: 0,
        blurRadius: 1,
        offset: const Offset(0, 0),
      ),
    ],
  );
}
