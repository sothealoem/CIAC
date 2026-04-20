import 'package:swis_school/core/libraries/shared_preferences.dart';
import 'package:swis_school/core/services/end_points.dart';
import 'package:swis_school/core/utils/exception_manager.dart';
import 'package:swis_school/flavor/app_config.dart';
import 'package:swis_school/routes.dart';
import 'package:swis_school/views/dashboard/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/dialog_manager.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailCtl = TextEditingController();
  final TextEditingController passCtl = TextEditingController();

  var isLoading = false.obs;
  var isPassVisible = true.obs;

  var emailError = RxnString();
  var passwordError = RxnString();

  @override
  void onClose() {
    emailCtl.dispose();
    passCtl.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    if (isLoading.value) return;

    final String username = emailCtl.text.trim();
    final String password = passCtl.text.trim();

    try {
      isLoading.value = true;

      final res = await Get.find<ApiService>().post(EndPoints.login, {
        "username": username,
        "password": password,
      }, isShowLoading: true);

      final response = res.data;
      print("LOGIN RESPONSE: $response");

      if (response == null) {
        DialogManager.showDialog(
          title: "Error",
          subTitle: "No response from server",
        );
        return;
      }

      ///  check success
      if (response['success'] != true) {
        DialogManager.showDialog(
          title: "Login Failed",
          subTitle: response['message'] ?? "Invalid credentials",
        );
        return;
      }

      final data = response['data'];

      if (data == null) {
        DialogManager.showDialog(
          title: "Error",
          subTitle: "Invalid server response",
        );
        return;
      }

      ///  extract values safely
      final String token = data['token']?.toString() ?? '';
      final String role = (data['role'] ?? '').toString().toLowerCase();
      final String name = data['name']?.toString() ?? '';

      if (token.isEmpty) {
        DialogManager.showDialog(
          title: "Login Failed",
          subTitle: "Token missing",
        );
        return;
      }

      ///  role check
      const allowedRoles = ['admin', 'teacher', 'parent'];

      if (!allowedRoles.contains(role)) {
        DialogManager.showDialog(
          title: "Permission",
          subTitle: "No permission",
        );
        return;
      }

      ///  SET NAME (clean & safe)
      final dashboardController = Get.find<DashboardController>();
      dashboardController.userName.value = name;
      print("CONTROLLER NAME: ${dashboardController.userName.value}");

      ///  save token
      AppConfig.shared.token = token;

      await SharedPreferencesManager.setValue('token', token);
      await SharedPreferencesManager.setValue('username', username);
      await SharedPreferencesManager.setValue('password', password);
      await SharedPreferencesManager.setValue('name', name);

      ///  navigate
      Get.offAllNamed(Routes.start);
    } catch (e) {
      print("LOGIN ERROR: $e");

      DialogManager.showDialog(
        title: "Error",
        subTitle: "Something went wrong. Please try again.",
      );

      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  ///  logout
  Future<void> logout() async {
    await SharedPreferencesManager.clear();
    AppConfig.shared.token = '';
    Get.offAllNamed(Routes.login);
  }
}
