import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/configs/app_style.dart';
import 'package:swis_school/core/constants/ui_constants.dart';
import 'package:swis_school/core/extensions/int.dart';
import 'package:swis_school/core/resources/locales.g.dart';
import 'package:swis_school/core/utils/form_validator.dart';
import 'package:swis_school/core/widgets/buttons/primary.dart';
import 'package:swis_school/core/widgets/text_field/custom.dart';
import 'package:swis_school/views/scan/controller.dart';

class EnterProductCodeDialog extends StatelessWidget {
  EnterProductCodeDialog({super.key});

  final ScanController scanCtl = Get.find<ScanController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.white,
      elevation: 0,
      insetPadding: UIConstants.spacing.padHorizontal,
      shape: RoundedRectangleBorder(borderRadius: UIConstants.radius.radiusAll),
      child: Padding(
        padding: UIConstants.spacing.padAll,
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: scanCtl.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Get product
                    Text(
                      LocaleKeys.getProduct.tr,
                      style: AppTextStyle.midPrimarySemiBold,
                    ),
                    6.height,

                    CustomTextField(
                      controller: scanCtl.getProdCtl,
                      hintText: LocaleKeys.enterProductCode.tr,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (text) => FormValidator.empty(text),
                      textInputAction: TextInputAction.next,
                    ),
                    15.height,

                    // Finish delivery
                    Text(
                      LocaleKeys.finishDelivery.tr,
                      style: AppTextStyle.midPrimarySemiBold,
                    ),
                    6.height,

                    CustomTextField(
                      controller: scanCtl.finishDeliveryCtl,
                      hintText: LocaleKeys.enterProductCode.tr,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (text) => FormValidator.empty(text),
                      textInputAction: TextInputAction.done,
                    ),
                    30.height,

                    // Apply
                    PrimaryButton(
                      text: 'APPLY',
                      onPressed: () async {
                        final String getProduct = scanCtl.getProdCtl.text;
                        final String finishDelivery =
                            scanCtl.finishDeliveryCtl.text;
                        if (getProduct.isEmpty && finishDelivery.isEmpty) {
                          return;
                        }
                        Get.back();
                        if (getProduct.isNotEmpty) {
                          await scanCtl.scanGetProduct(id: getProduct);
                          scanCtl.getProdCtl.text = '';
                          return;
                        }

                        if (finishDelivery.isNotEmpty) {
                          await scanCtl.scanComplete(id: finishDelivery);
                          scanCtl.finishDeliveryCtl.text = '';
                          return;
                        }
                      },
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
}
