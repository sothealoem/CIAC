import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ciac_school/core/core.dart';
import 'package:ciac_school/routes.dart';

class CustomNoAccountWidget extends StatelessWidget {
  final bool showForgotPassword;
  final bool isLoginMode; // If true, shows "Login", if false, shows "Register"
  final VoidCallback? onForgotTap;
  final VoidCallback? onActionTap;

  const CustomNoAccountWidget({
    super.key,
    this.showForgotPassword = false,
    this.isLoginMode = true,
    this.onForgotTap,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Optional Forgot Password Section
            if (showForgotPassword) ...[
              InkWell(
                onTap: onForgotTap ?? () => Get.toNamed(Routes.register),
                child: Container(
                  height: 24,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    LocaleKeys.forgotPassword.tr,
                    style: AppTextStyle.normalPrimaryRegular,
                  ),
                ),
              ),
              20.width, // Spacing between the two links
            ],

            // Action Section (Login or Register)
            InkWell(
              onTap: onActionTap ?? () => Get.toNamed(Routes.register),
              child: Container(
                height: 24,
                alignment: Alignment.centerRight,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${LocaleKeys.doNotHaveAnAccount.tr} ",
                        style: AppTextStyle.normalPrimaryRegular,
                      ),
                      TextSpan(
                        text:
                            isLoginMode
                                ? LocaleKeys.login.tr
                                : LocaleKeys.register.tr,
                        style: AppTextStyle.normalRedRegular,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
