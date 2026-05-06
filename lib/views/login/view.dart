import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/routes.dart';
import 'package:schoolapp/views/login/widgets/inline_language_dropdown.dart';
import 'package:schoolapp/views/login/widgets/role_switch_label.dart';
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
      backgroundColor: Colors.white,
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
                      const SizedBox(height: 28.0),
                      Hero(
                        tag: 'app_logo_hero',
                        child: Container(
                          height: 150,
                          width: 150,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFD50B1E),
                              //  width: 1.6,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFD50B1E,
                                ).withOpacity(0.16),
                                blurRadius: 22,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              AssetPath.appLogo.path,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.transparent,
                        ),
                        child: Padding(
                          padding: UIConstants.spacing.padHorizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10.0),
                              Text(
                                LocaleKeys.loginNow.tr,
                                style: AppTextStyle.hugePrimaryMediumBold
                                    .copyWith(
                                      color: const Color(0xFF064D47),
                                      fontSize: 30,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                LocaleKeys.loginContinueMessage.tr,
                                textAlign: TextAlign.center,
                                style: AppTextStyle.normalGreenRegular.copyWith(
                                  color: const Color(0xFF5E626D),
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 28),
                              Obx(() {
                                final selected =
                                    controller.selectedLoginRole.value;
                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    final width =
                                        constraints.maxWidth > 0
                                            ? constraints.maxWidth
                                            : MediaQuery.of(
                                                  context,
                                                ).size.width -
                                                56;
                                    final indicatorWidth = (width - 8) / 2;
                                    final isTeacher =
                                        selected == UserType.teacher;

                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFFE6E8EE),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.06,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: SizedBox(
                                        height: 52,
                                        child: Stack(
                                          children: [
                                            AnimatedPositioned(
                                              duration: const Duration(
                                                milliseconds: 280,
                                              ),
                                              curve: Curves.easeInOutCubic,
                                              left:
                                                  isTeacher
                                                      ? 0
                                                      : indicatorWidth,
                                              top: 0,
                                              bottom: 0,
                                              child: Container(
                                                width: indicatorWidth,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        999,
                                                      ),
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFFFFEEF0),
                                                          Color(0xFFFFD9DE),
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end:
                                                            Alignment
                                                                .bottomRight,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: RoleSwitchLabel(
                                                    label:
                                                        LocaleKeys.teacher.tr,
                                                    icon: Icons.school,
                                                    isSelected: isTeacher,
                                                    onTap:
                                                        () => controller
                                                            .setLoginRole(
                                                              UserType.teacher,
                                                            ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: RoleSwitchLabel(
                                                    label: LocaleKeys.parent.tr,
                                                    icon: Icons.groups,
                                                    isSelected: !isTeacher,
                                                    onTap:
                                                        () => controller
                                                            .setLoginRole(
                                                              UserType.parent,
                                                            ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
                                  prefixIcon: _LoginPrefixIcon(
                                    icon: isParent ? Icons.phone : Icons.person,
                                  ),
                                  controller: controller.emailCtl,
                                  hintText:
                                      isParent
                                          ? LocaleKeys.phoneNumber.tr
                                          : LocaleKeys.phoneOrEmail.tr,
                                  filled: true,
                                  borderRadius: BorderRadius.circular(22),
                                  borderColor: const Color(0xFFC9CFD8),
                                  enabledBorderColor: const Color(0xFFC9CFD8),
                                  focusedBorderColor: AppColor.primary,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
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
                                  prefixIcon: const _LoginPrefixIcon(
                                    icon: Icons.lock,
                                  ),
                                  controller: controller.passCtl,
                                  hintText: LocaleKeys.password.tr,
                                  errorText: controller.passwordError.value,
                                  onChanged:
                                      (val) =>
                                          controller.passwordError.value = null,
                                  obscureText: controller.isPassVisible.value,
                                  filled: true,
                                  borderRadius: BorderRadius.circular(22),
                                  borderColor: const Color(0xFFC9CFD8),
                                  enabledBorderColor: const Color(0xFFC9CFD8),
                                  focusedBorderColor: AppColor.primary,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  suffixIcon: SizedBox(
                                    width: 62,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 1,
                                          height: 22,
                                          color: const Color(0xFFD6DBE3),
                                        ),
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap:
                                              () =>
                                                  controller
                                                      .isPassVisible
                                                      .value = !controller
                                                          .isPassVisible
                                                          .value,
                                          child: Icon(
                                            controller.isPassVisible.value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: const Color(0xFFD50B1E),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
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
                                  const InlineLanguageDropdown(),

                                  InkWell(
                                    child: Text(
                                      '${LocaleKeys.forgotPassword.tr}?',
                                      style: const TextStyle(
                                        color: Color(0xFFD50B1E),
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onTap:
                                        () =>
                                            Get.toNamed(Routes.forgotPassword),
                                  ),
                                ],
                              ),
                              UIConstants.spacing.height,
                              Obx(() {
                                final isLoading = controller.isLoading.value;
                                return SizedBox(
                                  width: double.infinity,
                                  height: UIConstants.btnHeight,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF6B78),
                                          Color(0xFFFF3F4E),
                                          Color(0xFFD50B1E),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFD50B1E,
                                          ).withOpacity(0.22),
                                          blurRadius: 12,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : loginTab,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        disabledBackgroundColor:
                                            Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        child:
                                            isLoading
                                                ? Row(
                                                  key: const ValueKey(
                                                    'loading',
                                                  ),
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
                                  ),
                                );
                              }),
                              UIConstants.spacing.height,
                              Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 10,
                                  runSpacing: 4,
                                  children: [
                                    Text(
                                      LocaleKeys.doNotHaveAnAccount.tr,
                                      style: AppTextStyle.normalGreenRegular
                                          .copyWith(
                                            color: const Color(0xFF064D47),
                                          ),
                                    ),
                                    InkWell(
                                      onTap: () => Get.toNamed(Routes.register),
                                      child: Text(
                                        LocaleKeys.signUp.tr,
                                        style: const TextStyle(
                                          color: Color(0xFFD50B1E),
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

class _LoginPrefixIcon extends StatelessWidget {
  const _LoginPrefixIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      alignment: Alignment.center,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEEF0),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: const Color(0xFFD50B1E), size: 24),
      ),
    );
  }
}
