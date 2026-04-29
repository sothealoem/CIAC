import 'package:schoolapp/core/libraries/shared_preferences.dart';
import 'package:schoolapp/core/services/end_points.dart';
import 'package:schoolapp/core/utils/exception_manager.dart';
import 'package:schoolapp/core/utils/form_validator.dart';
import 'package:schoolapp/core/constants/constants.dart';
import 'package:schoolapp/flavor/app_config.dart';
import 'package:schoolapp/routes.dart';
import 'package:schoolapp/views/dashboard/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as d;

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
  final selectedLoginRole = UserType.parent.obs;

  @override
  void onClose() {
    emailCtl.dispose();
    passCtl.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    if (isLoading.value) return;

    final String loginIdentity = emailCtl.text.trim();
    final String password = passCtl.text.trim();

    try {
      isLoading.value = true;

      final response = await _loginByRole(
        loginIdentity: loginIdentity,
        password: password,
      );
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
      final String staffCode =
          (data['staff_code'] ?? data['code'] ?? data['id'] ?? '')
              .toString()
              .trim();
      final String scannerOwnerId = _resolveScannerOwnerId(
        data: data,
        fallbackUsername: loginIdentity,
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

      if (role != selectedLoginRole.value.key) {
        DialogManager.showDialog(
          title: "Login Failed",
          subTitle:
              "Selected role is ${selectedLoginRole.value.key}. Please switch role and try again.",
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
      await SharedPreferencesManager.setValue('username', loginIdentity);
      await SharedPreferencesManager.setValue('password', password);
      await SharedPreferencesManager.setValue('name', name);
      await SharedPreferencesManager.setValue('profile', profile);
      await SharedPreferencesManager.setValue('staff_code', staffCode);
      await SharedPreferencesManager.setValue('user_role', role);
      await SharedPreferencesManager.setValue(
        'scanner_owner_id',
        scannerOwnerId,
      );

      // Ensure locale is refreshed for the authenticated area as well.
      Get.updateLocale(AppConfig.shared.languageLocale);

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

  void setLoginRole(UserType role) {
    if (selectedLoginRole.value == role) return;
    selectedLoginRole.value = role;
    emailCtl.clear();
    passCtl.clear();
    emailError.value = null;
    passwordError.value = null;
  }

  Future<dynamic> _loginByRole({
    required String loginIdentity,
    required String password,
  }) async {
    if (selectedLoginRole.value == UserType.parent) {
      return _loginWithPhone(loginIdentity: loginIdentity, password: password);
    }
    return _loginTeacher(loginIdentity: loginIdentity, password: password);
  }

  Future<dynamic> _loginWithPhone({
    required String loginIdentity,
    required String password,
  }) async {
    final api = Get.find<ApiService>();
    final rawPhone = loginIdentity.trim();
    final normalizedPhone = _normalizePhone(loginIdentity);

    if (!_isLikelyPhone(loginIdentity)) {
      return {
        "success": false,
        "message": "Please enter a valid phone number",
      };
    }

    final attempts = <Map<String, dynamic>>[
      {
        "phone": rawPhone,
        "password": password,
      },
      {
        "phone": normalizedPhone,
        "password": password,
      },
      {
        "phone_number": rawPhone,
        "password": password,
      },
      {
        "phone_number": normalizedPhone,
        "password": password,
      },
      {
        "phone": rawPhone,
        "phone_number": rawPhone,
        "password": password,
      },
      {
        "phone": normalizedPhone,
        "phone_number": normalizedPhone,
        "password": password,
      },
      {
        "username": rawPhone,
        "password": password,
      },
      {
        "username": normalizedPhone,
        "password": password,
      },
    ];

    dynamic latestResponse = {
      "success": false,
      "message": "Login failed",
    };

    for (final payload in attempts) {
      try {
        final res = await api.post(
          EndPoints.login,
          payload,
          isShowLoading: true,
        );
        latestResponse = res.data;
        if (latestResponse is Map && latestResponse['success'] == true) {
          return latestResponse;
        }
      } on d.DioException catch (e) {
        latestResponse = e.response?.data ??
            {
              "success": false,
              "message": e.message ?? "Login failed",
            };
      }
    }

    return latestResponse;
  }

  Future<dynamic> _loginTeacher({
    required String loginIdentity,
    required String password,
  }) async {
    final api = Get.find<ApiService>();
    final attempts = <Map<String, dynamic>>[];
    final rawIdentity = loginIdentity.trim();
    final normalizedPhone = _normalizePhone(loginIdentity);

    if (_isLikelyPhone(loginIdentity)) {
      attempts.add({
        "phone": rawIdentity,
        "password": password,
      });
      attempts.add({
        "phone": normalizedPhone,
        "password": password,
      });
      attempts.add({
        "phone_number": rawIdentity,
        "password": password,
      });
      attempts.add({
        "phone_number": normalizedPhone,
        "password": password,
      });
    }

    if (_isLikelyEmail(loginIdentity)) {
      attempts.add({
        "email": loginIdentity.toLowerCase(),
        "password": password,
      });
    }

    // Teacher accounts may still authenticate with username/staff code.
    attempts.add({
      "username": rawIdentity,
      "password": password,
    });

    if (attempts.isEmpty) {
      return {
        "success": false,
        "message": "Please enter username, phone number, or email",
      };
    }

    dynamic latestResponse;
    for (final payload in attempts) {
      try {
        final res = await api.post(
          EndPoints.login,
          payload,
          isShowLoading: true,
        );
        latestResponse = res.data;
        if (latestResponse is Map && latestResponse['success'] == true) {
          return latestResponse;
        }
      } on d.DioException catch (e) {
        latestResponse = e.response?.data ??
            {
              "success": false,
              "message": e.message ?? "Login failed",
            };
      }
    }
    return latestResponse;
  }

  bool _isLikelyPhone(String text) {
    return RegExp(r'^\+?\d{6,15}$').hasMatch(_normalizePhone(text));
  }

  bool _isLikelyEmail(String text) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$', caseSensitive: false).hasMatch(
      text.trim(),
    );
  }

  String? validateIdentity(String? text) {
    final identity = (text ?? '').trim();
    if (selectedLoginRole.value == UserType.parent) {
      return FormValidator.phoneNumber(identity);
    }

    final emptyCheck = FormValidator.empty(identity);
    if (emptyCheck != null) return emptyCheck;

    if (_isLikelyPhone(identity) || _isLikelyEmail(identity)) {
      return null;
    }
    return null;
  }

  String _normalizePhone(String text) {
    return text.replaceAll(RegExp(r'[\s\-\(\)]'), '');
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
