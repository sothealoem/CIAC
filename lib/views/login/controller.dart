import 'package:dio/dio.dart' as d;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:schoolapp/core/libraries/shared_preferences.dart';
import 'package:schoolapp/core/resources/resources.dart';
import 'package:schoolapp/core/services/end_points.dart';
import 'package:schoolapp/core/utils/exception_manager.dart';
import 'package:schoolapp/core/utils/form_validator.dart';
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
  final hasEmailText = false.obs;
  final hasPasswordText = false.obs;
  final selectedLoginRole = UserType.parent.obs;

  @override
  void onInit() {
    super.onInit();
    emailCtl.addListener(() => hasEmailText.value = emailCtl.text.isNotEmpty);
    passCtl.addListener(() => hasPasswordText.value = passCtl.text.isNotEmpty);
  }

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
      final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';

      final response = await _loginByRole(
        loginIdentity: loginIdentity,
        password: password,
        fcmToken: fcmToken,
      );
      if (response == null) {
        DialogManager.showDialog(
          title: LocaleKeys.error.tr,
          subTitle: LocaleKeys.noResponseFromServer.tr,
        );
        return;
      }

      ///  check success
      if (response['success'] != true) {
        DialogManager.showDialog(
          title: LocaleKeys.loginFailed.tr,
          subTitle: _localizedLoginMessage(response['message']),
        );
        return;
      }

      final data = response['data'];

      if (data == null) {
        DialogManager.showDialog(
          title: LocaleKeys.error.tr,
          subTitle: LocaleKeys.invalidServerResponse.tr,
        );
        return;
      }

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
      final String userId =
          (data['user_id'] ?? data['id'] ?? '').toString().trim();
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
          title: LocaleKeys.loginFailed.tr,
          subTitle: LocaleKeys.tokenMissing.tr,
        );
        return;
      }

      ///  role check
      final allowedRoles = UserType.allowedRoleKeys;

      if (!allowedRoles.contains(role)) {
        DialogManager.showDialog(
          title: LocaleKeys.permission.tr,
          subTitle: LocaleKeys.noPermission.tr,
        );
        return;
      }

      if (role != selectedLoginRole.value.key) {
        DialogManager.showDialog(
          title: LocaleKeys.loginFailed.tr,
          subTitle:
              '${LocaleKeys.selectedRoleIs.tr} ${selectedLoginRole.value.key}. ${LocaleKeys.pleaseSwitchRoleAndTryAgain.tr}',
        );
        return;
      }

      UserRepository.shared.setUserType(role);

      if (Get.isRegistered<DashboardController>()) {
        final dashboardController = Get.find<DashboardController>();
        dashboardController.userName.value = name;
        await dashboardController.fetchSliders();
      }
      AppConfig.shared.token = token;

      await SharedPreferencesManager.setValue('token', token);
      await SharedPreferencesManager.setValue('username', loginIdentity);
      await SharedPreferencesManager.setValue('password', password);
      await SharedPreferencesManager.setValue('name', name);
      await SharedPreferencesManager.setValue('profile', profile);
      await SharedPreferencesManager.setValue('user_id', userId);
      await SharedPreferencesManager.setValue('staff_code', staffCode);
      await SharedPreferencesManager.setValue('user_role', role);
      await SharedPreferencesManager.setValue(
        'scanner_owner_id',
        scannerOwnerId,
      );

      Get.updateLocale(AppConfig.shared.languageLocale);

      Get.offAllNamed(Routes.start);
    } catch (e) {
      DialogManager.showDialog(
        title: LocaleKeys.error.tr,
        subTitle: LocaleKeys.somethingWentWrongTryAgain.tr,
      );

      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

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
    formKey.currentState?.reset();
    emailCtl.clear();
    passCtl.clear();
    emailError.value = null;
    passwordError.value = null;
  }

  void refreshValidationMessages() {
    emailError.value = null;
    passwordError.value = null;
    formKey.currentState?.validate();
  }

  Future<dynamic> _loginByRole({
    required String loginIdentity,
    required String password,
    required String fcmToken,
  }) async {
    if (selectedLoginRole.value == UserType.parent) {
      return _loginWithPhone(
        loginIdentity: loginIdentity,
        password: password,
        fcmToken: fcmToken,
      );
    }
    return _loginTeacher(
      loginIdentity: loginIdentity,
      password: password,
      fcmToken: fcmToken,
    );
  }

  Future<dynamic> _loginWithPhone({
    required String loginIdentity,
    required String password,
    required String fcmToken,
  }) async {
    final api = Get.find<ApiService>();
    final rawPhone = loginIdentity.trim();
    final normalizedPhone = _normalizePhone(loginIdentity);

    if (!_isLikelyPhone(loginIdentity)) {
      return {
        "success": false,
        "message": LocaleKeys.pleaseEnterValidPhoneNumber.tr,
      };
    }

    final attempts = <Map<String, dynamic>>[
      {"phone": rawPhone, "password": password, "fcm_token": fcmToken},
      {"phone": normalizedPhone, "password": password, "fcm_token": fcmToken},
      {"phone_number": rawPhone, "password": password, "fcm_token": fcmToken},
      {
        "phone_number": normalizedPhone,
        "password": password,
        "fcm_token": fcmToken,
      },
      {
        "phone": rawPhone,
        "phone_number": rawPhone,
        "password": password,
        "fcm_token": fcmToken,
      },
      {
        "phone": normalizedPhone,
        "phone_number": normalizedPhone,
        "password": password,
        "fcm_token": fcmToken,
      },
      {"username": rawPhone, "password": password, "fcm_token": fcmToken},
      {
        "username": normalizedPhone,
        "password": password,
        "fcm_token": fcmToken,
      },
    ];

    dynamic latestResponse = {
      "success": false,
      "message": LocaleKeys.loginFailed.tr,
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
        latestResponse =
            e.response?.data ??
            {
              "success": false,
              "message": e.message ?? LocaleKeys.loginFailed.tr,
            };
      }
    }

    return latestResponse;
  }

  Future<dynamic> _loginTeacher({
    required String loginIdentity,
    required String password,
    required String fcmToken,
  }) async {
    final api = Get.find<ApiService>();
    final attempts = <Map<String, dynamic>>[];
    final rawIdentity = loginIdentity.trim();
    final normalizedPhone = _normalizePhone(loginIdentity);

    if (_isLikelyPhone(loginIdentity)) {
      attempts.add({
        "phone": rawIdentity,
        "password": password,
        "fcm_token": fcmToken,
      });
      attempts.add({
        "phone": normalizedPhone,
        "password": password,
        "fcm_token": fcmToken,
      });
      attempts.add({
        "phone_number": rawIdentity,
        "password": password,
        "fcm_token": fcmToken,
      });
      attempts.add({
        "phone_number": normalizedPhone,
        "password": password,
        "fcm_token": fcmToken,
      });
    }

    if (_isLikelyEmail(loginIdentity)) {
      attempts.add({
        "email": loginIdentity.toLowerCase(),
        "password": password,
        "fcm_token": fcmToken,
      });
    }

    attempts.add({
      "username": rawIdentity,
      "password": password,
      "fcm_token": fcmToken,
    });

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
        latestResponse =
            e.response?.data ??
            {
              "success": false,
              "message": e.message ?? LocaleKeys.loginFailed.tr,
            };
      }
    }
    return latestResponse;
  }

  bool _isLikelyPhone(String text) {
    return RegExp(r'^\+?\d{6,15}$').hasMatch(_normalizePhone(text));
  }

  bool _isLikelyEmail(String text) {
    return RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
      caseSensitive: false,
    ).hasMatch(text.trim());
  }

  String? validateIdentity(String? text) {
    final identity = (text ?? '').trim();
    if (selectedLoginRole.value == UserType.parent) {
      return FormValidator.phoneNumber(identity);
    }

    final emptyCheck = FormValidator.empty(identity);
    if (emptyCheck != null) return emptyCheck;

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

  String _localizedLoginMessage(dynamic rawMessage) {
    final message = (rawMessage ?? '').toString().trim();
    final lower = message.toLowerCase();

    if (message.isEmpty) {
      return LocaleKeys.invalidCredentials.tr;
    }
    if (lower.contains('invalid') && lower.contains('credential')) {
      return LocaleKeys.invalidCredentials.tr;
    }
    if (lower == 'login failed' || lower.contains('login failed')) {
      return LocaleKeys.loginFailedMessage.tr;
    }
    if (lower.contains('valid phone')) {
      return LocaleKeys.pleaseEnterValidPhoneNumber.tr;
    }
    if (lower.contains('no response')) {
      return LocaleKeys.noResponseFromServer.tr;
    }
    return message;
  }
}
