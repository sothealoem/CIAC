import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/views/views.dart';

class PaymentCollectionView extends GetView<PaymentCollectionController> {
  const PaymentCollectionView({super.key});

  void onSearch() async {
    if (!controller.formKey.currentState!.validate()) {
      return;
    }
    await controller.fetchTracking();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: SizedBox(
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
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back_ios),
                        ),
                        Text(
                          LocaleKeys.payment.tr,
                          style: AppTextStyle.mediumPrimaryBold,
                        ),
                      ],
                    ),
                    Text(
                      'លោកអ្នកអាចត្រួតពិនិត្យតាមខាងក្រោម',
                      style: AppTextStyle.smallPrimaryRegular,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage("assets/images/sc-background.jpg"),
              //     fit: BoxFit.fill,
              //   ),
              // ),
              child: PaymentCardWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
