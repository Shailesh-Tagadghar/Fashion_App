import 'dart:developer';
import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_field.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/controllers/auth_controller.dart';
import 'package:fashion/Modules/Auth/controllers/validation.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/responsive.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sizer/sizer.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final AuthController authController = Get.put(AuthController());
  final ValidationController validationController =
      Get.put(ValidationController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldpasswordController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.whiteColor,
        toolbarHeight: 10.h,
        leadingWidth: 15.w,
        leading: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
            left: 4.w,
          ),
          padding: EdgeInsets.all(
            0.6.w,
          ),
          child: IconButton(
            iconSize: 24,
            icon: const Icon(
              Bootstrap.arrow_left,
              color: ColorConstants.blackColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
      ),
      body: Scaffold(
        backgroundColor: ColorConstants.whiteColor,
        body: Padding(
          padding: EdgeInsets.only(
            top: Responsive.isDesktop(context) ? 2.h : 2.h,
            left: Responsive.isDesktop(context) ? 4.w : 4.w,
            right: Responsive.isDesktop(context) ? 4.w : 4.w,
            bottom: Responsive.isDesktop(context) ? 4.h : 2.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  child: FittedBox(
                    child: CustomText(
                      text: StringConstants.newPass,
                      color: ColorConstants.blackColor,
                      fontSize: Responsive.isDesktop(context)
                          ? 7
                          : Responsive.isDesktop(context)
                              ? 7
                              : 18,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Align(
                  child: SizedBox(
                    width: Responsive.isDesktop(context) ? 30.w : 100.w,
                    child: FittedBox(
                      child: CustomText(
                        text: StringConstants.forgotdisplaytext,
                        color: ColorConstants.greyColor,
                        fontSize: Responsive.isDesktop(context)
                            ? 6
                            : Responsive.isDesktop(context)
                                ? 7
                                : 11,
                        weight: FontWeight.w400,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Align(
                  child: SizedBox(
                    width: Responsive.isDesktop(context) ? 30.w : 100.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: CustomText(
                            text: StringConstants.emaillabel,
                            color: ColorConstants.blackColor,
                            fontSize: Responsive.isDesktop(context)
                                ? 3
                                : Responsive.isDesktop(context)
                                    ? 7
                                    : 11,
                            weight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 0.2.h,
                        ),
                        CustomField(
                          controller: emailController,
                          hintText: StringConstants.email,
                          fontSize: Responsive.isDesktop(context)
                              ? 3
                              : Responsive.isDesktop(context)
                                  ? 7
                                  : 11,
                          hintTextColor: ColorConstants.greyColor,
                          keyboardType: TextInputType.emailAddress,
                          // onChanged: (value) => validationController.validateEmail(value),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        FittedBox(
                          child: CustomText(
                            text: StringConstants.oldPass,
                            color: ColorConstants.blackColor,
                            fontSize: Responsive.isDesktop(context)
                                ? 3
                                : Responsive.isDesktop(context)
                                    ? 7
                                    : 11,
                            weight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 0.2.h,
                        ),
                        Obx(
                          () => CustomField(
                            controller: oldpasswordController,
                            obscureText: authController.isPasswordVisible.value,
                            obscuringCharacter: '*',
                            showPasswordIcon: true,
                            hintText: StringConstants.password,
                            fontSize: Responsive.isDesktop(context)
                                ? 3
                                : Responsive.isDesktop(context)
                                    ? 7
                                    : 11,
                            hintTextColor: ColorConstants.greyColor,
                            onIconPressed:
                                authController.togglePasswordVisibility,
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        FittedBox(
                          child: CustomText(
                            text: StringConstants.newPass,
                            color: ColorConstants.blackColor,
                            fontSize: Responsive.isDesktop(context)
                                ? 3
                                : Responsive.isDesktop(context)
                                    ? 7
                                    : 11,
                            weight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 0.2.h,
                        ),
                        Obx(
                          () => CustomField(
                            controller: newpasswordController,
                            obscureText:
                                authController.isCnfPasswordVisible.value,
                            obscuringCharacter: '*',
                            showPasswordIcon: true,
                            hintText: StringConstants.password,
                            fontSize: Responsive.isDesktop(context)
                                ? 4
                                : Responsive.isDesktop(context)
                                    ? 7
                                    : 11,
                            hintTextColor: ColorConstants.greyColor,
                            onIconPressed:
                                authController.toggleCnfPasswordVisibility,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        CustomButton(
                          label: StringConstants.btntext,
                          btnColor: ColorConstants.rich,
                          labelColor: ColorConstants.whiteColor,
                          isSelected: true,
                          height: Responsive.isDesktop(context)
                              ? 6.h
                              : Responsive.isTablet(context)
                                  ? 6.h
                                  : 6.h,
                          fontSize: Responsive.isDesktop(context)
                              ? 4
                              : Responsive.isDesktop(context)
                                  ? 7
                                  : 14,
                          weight: FontWeight.w500,
                          action: () async {
                            // Retrieve passwords from controllers
                            String email = emailController.text;
                            String oldpassword = oldpasswordController.text;
                            String newpassword = newpasswordController.text;

                            // Check if fields are not empty
                            if (email.isEmpty ||
                                oldpassword.isEmpty ||
                                newpassword.isEmpty) {
                              Get.snackbar('Error', 'All fields are required');
                              return;
                            }

                            // log both passwords to the console
                            log('Old password: $oldpassword');
                            log('New password: $newpassword');

                            // Retrieve the bearer token from GetStorage
                            final storage = GetStorage();
                            String? token = storage.read('fcm_token');

                            if (token == null) {
                              Get.snackbar('Error',
                                  'User not logged in || please enter valid token');
                              return;
                            }

                            // Prepare data to send to the API
                            Map<String, dynamic> data = {
                              'email': email,
                              'oldpassword': oldpassword,
                              'newpassword': newpassword,
                            };

                            try {
                              // Call the API to change the password
                              await ApiService.changePassword(data, token);
                              emailController.clear();
                              oldpasswordController.clear();
                              newpasswordController.clear();
                              Get.snackbar(
                                  'Success', 'Password changed successfully');
                            } catch (e) {
                              log('Failed to change password : $e');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
