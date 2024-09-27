
import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_field.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/controllers/validation.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sizer/sizer.dart';

class UserDetail extends StatelessWidget {
  UserDetail({super.key});

  final ValidationController validationController =
      Get.put(ValidationController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = Get.arguments;
    nameController.text = args['name'] ?? '';
    final email = args['email'];
    final password = args['password'];
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
          decoration: BoxDecoration(
            border: Border.all(color: ColorConstants.lightGrayColor, width: 1),
            shape: BoxShape.circle,
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
            left: 4.w,
            right: 4.w,
            bottom: 2.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 3.h,
                ),
                const Align(
                  child: CustomText(
                    text: StringConstants.profiletext,
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
                    left: 8.w,
                    right: 8.w,
                  ),
                  child: const CustomText(
                    text: StringConstants.userdisplaytext,
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
                      Align(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => SizedBox(
                                height: 150,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text('Gallery'),
                                      onTap: () {
                                        validationController
                                            .pickImageFromGallery();
                                        // Get.back();
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text('Camera'),
                                      onTap: () {
                                        validationController
                                            .pickImageFromCamera();
                                        // Get.back();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Obx(
                                () =>
                                    // child:
                                    CircleAvatar(
                                  radius: 60,
                                  backgroundImage: validationController
                                              .profileImage.value !=
                                          null
                                      ? FileImage(validationController
                                          .profileImage.value!)
                                      : const AssetImage(AssetConstant.image)
                                          as ImageProvider,
                                  backgroundColor: ColorConstants.background,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      height: 4.h,
                                      width: 8.w,
                                      decoration: BoxDecoration(
                                        color: ColorConstants.rich,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                          width: 2,
                                          color: ColorConstants.whiteColor,
                                        ),
                                      ),
                                      child: const Icon(
                                        AntDesign.edit_outline,
                                        color: ColorConstants.whiteColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Obx(() => validationController.imageError.value.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CustomText(
                                text: validationController.imageError.value,
                                color: ColorConstants.errorColor,
                                fontSize: 10,
                                weight: FontWeight.w400,
                              ),
                            )
                          : const SizedBox.shrink()),
                      SizedBox(
                        height: 3.h,
                      ),
                      const CustomText(
                        text: StringConstants.namelabel,
                        color: ColorConstants.blackColor,
                        fontSize: 11,
                        weight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: 0.2.h,
                      ),
                      CustomField(
                        controller: nameController,
                        fontSize: 13,
                        keyboardType: TextInputType.name,
                        readonly: false,
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      const CustomText(
                        text: StringConstants.phonelabel,
                        color: ColorConstants.blackColor,
                        fontSize: 11,
                        weight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: 0.2.h,
                      ),
                      Obx(
                        () => CustomField(
                          hintText: StringConstants
                              .phone, // Placeholder for phone input
                          fontSize: 11,
                          isPhoneNumber: true,
                          hintTextColor: ColorConstants.greyColor,
                          selectedCountryCode:
                              validationController.selectedCountrycode.value,
                          countryCodes: validationController.countryCode,
                          onCountryCodeChanged: (newValue) {
                            validationController.setSelectedCountryCode(
                                newValue); // Update country code
                          },
                          onChanged: (newValue) {
                            validationController.setPhoneNumber(
                                newValue); // Update phone number
                          },
                          controller: phoneController,
                        ),
                      ),
                      Obx(() => validationController.phoneError.value.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CustomText(
                                text: validationController.phoneError.value,
                                color: ColorConstants.errorColor,
                                fontSize: 10,
                                weight: FontWeight.w400,
                              ),
                            )
                          : const SizedBox.shrink()),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      const CustomText(
                        text: StringConstants.genderlabel,
                        color: ColorConstants.blackColor,
                        fontSize: 11,
                        weight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: 0.2.h,
                      ),
                      Obx(
                        () => CustomField(
                          hintText: StringConstants.gender,
                          fontSize: 11,
                          isDropdown: true,
                          hintTextColor: ColorConstants.greyColor,
                          genderdropdown:
                              validationController.genderDropdownValues,
                          onChanged: (newValue) {
                            validationController
                                .setSelectedDropdownItem(newValue);
                          },
                          controller: TextEditingController(
                            text:
                                validationController.selectedDropdownItem.value,
                          ),
                        ),
                      ),
                      Obx(
                        () => validationController.genderError.value.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: CustomText(
                                  text: validationController.genderError.value,
                                  color: ColorConstants.errorColor,
                                  fontSize: 10,
                                  weight: FontWeight.w400,
                                ),
                              )
                            : SizedBox(height: 1.h),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      CustomButton(
                        label: StringConstants.userBtntext,
                        btnColor: ColorConstants.rich,
                        labelColor: ColorConstants.whiteColor,
                        isSelected: true,
                        height: 6.h,
                        fontSize: 14,
                        weight: FontWeight.w500,
                        action: () {
                          validationController
                              .validateImage(); // Validate image
                          validationController
                              .validateName(nameController.text);
                          validationController
                              .validatePhone(phoneController.text);
                          validationController.validateGender(
                              validationController.selectedDropdownItem.value);
                          if (validationController.nameError.value.isEmpty &&
                              validationController.imageError.value.isEmpty &&
                              validationController.phoneError.value.isEmpty &&
                              validationController.genderError.value.isEmpty) {
                            Get.toNamed(
                              AppRoutes.addressScreen,
                              arguments: {
                                'name': nameController.text,
                                'email': email,
                                'password': password,
                                'image': validationController
                                    .profileImage.value?.path,
                                'number':
                                    '${validationController.selectedCountrycode.value}-${validationController.phoneNumber.value}',
                                'gender': validationController
                                    .selectedDropdownItem.value,
                              },
                            );
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
