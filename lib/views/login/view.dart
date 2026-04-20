import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/routes.dart';
import 'package:swis_school/views/login/widgets/socialButtonCustom.dart';
import 'package:swis_school/views/views.dart';

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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        UIConstants.spacing.height,
                        // Logo Widget
                        SizedBox(height: 40.0),
                        const LogoWidget(),

                        SizedBox(height: 10.0),
                        //card form
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
                                SizedBox(height: 10.0),
                                Text(
                                  "Log In Now",
                                  style: AppTextStyle.hugePrimaryMediumBold,
                                ),
                                UIConstants.spacing.height,
                                Text(
                                  "Please login to countinue using our app",
                                  style: AppTextStyle.normalGreenBold,
                                ),
                                UIConstants.spacing.height,

                                // Email Field
                                Obx(
                                  () => CustomTextField(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: AppColor.primary,
                                    ),
                                    controller: controller.emailCtl,
                                    hintText: "Email",
                                    errorText:
                                        controller
                                            .emailError
                                            .value, // This shows the error below the field
                                    onChanged:
                                        (val) =>
                                            controller.emailError.value =
                                                null, // Clear error when typing
                                    validator:
                                        (text) => FormValidator.email(text),
                                  ),
                                ),

                                UIConstants.spacing.height,

                                // Password Field
                                Obx(
                                  () => CustomTextField(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: AppColor.primary,
                                    ),
                                    controller: controller.passCtl,
                                    hintText: "Password",
                                    errorText:
                                        controller
                                            .passwordError
                                            .value, // This shows the error below the field
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
                                //Inside your build method, replacing the form fields:
                                //mail/Username Field
                                UIConstants.spacing.height,

                                // Update button to call the controller method
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          color: AppColor.primary,
                                          fontSize: 14,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      onTap:
                                          () => Get.toNamed(
                                            Routes.changePassword,
                                          ),
                                    ),
                                  ],
                                ),
                                UIConstants.spacing.height,
                                PrimaryButton(
                                  text: LocaleKeys.login.tr,
                                  onPressed: () => controller.login(),
                                ),

                                UIConstants.spacing.height,

                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't Have Account?",
                                        style: AppTextStyle.normalGreenRegular,
                                      ),
                                      SizedBox(width: 10),
                                      InkWell(
                                        onTap:
                                            () => Get.toNamed(Routes.register),

                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(
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
                                ),
                                SizedBox(height: 2),
                              ],
                            ),
                          ),
                        ),
                        // Expands to fill remaining space
                        UIConstants.spacing.height,
                        SocialButtonCustomWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
