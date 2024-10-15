
import 'dart:developer';

import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_field.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/controllers/auth_controller.dart';
import 'package:fashion/Modules/Auth/controllers/validation.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
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
            top: 2.h,
            left: 4.w,
            right: 4.w,
            bottom: 2.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  child: CustomText(
                    text: StringConstants.newPass,
                    color: ColorConstants.blackColor,
                    fontSize: 18,
                    weight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 12.w,
                    right: 12.w,
                  ),
                  child: const CustomText(
                    text: StringConstants.forgotdisplaytext,
                    color: ColorConstants.greyColor,
                    fontSize: 11,
                    weight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 4.w,
                    right: 4.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: StringConstants.emaillabel,
                        color: ColorConstants.blackColor,
                        fontSize: 11,
                        weight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: 0.2.h,
                      ),
                      CustomField(
                        controller: emailController,
                        hintText: StringConstants.email,
                        fontSize: 11,
                        hintTextColor: ColorConstants.greyColor,
                        keyboardType: TextInputType.emailAddress,
                        // onChanged: (value) => validationController.validateEmail(value),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      const CustomText(
                        text: StringConstants.oldPass,
                        color: ColorConstants.blackColor,
                        fontSize: 11,
                        weight: FontWeight.w400,
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
                          fontSize: 11,
                          hintTextColor: ColorConstants.greyColor,
                          onIconPressed:
                              authController.togglePasswordVisibility,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      const CustomText(
                        text: StringConstants.newPass,
                        color: ColorConstants.blackColor,
                        fontSize: 11,
                        weight: FontWeight.w400,
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
                          fontSize: 11,
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
                        height: 6.h,
                        fontSize: 14,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
