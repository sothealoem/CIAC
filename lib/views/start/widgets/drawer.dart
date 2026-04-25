import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/flavor/app_config.dart';
import 'package:schoolapp/routes.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  void languageHandleTap() {
    Get.back();
    Get.toNamed(Routes.language);
  }

  void termConditionHandleTap() {
    Get.back();
    Get.toNamed(Routes.termCondition);
  }

  void contactUsHandleTap() {
    Get.back();
    Get.toNamed(Routes.contactUs);
  }

  void logOutHandleTap() {
    Get.back();
    DialogManager.showCustom(
      PrimaryDialog(
        title: LocaleKeys.logout.tr,
        subTitle: LocaleKeys.areYouSureYourWantToLogout.tr,
        btnText: LocaleKeys.yes.tr.toUpperCase(),
        onPressed: () async {
          Get.back();
          await UserRepository.shared.logout();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.primaryColor,
      shape: const RoundedRectangleBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                // Header
                DrawerHeader(
                  padding: 12.padRight,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Image.asset(
                    AssetPath.appLogo.path,
                    fit: BoxFit.contain,
                  ),
                ),

                // Language
                CustomListTile(
                  text: LocaleKeys.language.tr,
                  leadingIconData: Icons.language,
                  trillingIconData: Icons.arrow_forward_ios_rounded,
                  onTap: languageHandleTap,
                ),
                16.height,

                // Term and condition
                CustomListTile(
                  text: LocaleKeys.termAndCondition.tr,
                  leadingIconData: Icons.book_rounded,
                  trillingIconData: Icons.arrow_forward_ios_rounded,
                  onTap: termConditionHandleTap,
                ),
                16.height,

                // Contact us
                CustomListTile(
                  leadingIconData: Icons.contact_support,
                  text: LocaleKeys.contactUs.tr,
                  trillingIconData: Icons.arrow_forward_ios_rounded,
                  onTap: contactUsHandleTap,
                ),
                16.height,

                // Log out
                CustomListTile(
                  leadingIconData: Icons.logout,
                  text: LocaleKeys.logout.tr,
                  trillingIconData: Icons.arrow_forward_ios_rounded,
                  onTap: logOutHandleTap,
                ),
              ],
            ),
          ),
          SafeArea(top: false, child: versionWidget()),
          8.height,
        ],
      ),
    );
  }

  Widget versionWidget() {
    return Padding(
      padding: 16.padLeft,
      child: Text(
        '${LocaleKeys.version.tr} ${AppConfig.shared.version}',
        style: AppTextStyle.normalWhiteRegular,
      ),
    );
  }
}
