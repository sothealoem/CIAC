import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/views/login/widgets/inline_language_dropdown.dart';
import 'package:schoolapp/views/login/widgets/role_switch_label.dart';
import 'package:schoolapp/views/login/widgets/socialButtonCustom.dart';
import 'package:schoolapp/views/views.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  void registerTap() async {
    await controller.register();
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
                            AssetPath.appLogo.path,
                            height: 110,
                            width: 110,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      10.height,
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
                                LocaleKeys.signUp.tr,
                                style: AppTextStyle.hugePrimaryMediumBold,
                              ),
                              UIConstants.spacingSmall.height,
                              Text(
                                LocaleKeys.loginContinueMessage.tr,
                                style: AppTextStyle.normalGreenRegular,
                                textAlign: TextAlign.center,
                              ),
                              UIConstants.spacing.height,
                              Obx(() {
                                final selected =
                                    controller.selectedRegisterRole.value;
                                return Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    RoleSwitchLabel(
                                      label: LocaleKeys.teacher.tr,
                                      isSelected: selected == UserType.teacher,
                                      onTap:
                                          () => controller.setRegisterRole(
                                            UserType.teacher,
                                          ),
                                      icon: Icons.cast_for_education,
                                    ),
                                    RoleSwitchLabel(
                                      label: LocaleKeys.parent.tr,
                                      isSelected: selected == UserType.parent,
                                      onTap:
                                          () => controller.setRegisterRole(
                                            UserType.parent,
                                          ),
                                      icon: Icons.people_alt,
                                    ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 15),
                              Obx(
                                () => CustomTextField(
                                  key: ValueKey(
                                    'register_name_${controller.selectedRegisterRole.value.key}',
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: AppColor.primary,
                                  ),
                                  controller: controller.nameCon,
                                  hintText: LocaleKeys.enterYourName.tr,
                                  errorText: controller.nameError.value,
                                  onChanged:
                                      (val) =>
                                          controller.nameError.value = null,
                                  validator: FormValidator.empty,
                                ),
                              ),
                              UIConstants.spacing.height,
                              Obx(() {
                                final isParent =
                                    controller.selectedRegisterRole.value ==
                                    UserType.parent;
                                return CustomTextField(
                                  key: ValueKey(
                                    'register_identity_${controller.selectedRegisterRole.value.key}',
                                  ),
                                  prefixIcon: Icon(
                                    isParent ? Icons.phone : Icons.person,
                                    color: AppColor.primary,
                                  ),
                                  controller: controller.identityCon,
                                  hintText:
                                      isParent
                                          ? LocaleKeys.phoneNumber.tr
                                          : LocaleKeys.phoneOrEmail.tr,
                                  errorText: controller.identityError.value,
                                  onChanged:
                                      (val) =>
                                          controller.identityError.value = null,
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
                                  controller: controller.passCon,
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
                                  validator: FormValidator.empty,
                                ),
                              ),
                              UIConstants.spacing.height,
                              Obx(
                                () => CustomTextField(
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: AppColor.primary,
                                  ),
                                  controller: controller.confirmCon,
                                  hintText: LocaleKeys.confirmPassword.tr,
                                  errorText:
                                      controller.confirmPasswordError.value,
                                  onChanged:
                                      (val) =>
                                          controller
                                              .confirmPasswordError
                                              .value = null,
                                  obscureText:
                                      controller.isPassVisibleConfirm.value,
                                  suffixIcon: InkWell(
                                    onTap:
                                        () =>
                                            controller
                                                .isPassVisibleConfirm
                                                .value = !controller
                                                    .isPassVisibleConfirm
                                                    .value,
                                    child: Icon(
                                      controller.isPassVisibleConfirm.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                  validator:
                                      (text) => FormValidator.equalValues(
                                        original: controller.passCon.text,
                                        confirm: text,
                                      ),
                                ),
                              ),
                              UIConstants.spacing.height,
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [InlineLanguageDropdown()],
                              ),
                              UIConstants.spacing.height,
                              Obx(() {
                                final isLoading = controller.isLoading.value;
                                return SizedBox(
                                  width: double.infinity,
                                  height: UIConstants.btnHeight,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : registerTap,
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
                                                LocaleKeys.signUp.tr,
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
                                child: Column(
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 10,
                                      runSpacing: 4,
                                      children: [
                                        Text(
                                          LocaleKeys.haveAnAccount.tr,
                                          style:
                                              AppTextStyle.normalGreenRegular,
                                        ),
                                        InkWell(
                                          onTap: Get.back,
                                          child: Text(
                                            LocaleKeys.login.tr,
                                            style: const TextStyle(
                                              color: AppColor.primary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      LocaleKeys.orConnectWith.tr,
                                      style: AppTextStyle.normalGreenRegular,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      UIConstants.spacingSmall.height,

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
