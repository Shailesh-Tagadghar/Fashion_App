import 'dart:developer';
import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_field.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/controllers/auth_controller.dart';
import 'package:fashion/Modules/Auth/controllers/validation.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/responsive.dart';
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
          top: Responsive.isDesktop(context) ? 8.h : 16.h,
          left: Responsive.isDesktop(context) ? 4.w : 4.w,
          right: Responsive.isDesktop(context) ? 4.w : 4.w,
          bottom: Responsive.isDesktop(context) ? 4.h : 2.h,
        ),
        child: SingleChildScrollView(
          child: Align(
            child: SizedBox(
              width: Responsive.isDesktop(context) ? 40.w : 100.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    child: FittedBox(
                      child: CustomText(
                        text: StringConstants.signIn,
                        color: ColorConstants.blackColor,
                        fontSize: Responsive.isDesktop(context)
                            ? 7
                            : Responsive.isDesktop(context)
                                ? 10
                                : 18,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Center(
                    child: FittedBox(
                      child: CustomText(
                        text: StringConstants.welcome,
                        color: ColorConstants.greyColor,
                        fontSize: Responsive.isDesktop(context)
                            ? 4
                            : Responsive.isDesktop(context)
                                ? 7
                                : 11,
                        weight: FontWeight.w400,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Responsive.isDesktop(context) ? 3.h : 6.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: CustomText(
                          text: StringConstants.emaillabel,
                          color: ColorConstants.blackColor,
                          fontSize: Responsive.isDesktop(context)
                              ? 4
                              : Responsive.isDesktop(context)
                                  ? 7
                                  : 11,
                          weight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context) ? 0.8.h : 0.2.h,
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
                      ),
                      Obx(
                        () => validationController.emailError.isNotEmpty
                            ? CustomText(
                                text: validationController.emailError.value,
                                color: Colors.red,
                                fontSize: Responsive.isDesktop(context)
                                    ? 3
                                    : Responsive.isDesktop(context)
                                        ? 7
                                        : 10,
                                weight: FontWeight.w400,
                              )
                            : Container(),
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context) ? 2.h : 2.h,
                      ),
                      FittedBox(
                        child: CustomText(
                          text: StringConstants.passwordlabel,
                          color: ColorConstants.blackColor,
                          fontSize: Responsive.isDesktop(context)
                              ? 4
                              : Responsive.isDesktop(context)
                                  ? 7
                                  : 11,
                          weight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context) ? 0.8.h : 0.2.h,
                      ),
                      Obx(
                        () => CustomField(
                          controller: passwordController,
                          obscureText: authController.isPasswordVisible.value,
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
                              authController.togglePasswordVisibility,
                        ),
                      ),
                      Obx(() => validationController.passwordError.isNotEmpty
                          ? CustomText(
                              text: validationController.passwordError.value,
                              color: Colors.red,
                              fontSize: Responsive.isDesktop(context)
                                  ? 3
                                  : Responsive.isDesktop(context)
                                      ? 7
                                      : 10,
                              weight: FontWeight.w400,
                            )
                          : Container()),
                      SizedBox(
                        height: Responsive.isDesktop(context) ? 2.h : 2.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.forgotPassScreen);
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: FittedBox(
                            child: CustomText(
                              text: StringConstants.forgotpass,
                              color: ColorConstants.rich,
                              fontSize: Responsive.isDesktop(context)
                                  ? 4
                                  : Responsive.isDesktop(context)
                                      ? 7
                                      : 12,
                              weight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context) ? 4.h : 4.h,
                      ),
                      CustomButton(
                        label: StringConstants.signIn,
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
                        labelColor: ColorConstants.whiteColor,
                        btnColor: ColorConstants.rich,
                        isSelected: true,
                        action: () async {
                          validationController
                              .validateEmail(emailController.text);
                          validationController
                              .validatePassword(passwordController.text);

                          if (validationController.emailError.value.isEmpty &&
                              validationController
                                  .passwordError.value.isEmpty) {
                            final loginData = {
                              'email': emailController.text,
                              'password': passwordController.text,
                              'fcm_token': GetStorage().read('fcm_token') ??
                                  'dummy_fcm_token',
                              'login_type': 'Email',
                            };

                            try {
                              await ApiService.loginUser(loginData);
                              // ignore: use_build_context_synchronously
                              if (Responsive.isDesktop(context)) {
                                Get.offNamed(AppRoutes.homewebScreen);
                              } else {
                                Get.offNamed(AppRoutes.navbarScreen);
                              }
                              // Navigate on success
                            } catch (e) {
                              log('Login error: $e');
                              // Handle login errors
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context) ? 4.h : 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height:
                                Responsive.isDesktop(context) ? 0.05.h : 0.05.h,
                            width: Responsive.isDesktop(context) ? 3.w : 20.w,
                            decoration: const BoxDecoration(
                              color: ColorConstants.greyColor,
                            ),
                          ),
                          SizedBox(
                            width: Responsive.isDesktop(context) ? 1.w : 2.5.w,
                          ),
                          FittedBox(
                            child: CustomText(
                              text: StringConstants.diffsigninmethod2,
                              color: ColorConstants.greyColor,
                              fontSize: Responsive.isDesktop(context)
                                  ? 3
                                  : Responsive.isDesktop(context)
                                      ? 7
                                      : 10,
                              weight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: Responsive.isDesktop(context) ? 1.w : 2.5.w,
                          ),
                          Container(
                            height:
                                Responsive.isDesktop(context) ? 0.05.h : 0.05.h,
                            width: Responsive.isDesktop(context) ? 3.w : 20.w,
                            decoration: const BoxDecoration(
                              color: ColorConstants.greyColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context) ? 4.h : 4.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: Responsive.isDesktop(context)
                                    ? 0.5.w
                                    : 3.w),
                            padding: EdgeInsets.all(
                                Responsive.isDesktop(context) ? 5 : 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorConstants.lightGrayColor,
                                  width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.all(
                                  Responsive.isDesktop(context) ? 5 : 1),
                              iconSize: 24,
                              icon: Image(
                                image: const AssetImage(
                                  AssetConstant.appleLogo,
                                ),
                                width:
                                    Responsive.isDesktop(context) ? 2.w : 6.w,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: Responsive.isDesktop(context)
                                    ? 0.5.w
                                    : 3.w),
                            padding: EdgeInsets.all(
                                Responsive.isDesktop(context) ? 5 : 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorConstants.lightGrayColor,
                                  width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.all(
                                  Responsive.isDesktop(context) ? 5 : 1),
                              iconSize: 24,
                              icon: Image(
                                image: const AssetImage(
                                  AssetConstant.googleLogo,
                                ),
                                width:
                                    Responsive.isDesktop(context) ? 2.w : 6.w,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: Responsive.isDesktop(context)
                                    ? 0.5.w
                                    : 3.w),
                            padding: EdgeInsets.all(
                                Responsive.isDesktop(context) ? 5 : 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorConstants.lightGrayColor,
                                  width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.all(
                                  Responsive.isDesktop(context) ? 5 : 1),
                              iconSize: 24,
                              icon: Image(
                                image: const AssetImage(
                                  AssetConstant.faceBookLogo,
                                ),
                                width:
                                    Responsive.isDesktop(context) ? 2.w : 6.w,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context) ? 3.h : 3.5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: CustomText(
                              text: StringConstants.account1,
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
                            width: Responsive.isDesktop(context) ? 0.5.w : 1.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.signUpScreen);
                            },
                            child: FittedBox(
                              child: CustomText(
                                text: StringConstants.signUp,
                                color: ColorConstants.rich,
                                fontSize: Responsive.isDesktop(context)
                                    ? 4
                                    : Responsive.isDesktop(context)
                                        ? 7
                                        : 12,
                                weight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
