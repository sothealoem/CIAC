import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/models/models.dart';
import 'package:schoolapp/routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void onInit() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.repeat();

    fetchInit();

    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  Future<void> fetchInit() async {
    final String token =
        await SharedPreferencesManager.get(Credential.token.name) ?? '';
    if (token.isEmpty) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        controller.stop();
        Get.offAllNamed(Routes.login);
      });
      return;
    }

    try {
      final res = await Get.find<ApiService>().get(
        EndPoints.profile,
        isShowLoading: false,
      );

      final data = getPropertyFromJson(res.data, 'data');
      if (data != null) {
        final ProfileModel profile = ProfileModel.fromJson(data);
        UserRepository.shared.setProfile(profile);
        controller.stop();
        Get.offAllNamed(Routes.start);
        return;
      }

      controller.stop();
      Get.offAllNamed(Routes.login);
    } catch (e) {
      if (isClosed) {
        return;
      }
      controller.stop();
      Get.offAllNamed(Routes.login);
    }
  }
}
