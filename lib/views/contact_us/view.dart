import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ciac_school/core/core.dart';
import 'package:ciac_school/views/views.dart';

class ContactUsView extends GetView<ContactUsController> {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ContactUsController());
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.contactUs.tr)),
      body: Obx(() {
        // if (controller.isLoading.value) {
        //   return const Center(
        //     child: CircularProgressIndicator(color: AppColor.red),
        //   );
        // }
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (UIConstants.spacing + 8).height,

              // English name
              Text(
                controller.contactUs.value?.englishName ?? 'N/A',
                style: AppTextStyle.extraHugeBlackSemiBold,
              ),
              (UIConstants.spacing).height,

              // Khmer name
              Text(
                controller.contactUs.value?.khmerName ?? 'N/A',
                style: AppTextStyle.largePrimaryBold,
              ),
              (UIConstants.spacing + 8).height,

              Padding(
                padding: UIConstants.spacing.padAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address
                    ContactItemWidget(
                      icons: Icons.location_off_rounded,
                      label: controller.contactUs.value?.address ?? 'N/A',
                    ),
                    (UIConstants.spacing + 8).height,

                    // Phone number
                    ContactItemWidget(
                      icons: Icons.phone,
                      label: controller.contactUs.value?.phone ?? 'N/A',
                    ),
                    (UIConstants.spacing + 8).height,

                    // Phone number
                    ContactItemWidget(
                      icons: Icons.email,
                      label: controller.contactUs.value?.email ?? 'N/A',
                    ),
                    (UIConstants.spacing + 8).height,
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
