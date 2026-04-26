import 'package:schoolapp/core/libraries/shared_preferences.dart';
import 'package:schoolapp/core/services/end_points.dart';
import 'package:schoolapp/core/utils/exception_manager.dart';
import 'package:schoolapp/core/constants/constants.dart';
import 'package:schoolapp/flavor/app_config.dart';
import 'package:schoolapp/routes.dart';
import 'package:schoolapp/views/dashboard/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/dialog_manager.dart';
import '../../../core/repositories/user.dart';

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
      final String profile = _firstNonEmpty([
        data['profile'],
        data['profile_path'],
        data['avatar'],
        data['photo'],
        data['image'],
      ]);
      final String scannerOwnerId = _resolveScannerOwnerId(
        data: data,
        fallbackUsername: username,
      );

      if (token.isEmpty) {
        DialogManager.showDialog(
          title: "Login Failed",
          subTitle: "Token missing",
        );
        return;
      }

      ///  role check
      final allowedRoles = UserType.allowedRoleKeys;

      if (!allowedRoles.contains(role)) {
        DialogManager.showDialog(
          title: "Permission",
          subTitle: "No permission",
        );
        return;
      }

      // Keep role locally so start screen can build correct tabs immediately.
      UserRepository.shared.setUserType(role);

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
      await SharedPreferencesManager.setValue('profile', profile);
      await SharedPreferencesManager.setValue('user_role', role);
      await SharedPreferencesManager.setValue(
        'scanner_owner_id',
        scannerOwnerId,
      );

      /// navigate
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

  String _resolveScannerOwnerId({
    required dynamic data,
    required String fallbackUsername,
  }) {
    if (data is! Map<String, dynamic>) {
      return fallbackUsername;
    }

    final candidates = <dynamic>[
      data['staff_code'],
      data['card_uid'],
      data['code'],
      data['user_code'],
      data['employee_code'],
      data['id'],
      data['username'],
      fallbackUsername,
    ];

    for (final value in candidates) {
      final text = (value ?? '').toString().trim();
      if (text.isNotEmpty) {
        return text;
      }
    }
    return fallbackUsername;
  }

  String _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      final text = (value ?? '').toString().trim();
      if (text.isNotEmpty &&
          text.toLowerCase() != 'null' &&
          text.toLowerCase() != 'n/a') {
        return text;
      }
    }
    return '';
  }
}
