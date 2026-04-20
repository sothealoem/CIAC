import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/configs/app_style.dart';
import 'package:swis_school/core/constants/asset_path.dart';
import 'package:swis_school/core/extensions/int.dart';
import 'package:swis_school/core/resources/locales.g.dart';
import 'package:swis_school/core/widgets/buttons/primary.dart';
import 'package:swis_school/core/widgets/divider/dark_gray.dart';
import 'package:swis_school/models/payment/model.dart';
import 'package:swis_school/routes.dart';

class PaymentSheet extends StatelessWidget {
  const PaymentSheet({super.key, required this.payment});

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(AssetPath.placeholder.path),
              ),
              14.width,
              Text(
                payment.deliveryName,
                style: AppTextStyle.normalPrimarySemiBold,
              ),
            ],
          ),
          15.height,
          const DarkGreyDivider(),
          15.height,
          _item(
            title: '${LocaleKeys.amount.tr} (\$)',
            value: '\$${payment.amountUs}',
          ),
          10.height,
          _item(
            title: '${LocaleKeys.amount.tr} (៛)',
            value: '${payment.amountKh}',
          ),
          10.height,
          _item(title: LocaleKeys.checkedBy.tr, value: payment.verifyBy),
          10.height,
          _item(title: LocaleKeys.date.tr, value: payment.codDate),
          10.height,
          _item(
            title: LocaleKeys.totalAmount.tr,
            value: '\$${payment.total}',
            isTotal: true,
          ),
          18.height,
          PrimaryButton(
            text: LocaleKeys.viewDetails.tr,
            onPressed: () {
              Get.back();
              final Map<String, dynamic> arguments = {
                'paymentId': payment.tranId,
              };
              Get.toNamed(Routes.paymentDetail, arguments: arguments);
            },
          ),
        ],
      ),
    );
  }

  Widget _item({
    required String title,
    required String value,
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Text(
          title,
          style:
              isTotal
                  ? AppTextStyle.normalPrimarySemiBold
                  : AppTextStyle.normalPrimaryRegular,
        ),
        const Spacer(),
        Text(
          value,
          style:
              isTotal
                  ? AppTextStyle.normalRedBold
                  : AppTextStyle.normalPrimaryRegular,
        ),
      ],
    );
  }
}
