import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ciac_school/core/core.dart';

class DialogManager {
  DialogManager._();

  static Future<dynamic> showCustom(Widget content) {
    while (Get.isOverlaysOpen) {
      Get.back(closeOverlays: false);
    }

    return Get.dialog(
      content,
      transitionDuration: const Duration(milliseconds: 150),
    );
  }

  static Future<dynamic> showDialog({
    required String title,
    required String subTitle,
    Function()? onPressed,
    String? btnText,
  }) async {
    while (Get.isOverlaysOpen) {
      Get.back(closeOverlays: false);
    }

    return Get.dialog(
      barrierDismissible: false,
      PrimaryDialog(
        title: title,
        subTitle: subTitle,
        onPressed: () {
          Get.back();
          onPressed?.call();
        },
      ),
      transitionDuration: const Duration(milliseconds: 150),
    );
  }

  static Future<dynamic> showConnectionDialog() async {
    while (Get.isOverlaysOpen) {
      Get.back(closeOverlays: true);
    }

    return Get.dialog(
      barrierDismissible: false,
      PrimaryDialog(
        title: LocaleKeys.somethingWentWrong.tr,
        subTitle: LocaleKeys.unableToConnectToTheInternet.tr,
        btnText: LocaleKeys.ok.tr.toUpperCase(),
        onPressed: () => Get.back(),
      ),
      transitionDuration: const Duration(milliseconds: 150),
    );
  }

  static Future<dynamic> showLoadingDialog() {
    while (Get.isOverlaysOpen) {
      Get.back(closeOverlays: true);
    }

    return Get.dialog(barrierDismissible: false, const LoadingDialog());
  }

  static void hideLoading() => Get.back();
}
