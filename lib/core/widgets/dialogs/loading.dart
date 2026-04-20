import 'package:flutter/material.dart';
import 'package:swis_school/core/configs/app_style.dart';
import 'package:swis_school/core/constants/ui_constants.dart';
import 'package:swis_school/core/extensions/int.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: 32.padAll,
      elevation: 1,
      child: Container(
        padding: 16.padVertical,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: UIConstants.radius.radiusAll,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColor.primary),
            16.height,
            Text(
              'Loading ...',
              style: AppTextStyle.midPrimaryBold.copyWith(height: 0),
            ),
          ],
        ),
      ),
    );
  }
}
