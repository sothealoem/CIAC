import 'package:flutter/material.dart';
import 'package:swis_school/core/configs/app_style.dart';
import 'package:swis_school/core/constants/ui_constants.dart';
import 'package:swis_school/core/extensions/int.dart';
import 'package:swis_school/core/widgets/buttons/close_icon.dart';
import 'package:swis_school/core/widgets/buttons/primary.dart';

class PrimaryDialog extends StatelessWidget {
  const PrimaryDialog({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onPressed,
    this.btnText = 'CLOSE',
  });

  final String title;
  final String subTitle;
  final String btnText;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: AppColor.white,
      insetPadding: UIConstants.spacing.padHorizontal,
      shape: RoundedRectangleBorder(borderRadius: UIConstants.radius.radiusAll),
      child: Padding(
        padding: 20.padAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _closeIconWidget(),
            Text(title, style: AppTextStyle.mediumPrimarySemiBold),
            15.height,
            Text(subTitle, style: AppTextStyle.normalSecondaryRegular),
            30.height,
            PrimaryButton(text: btnText, onPressed: onPressed),
          ],
        ),
      ),
    );
  }

  Widget _closeIconWidget() {
    return const Row(children: [Spacer(), CloseIcon()]);
  }
}
