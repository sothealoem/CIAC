import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/routes.dart';
import 'package:schoolapp/views/login/widgets/socialButtonCustom.dart';
import 'package:schoolapp/views/views.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  void loginTab() async {
    if (!controller.formKey.currentState!.validate()) {
      return;
    }
    controller.formKey.currentState!.save();
    await controller.login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: bottomInset + 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UIConstants.spacing.height,
                      const SizedBox(height: 40.0),
                      Hero(
                        tag: 'app_logo_hero',
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/app_icon.png',
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: UIConstants.spacing.padHorizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10.0),
                              const Text(
                                "Log In Now",
                                style: AppTextStyle.hugePrimaryMediumBold,
                              ),
                              UIConstants.spacing.height,
                              const Text(
                                "Please login to countinue using our app",
                                style: AppTextStyle.normalGreenBold,
                              ),
                              UIConstants.spacing.height,
                              Obx(
                                () => CustomTextField(
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: AppColor.primary,
                                  ),
                                  controller: controller.emailCtl,
                                  hintText: "Username or Email",
                                  errorText: controller.emailError.value,
                                  onChanged:
                                      (val) =>
                                          controller.emailError.value = null,
                                  validator:
                                      (text) => FormValidator.empty(text),
                                ),
                              ),
                              UIConstants.spacing.height,
                              Obx(
                                () => CustomTextField(
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: AppColor.primary,
                                  ),
                                  controller: controller.passCtl,
                                  hintText: "Password",
                                  errorText: controller.passwordError.value,
                                  onChanged:
                                      (val) =>
                                          controller.passwordError.value =
                                              null,
                                  obscureText: controller.isPassVisible.value,
                                  suffixIcon: InkWell(
                                    onTap:
                                        () =>
                                            controller.isPassVisible.value =
                                                !controller
                                                    .isPassVisible
                                                    .value,
                                    child: Icon(
                                      controller.isPassVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                  validator:
                                      (text) => FormValidator.empty(text),
                                ),
                              ),
                              UIConstants.spacing.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: AppColor.primary,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onTap:
                                        () =>
                                            Get.toNamed(Routes.changePassword),
                                  ),
                                ],
                              ),
                              UIConstants.spacing.height,
                              Obx(() {
                                final isLoading = controller.isLoading.value;
                                return SizedBox(
                                  width: double.infinity,
                                  height: UIConstants.btnHeight,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : loginTab,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.primary,
                                      disabledBackgroundColor: AppColor.primary
                                          .withOpacity(0.8),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            UIConstants.radius.radiusAll,
                                      ),
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 500),
                                      child:
                                          isLoading
                                              ? const Row(
                                                key: ValueKey('loading'),
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 18,
                                                    height: 18,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2.4,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "Signing in...",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              )
                                              : Text(
                                                LocaleKeys.login.tr,
                                                key: const ValueKey('idle'),
                                                style:
                                                    AppTextStyle.normalWhiteBold,
                                              ),
                                    ),
                                  ),
                                );
                              }),
                              UIConstants.spacing.height,
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don't Have Account?",
                                      style: AppTextStyle.normalGreenRegular,
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () => Get.toNamed(Routes.register),
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          color: AppColor.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],
                          ),
                        ),
                      ),
                      UIConstants.spacing.height,
                      const SizedBox(height: 12),
                      const SocialButtonCustomWidget(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
