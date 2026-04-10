import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/views/login/widgets/socialButtonCustom.dart';
import 'package:swis_school/views/views.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  void registerTab() {
    if (!controller.formKey.currentState!.validate()) {
      return;
    }
    controller.formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text(LocaleKeys.register.tr)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UIConstants.spacingMedium.height,
                // logo
                const LogoWidget(),
                Text("Sign Up", style: AppTextStyle.hugePrimarySemiBold),
                SizedBox(height: 10.0),

                Center(
                  child: Text(
                    "Please enter your information for create \nyour account.",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.normalGreenBold,
                  ),
                ),

                UIConstants.spacing.height,

                Padding(
                  padding: UIConstants.spacing.padHorizontal,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: controller.nameCon,
                        hintText: LocaleKeys.enterYourName.tr,
                        validator: (text) => FormValidator.empty(text),
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icon(Icons.person, color: AppColor.primary),
                      ),

                      UIConstants.spacing.height,
                      CustomTextField(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: AppColor.primary,
                        ),
                        controller: controller.email,
                        hintText: LocaleKeys.email.tr,
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) => FormValidator.email(text),
                      ),
                      // CustomTextField(
                      //   prefixIcon: Icon(Icons.email),
                      //   controller: controller.email,
                      //   hintText: LocaleKeys.email.tr,

                      //   // controller.isLogVaiEmail.value
                      //   //     ? LocaleKeys.email.tr
                      //   //     : LocaleKeys.phoneNumber.tr,
                      //   validator: (text) {
                      //     if (controller.isLogVaiEmail.value) {
                      //       return FormValidator.email(text); // Validate email
                      //     }
                      //     // return FormValidator.phoneNumber(text);
                      //   },
                      // ),

                      // CustomTextField(
                      //   controller: controller.phoneNumberCon,
                      //   hintText: LocaleKeys.phoneNumber.tr,
                      //   validator: (text) => FormValidator.phoneNumber(text),
                      //   inputFormatters: [FormValidator.maskInputPhoneNumber()],
                      //   textInputAction: TextInputAction.next,
                      //   keyboardType: TextInputType.phone,
                      //   prefixIcon: Icon(Icons.email, color: AppColor.primary),
                      // ),
                      UIConstants.spacing.height,
                      // Phone number
                      CustomTextField(
                        controller: controller.phoneNumberCon,
                        hintText: LocaleKeys.phoneNumber.tr,
                        validator: (text) => FormValidator.phoneNumber(text),
                        inputFormatters: [FormValidator.maskInputPhoneNumber()],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icon(Icons.phone, color: AppColor.primary),
                      ),

                      UIConstants.spacing.height,

                      Obx(
                        () => CustomTextField(
                          prefixIcon: Icon(Icons.lock, color: AppColor.primary),
                          controller: controller.passCon,
                          validator: (text) => FormValidator.empty(text),

                          hintText: LocaleKeys.password.tr,

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
                        ),
                      ),
                      UIConstants.spacing.height,

                      // Confirm password
                      Obx(
                        () => CustomTextField(
                          controller: controller.confirmCon,
                          hintText: LocaleKeys.confirmPassword.tr,
                          validator:
                              (text) => FormValidator.equalValues(
                                original: controller.passCon.text,
                                confirm: text,
                              ),
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(Icons.lock, color: AppColor.primary),
                          suffixIcon: InkWell(
                            onTap:
                                () =>
                                    controller.isPassVisibleConfirm.value =
                                        !controller.isPassVisibleConfirm.value,
                            child: Icon(
                              controller.isPassVisibleConfirm.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                10.height,

                Padding(
                  padding: UIConstants.spacing.padHorizontal,
                  child: PrimaryButton(text: 'Sign Up', onPressed: registerTab),
                ),
                UIConstants.spacing.height,

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Have an account?",
                        style: AppTextStyle.normalGreenRegular,
                        //style: TextStyle(color: AppColor.primary),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                          print("welcome Log In!");
                        },

                        child: Text(
                          "Log In",
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
                UIConstants.radius.height,
                Center(
                  child: Text(
                    "Or connect with?",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.normalGreenRegular,
                  ),
                ),
                UIConstants.spacing.height,
                SocialButtonCustomWidget(),
                UIConstants.spacing.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
