import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_field.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/controllers/auth_controller.dart';
import 'package:fashion/Modules/Auth/controllers/validation.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final AuthController authController = Get.put(AuthController());

  final ValidationController validationController =
      Get.put(ValidationController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: 16.h,
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
                  text: StringConstants.signIn,
                  color: ColorConstants.blackColor,
                  fontSize: 18,
                  weight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.5.h),
              Padding(
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                ),
                child: const CustomText(
                  text: StringConstants.welcome,
                  color: ColorConstants.greyColor,
                  fontSize: 11,
                  weight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 6.h,
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
                    ),
                    Obx(
                      () => validationController.emailError.isNotEmpty
                          ? CustomText(
                              text: validationController.emailError.value,
                              color: Colors.red,
                              fontSize: 10,
                              weight: FontWeight.w400,
                            )
                          : Container(),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    const CustomText(
                      text: StringConstants.passwordlabel,
                      color: ColorConstants.blackColor,
                      fontSize: 11,
                      weight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: 0.2.h,
                    ),
                    Obx(
                      () => CustomField(
                        controller: passwordController,
                        obscureText: authController.isPasswordVisible.value,
                        obscuringCharacter: '*',
                        showPasswordIcon: true,
                        hintText: StringConstants.password,
                        fontSize: 11,
                        hintTextColor: ColorConstants.greyColor,
                        onIconPressed: authController.togglePasswordVisibility,
                      ),
                    ),
                    Obx(() => validationController.passwordError.isNotEmpty
                        ? CustomText(
                            text: validationController.passwordError.value,
                            color: Colors.red,
                            fontSize: 10,
                            weight: FontWeight.w400,
                          )
                        : Container()),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.forgotPassScreen);
                      },
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: CustomText(
                          text: StringConstants.forgotpass,
                          color: ColorConstants.rich,
                          fontSize: 12,
                          weight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    CustomButton(
                      label: StringConstants.signIn,
                      height: 6.h,
                      fontSize: 14,
                      weight: FontWeight.w500,
                      labelColor: ColorConstants.whiteColor,
                      btnColor: ColorConstants.rich,
                      isSelected: true,
                      action: () async {
                        validationController
                            .validateEmail(emailController.text);
                        validationController
                            .validatePassword(passwordController.text);

                        if (validationController.emailError.value.isEmpty &&
                            validationController.passwordError.value.isEmpty) {
                          final loginData = {
                            'email': emailController.text,
                            'password': passwordController.text,
                            'fcm_token': GetStorage().read('fcm_token') ??
                                'dummy_fcm_token',
                            'login_type': 'Email',
                          };

                          try {
                            await ApiService.loginUser(loginData);
                            Get.offNamed(
                                AppRoutes.navbarScreen); // Navigate on success
                          } catch (e) {
                            print('Login error: $e');
                            // Handle login errors
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 0.05.h,
                          width: 20.w,
                          decoration: const BoxDecoration(
                            color: ColorConstants.greyColor,
                          ),
                        ),
                        SizedBox(
                          width: 2.5.w,
                        ),
                        const CustomText(
                          text: StringConstants.diffsigninmethod2,
                          color: ColorConstants.greyColor,
                          fontSize: 10,
                          weight: FontWeight.w400,
                        ),
                        SizedBox(
                          width: 2.5.w,
                        ),
                        Container(
                          height: 0.05.h,
                          width: 20.w,
                          decoration: const BoxDecoration(
                            color: ColorConstants.greyColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 3.w),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorConstants.lightGrayColor, width: 1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(1),
                            icon: Image(
                              image: const AssetImage(
                                AssetConstant.appleLogo,
                              ),
                              width: 6.w,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3.w),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorConstants.lightGrayColor, width: 1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(1),
                            iconSize: 24,
                            icon: Image(
                              image: const AssetImage(
                                AssetConstant.googleLogo,
                              ),
                              width: 6.w,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3.w),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorConstants.lightGrayColor, width: 1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(1),
                            iconSize: 24,
                            icon: Image(
                              image: const AssetImage(
                                AssetConstant.faceBookLogo,
                              ),
                              width: 6.w,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(
                          text: StringConstants.account1,
                          color: ColorConstants.blackColor,
                          fontSize: 11,
                          weight: FontWeight.w400,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.signUpScreen);
                          },
                          child: const CustomText(
                            text: StringConstants.signUp,
                            color: ColorConstants.rich,
                            fontSize: 12,
                            weight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
