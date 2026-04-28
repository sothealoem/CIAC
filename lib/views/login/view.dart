import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                            height: 120,
                            width: 120,
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
                              Text(
                                LocaleKeys.loginNow.tr,
                                style: AppTextStyle.hugePrimaryMediumBold,
                              ),
                              UIConstants.midSpacing.height,
                              Text(
                                LocaleKeys.loginContinueMessage.tr,
                                style: AppTextStyle.normalGreenRegular,
                              ),
                              UIConstants.spacing.height,
                              Obx(() {
                                final selected =
                                    controller.selectedLoginRole.value;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _RoleSwitchLabel(
                                      label: LocaleKeys.teacher.tr,
                                      isSelected: selected == UserType.teacher,
                                      onTap:
                                          () => controller.setLoginRole(
                                            UserType.teacher,
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    _RoleSwitchLabel(
                                      label: LocaleKeys.parent.tr,
                                      isSelected: selected == UserType.parent,
                                      onTap:
                                          () => controller.setLoginRole(
                                            UserType.parent,
                                          ),
                                    ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 15),
                              Obx(() {
                                final isParent =
                                    controller.selectedLoginRole.value ==
                                    UserType.parent;
                                return CustomTextField(
                                  key: ValueKey(
                                    'login_identity_${controller.selectedLoginRole.value.key}',
                                  ),
                                  prefixIcon: Icon(
                                    isParent ? Icons.phone : Icons.person,
                                    color: AppColor.primary,
                                  ),
                                  controller: controller.emailCtl,
                                  hintText:
                                      isParent
                                          ? LocaleKeys.phoneNumber.tr
                                          : LocaleKeys.phoneOrEmail.tr,
                                  errorText: controller.emailError.value,
                                  onChanged:
                                      (val) =>
                                          controller.emailError.value = null,
                                  keyboardType:
                                      isParent
                                          ? TextInputType.phone
                                          : TextInputType.text,
                                  inputFormatters:
                                      isParent
                                          ? [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                              12,
                                            ),
                                          ]
                                          : null,
                                  validator: controller.validateIdentity,
                                );
                              }),
                              UIConstants.spacing.height,
                              Obx(
                                () => CustomTextField(
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: AppColor.primary,
                                  ),
                                  controller: controller.passCtl,
                                  hintText: LocaleKeys.password.tr,
                                  errorText: controller.passwordError.value,
                                  onChanged:
                                      (val) =>
                                          controller.passwordError.value = null,
                                  obscureText: controller.isPassVisible.value,
                                  suffixIcon: InkWell(
                                    onTap:
                                        () =>
                                            controller.isPassVisible.value =
                                                !controller.isPassVisible.value,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Text(
                                      '${LocaleKeys.forgotPassword.tr}?',
                                      style: const TextStyle(
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
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      child:
                                          isLoading
                                              ? Row(
                                                key: const ValueKey('loading'),
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
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
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    LocaleKeys.signingIn.tr,
                                                    style: const TextStyle(
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
                                                    AppTextStyle
                                                        .normalWhiteBold,
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
                                    Text(
                                      LocaleKeys.doNotHaveAnAccount.tr,
                                      style: AppTextStyle.normalGreenRegular,
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () => Get.toNamed(Routes.register),
                                      child: Text(
                                        LocaleKeys.signUp.tr,
                                        style: const TextStyle(
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

class _RoleSwitchLabel extends StatelessWidget {
  const _RoleSwitchLabel({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: isSelected ? AppColor.primary.withOpacity(0.12) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColor.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColor.primary : Colors.black54,
          ),
        ),
      ),
    );
  }
}
