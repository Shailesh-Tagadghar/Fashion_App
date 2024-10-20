import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_field.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/controllers/auth_controller.dart';
import 'package:fashion/Modules/Auth/controllers/validation.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/responsive.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final AuthController authController = Get.put(AuthController());

  final ValidationController validationController =
      Get.put(ValidationController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: Responsive.isDesktop(context) ? 6.h : 10.h,
          left: Responsive.isDesktop(context) ? 4.w : 4.w,
          right: Responsive.isDesktop(context) ? 4.w : 4.w,
          bottom: Responsive.isDesktop(context) ? 4.h : 2.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                child: FittedBox(
                  child: CustomText(
                    text: StringConstants.createaccount,
                    color: ColorConstants.blackColor,
                    fontSize: Responsive.isDesktop(context)
                        ? 8
                        : Responsive.isDesktop(context)
                            ? 10
                            : 20,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 1.5.h),
              Align(
                child: SizedBox(
                  width: Responsive.isDesktop(context) ? 30.w : 100.w,
                  child: FittedBox(
                    child: CustomText(
                      text: StringConstants.smalldisplay,
                      color: ColorConstants.greyColor,
                      fontSize: Responsive.isDesktop(context)
                          ? 4
                          : Responsive.isDesktop(context)
                              ? 7
                              : 12,
                      weight: FontWeight.w300,
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
                          text: StringConstants.namelabel,
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
                        height: Responsive.isDesktop(context) ? 0.8.h : 0.2.h,
                      ),
                      CustomField(
                        controller: nameController,
                        hintText: StringConstants.name,
                        fontSize: Responsive.isDesktop(context)
                            ? 3
                            : Responsive.isDesktop(context)
                                ? 7
                                : 11,

                        hintTextColor: ColorConstants.greyColor,
                        keyboardType: TextInputType.name,
                        // onChanged: (value) => validationController.validateName(value),
                      ),
                      Obx(
                        () => validationController.nameError.value.isNotEmpty
                            ? CustomText(
                                text: validationController.nameError.value,
                                color: ColorConstants.errorColor,
                                fontSize: Responsive.isDesktop(context)
                                    ? 3
                                    : Responsive.isDesktop(context)
                                        ? 7
                                        : 10,
                                weight: FontWeight.w400,
                              )
                            : const SizedBox.shrink(),
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context) ? 2.h : 2.h,
                      ),
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
                        // onChanged: (value) => validationController.validateEmail(value),
                      ),
                      Obx(
                        () => validationController.emailError.value.isNotEmpty
                            ? CustomText(
                                text: validationController.emailError.value,
                                color: ColorConstants.errorColor,
                                fontSize: Responsive.isDesktop(context)
                                    ? 3
                                    : Responsive.isDesktop(context)
                                        ? 7
                                        : 10,
                                weight: FontWeight.w400,
                              )
                            : const SizedBox.shrink(),
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context) ? 2.h : 2.h,
                      ),
                      FittedBox(
                        child: CustomText(
                          text: StringConstants.passwordlabel,
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
                        height: Responsive.isDesktop(context) ? 2.h : 2.h,
                      ),
                      Obx(
                        () => CustomField(
                          controller: passwordController,
                          obscureText: authController.isPasswordVisible.value,
                          obscuringCharacter: '*',
                          fontSize: Responsive.isDesktop(context)
                              ? 3
                              : Responsive.isDesktop(context)
                                  ? 7
                                  : 11,
                          showPasswordIcon: true,
                          hintText: StringConstants.password,
                          hintTextColor: ColorConstants.greyColor,
                          // onChanged: (value) =>
                          //     validationController.validatePassword(value),
                          onIconPressed:
                              authController.togglePasswordVisibility,
                        ),
                      ),
                      Obx(
                        () => validationController
                                .passwordError.value.isNotEmpty
                            ? CustomText(
                                text: validationController.passwordError.value,
                                color: ColorConstants.errorColor,
                                fontSize: Responsive.isDesktop(context)
                                    ? 3
                                    : Responsive.isDesktop(context)
                                        ? 7
                                        : 10,
                                weight: FontWeight.w400,
                              )
                            : const SizedBox.shrink(),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        children: [
                          Obx(
                            () => SizedBox(
                              height: Responsive.isDesktop(context) ? 1.h : 2.h,
                              width: Responsive.isDesktop(context) ? 2.w : 5.w,
                              child: Checkbox.adaptive(
                                value: validationController.agreeToTerms.value,
                                onChanged: (value) =>
                                    validationController.checkBox(),
                                activeColor: ColorConstants.primary,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Responsive.isDesktop(context) ? 0.w : 1.w,
                          ),
                          FittedBox(
                            child: CustomText(
                              text: StringConstants.agree,
                              color: ColorConstants.blackColor,
                              fontSize: Responsive.isDesktop(context)
                                  ? 4
                                  : Responsive.isDesktop(context)
                                      ? 7
                                      : 11,
                              weight: FontWeight.w400,
                            ),
                          ),
                          FittedBox(
                            child: CustomText(
                              text: StringConstants.tandc,
                              color: ColorConstants.rich,
                              weight: FontWeight.w500,
                              fontSize: Responsive.isDesktop(context)
                                  ? 4
                                  : Responsive.isDesktop(context)
                                      ? 7
                                      : 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => validationController
                                .checkboxError.value.isNotEmpty
                            ? CustomText(
                                text: validationController.checkboxError.value,
                                color: ColorConstants.errorColor,
                                fontSize: Responsive.isDesktop(context)
                                    ? 3
                                    : Responsive.isDesktop(context)
                                        ? 7
                                        : 10,
                                weight: FontWeight.w400,
                              )
                            : const SizedBox.shrink(),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      CustomButton(
                        label: StringConstants.signUp,
                        btnColor: ColorConstants.rich,
                        labelColor: ColorConstants.whiteColor,
                        isSelected: true,
                        height: Responsive.isDesktop(context)
                            ? 6.h
                            : Responsive.isTablet(context)
                                ? 6.h
                                : 6.h,
                        fontSize: Responsive.isDesktop(context) ? 4 : 14,
                        weight: FontWeight.w500,
                        action: () {
                          validationController
                              .validateName(nameController.text);
                          validationController
                              .validateEmail(emailController.text);
                          validationController
                              .validatePassword(passwordController.text);
                          validationController.validateCheckbox();

                          if (validationController.nameError.value.isEmpty &&
                              validationController.emailError.value.isEmpty &&
                              validationController
                                  .passwordError.value.isEmpty &&
                              validationController
                                  .checkboxError.value.isEmpty) {
                            validationController
                                .setUserName(nameController.text);
                            Get.toNamed(AppRoutes.userDetailScreen, arguments: {
                              'name': nameController.text,
                              'email': emailController.text,
                              'password': passwordController.text,
                            });
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
                              padding: const EdgeInsets.all(1),
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
                              padding: const EdgeInsets.all(1),
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
                              padding: const EdgeInsets.all(1),
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
                              text: StringConstants.account2,
                              color: ColorConstants.blackColor,
                              fontSize: Responsive.isDesktop(context)
                                  ? 3
                                  : Responsive.isDesktop(context)
                                      ? 7
                                      : 10,
                              weight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: Responsive.isDesktop(context) ? 0.5.w : 1.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.signInScreen);
                            },
                            child: FittedBox(
                              child: CustomText(
                                text: StringConstants.signIn,
                                color: ColorConstants.rich,
                                fontSize: Responsive.isDesktop(context)
                                    ? 3
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
