import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/flavor/flavor.dart';
import 'package:swis_school/models/models.dart';
import 'package:swis_school/routes.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Development
  // Driver
  // final TextEditingController usernameCtl = TextEditingController(text: '078420717');
  // final TextEditingController passCtl = TextEditingController(text: '078420717');

  // Customer
  // final TextEditingController usernameCtl = TextEditingController(text: '0769523373@gmail.com');
  // final TextEditingController passCtl = TextEditingController(text: '0769523373');

  /// Production
  // Driver
  // final TextEditingController usernameCtl = TextEditingController(text: '093322910');
  // final TextEditingController passCtl = TextEditingController(text: '093322910');

  // Customer
  // final TextEditingController usernameCtl = TextEditingController(text: '078358272@gmail.com');
  // final TextEditingController passCtl = TextEditingController(text: '078358272');

  final TextEditingController usernameCtl = TextEditingController();
  final TextEditingController passCtl = TextEditingController();
  final TextEditingController userCtl = TextEditingController();

  final RxBool isPassVisible = true.obs;
  final RxBool isLogVaiEmail = false.obs;

  @override
  void onInit() {
    _onInit();
    super.onInit();
  }

  Future<void> _onInit() async {
    final String username =
        await SharedPreferencesManager.get(Credential.username.name) ?? '';
    final String password =
        await SharedPreferencesManager.get(Credential.password.name) ?? '';

    if (username.isNotEmpty && password.isNotEmpty) {
      usernameCtl.text = username;
      passCtl.text = password;
    }
  }

  @override
  void onClose() {
    usernameCtl.dispose();
    passCtl.dispose();
    super.onClose();
  }

  Future<void> login() async {
    try {
      final Map<String, dynamic> payload = {
        'username': usernameCtl.text,
        'password': passCtl.text,
      };

      final res = await Get.find<ApiService>().post(
        EndPoints.login,
        payload,
        isShowLoading: true,
      );

      final data = getPropertyFromJson(res.data, 'data');

      final LoginModel login = LoginModel.fromJson(data);

      // final String permission = login.permission;
      final String token = login.token;

      // if (permission != Rule.customer.name && permission != Rule.parent.name) {
      //   DialogManager.showDialog(
      //     title: LocaleKeys.permission.tr,
      //     subTitle: LocaleKeys.noPermission.tr,
      //   );
      //   return;
      // }

      /// Pass token becuase when user login at the first time there is no token value when we init AppConfig in main
      AppConfig.shared.token = token;
      await _getProfile();

      await SharedPreferencesManager.setValue(Credential.token.name, token);
      await SharedPreferencesManager.setValue(
        Credential.username.name,
        usernameCtl.text,
      );
      await SharedPreferencesManager.setValue(
        Credential.password.name,
        passCtl.text,
      );

      DialogManager.hideLoading();
      Get.offAllNamed(Routes.start);
    } catch (e) {
      if (isClosed) {
        return;
      }
      ExceptionHandler.handleException(e);
    }
  }

  Future<void> _getProfile() async {
    try {
      final res = await Get.find<ApiService>().get(
        EndPoints.profile,
        isShowLoading: false,
      );

      final data = getPropertyFromJson(res.data, 'data');

      if (data != null) {
        final ProfileModel profile = ProfileModel.fromJson(data);
        UserRepository.shared.setProfile(profile);
        return;
      }

      Get.offAllNamed(Routes.login);
    } catch (e) {
      if (isClosed) {
        return;
      }
      ExceptionHandler.handleException(e);
    }
  }
}
