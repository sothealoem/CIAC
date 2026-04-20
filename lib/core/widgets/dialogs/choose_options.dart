import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/configs/app_style.dart';
import 'package:swis_school/core/constants/ui_constants.dart';
import 'package:swis_school/core/extensions/int.dart';
import 'package:swis_school/core/repositories/user.dart';
import 'package:swis_school/core/resources/locales.g.dart';
import 'package:swis_school/core/widgets/buttons/primary.dart';
import 'package:swis_school/views/start/controller.dart';

class ChooseOptionsDialog extends StatelessWidget {
  ChooseOptionsDialog({
    super.key,
    this.isScanner = true,
    required this.firstBtnOnPressed,
    required this.secondBtnOnPressed,
  });

  final bool isScanner;
  final Function() firstBtnOnPressed;
  final Function() secondBtnOnPressed;
  final StartController controller = Get.find<StartController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.white,
      elevation: 0,
      insetPadding: UIConstants.spacing.padHorizontal,
      shape: RoundedRectangleBorder(borderRadius: UIConstants.radius.radiusAll),
      child: Padding(
        padding: 20.padAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (UserRepository.shared.isDriver &&
                controller.selectedIndex.value == 2)
              const SizedBox()
            else
              Padding(
                padding: UIConstants.spacing.padBottom,
                child: PrimaryButton(
                  text:
                      isScanner
                          ? LocaleKeys.qrCode.tr
                          : LocaleKeys.sampleBooking.tr,
                  onPressed: () {
                    Get.back();
                    firstBtnOnPressed();
                  },
                ),
              ),
            PrimaryButton(
              text:
                  isScanner
                      ? LocaleKeys.enterProductCode.tr
                      : LocaleKeys.packagesBooking.tr,
              onPressed: () {
                Get.back();
                secondBtnOnPressed();
              },
            ),
          ],
        ),
      ),
    );
  }
}
