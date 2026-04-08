import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/views/start/widgets/custom_appbar.dart';
import 'package:swis_school/views/start/widgets/custom_indicator.dart';
import 'package:swis_school/views/start/widgets/customize_app_bar.dart';
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
                    CustomizeAppBar(
                      title: 'ការបង់ថ្លៃសិក្សា',
                      subTitle:
                          'សូមត្រួតពិនិត្យការបង់ថ្លៃសិក្សាកូនៗ​ របស់លោកអ្នកតាមខាងក្រោមនេះ',
                    ),
                  ],
                ),
              ),
            ),
          ),
          UIConstants.spacing.height,
          CustomIndicator(progress: 10),
          Expanded(child: Container(child: PaymentCardWidget())),
        ],
      ),
    );
  }
}
