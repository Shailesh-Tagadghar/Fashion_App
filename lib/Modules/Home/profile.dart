import 'dart:convert';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/controllers/auth_controller.dart';
import 'package:fashion/Modules/Auth/controllers/validation.dart';
import 'package:fashion/Modules/Home/Widget/profile_widget.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sizer/sizer.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ValidationController validationController =
      Get.put(ValidationController());

  final AuthController authController = Get.put(AuthController());

  final TextEditingController nameController = TextEditingController();
  Map<String, dynamic>? dataStorage;

  @override
  void initState() {
    super.initState();
    final userData = GetStorage().read('user_data');
    if (userData != null) {
      if (userData is String) {
        // If data is stored as a JSON string, decode it
        dataStorage = jsonDecode(userData);
      } else if (userData is Map<String, dynamic>) {
        // If data is already a Map
        dataStorage = userData;
      }
      // Update state to ensure the UI reflects the loaded data
      setState(() {});
    }

    print('Data after Login / Register / Restart -- : $dataStorage');
  }

  @override
  Widget build(BuildContext context) {
    final String userName = dataStorage?['data']['name'] ?? 'User Name';
    final String userImage = dataStorage?['data']['image'] ?? '';
    // final imageUrl = '${ApiConstants.imageBaseUrl}$userImage';
    // Construct image URL if available, or use default asset if empty
    final imageUrl = userImage.isNotEmpty
        ? '${ApiConstants.imageBaseUrl}$userImage'
        : AssetConstant.pd1;

    nameController.text = validationController.userName.value;

    return Scaffold(
        backgroundColor: ColorConstants.whiteColor,
        appBar: AppBar(
          backgroundColor: ColorConstants.whiteColor,
          toolbarHeight: 10.h,
          leadingWidth: 15.w,
          title: const CustomText(
            text: StringConstants.profile,
            weight: FontWeight.w500,
            fontSize: 13,
          ),
          centerTitle: true,
          leading: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
              left: 4.w,
            ),
            padding: EdgeInsets.all(
              0.6.w,
            ),
            decoration: BoxDecoration(
              border:
                  Border.all(color: ColorConstants.lightGrayColor, width: 1),
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
        body: Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            bottom: 2.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  validationController.pickImageFromGallery();
                                  // Get.back();
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Camera'),
                                onTap: () {
                                  validationController.pickImageFromCamera();
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
                        // Obx(
                        //   () =>
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: userImage.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : const AssetImage(AssetConstant.defaultImage)
                                  as ImageProvider,
                          backgroundColor: ColorConstants.background,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 4.h,
                              width: 8.w,
                              decoration: BoxDecoration(
                                color: ColorConstants.rich,
                                borderRadius: BorderRadius.circular(100),
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
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                CustomText(
                  text: userName,
                  color: ColorConstants.blackColor,
                  fontSize: 15,
                  weight: FontWeight.w500,
                ),
                SizedBox(
                  height: 1.h,
                ),

                //1st Row
                const ProfileWidget(
                  name: StringConstants.row1,
                  icon: Bootstrap.person,
                ),

                //2nd Row
                const ProfileWidget(
                  name: StringConstants.row2,
                  icon: Bootstrap.credit_card,
                ),

                //3rd Row
                const ProfileWidget(
                  name: StringConstants.row3,
                  icon: Icons.shopping_bag_outlined,
                ),

                //4th Row
                const ProfileWidget(
                  name: StringConstants.row4,
                  icon: Icons.settings_outlined,
                ),

                //5th Row
                const ProfileWidget(
                  name: StringConstants.row5,
                  icon: Icons.info_outline_rounded,
                ),

                //6th Row
                const ProfileWidget(
                  name: StringConstants.row6,
                  icon: Icons.lock_outline_rounded,
                ),

                //7th Row
                const ProfileWidget(
                  name: StringConstants.row7,
                  icon: Bootstrap.person_add,
                ),

                //8th Row -- LOgout
                ProfileWidget(
                  name: StringConstants.logout,
                  icon: Icons.logout_outlined,
                  onTap: () {
                    _showLogoutBottomSheet(context);
                  },
                ),

                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
        ));
  }

  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorConstants.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Column(
                  children: [
                    Divider(
                      color: ColorConstants.background,
                      thickness: 4,
                      endIndent: 30.w,
                      indent: 30.w,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    const CustomText(
                      text: StringConstants.logout1,
                      fontSize: 16,
                      weight: FontWeight.w500,
                      color: ColorConstants.blackColor,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Divider(
                      color: ColorConstants.background,
                      height: 1.h,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              const CustomText(
                text: StringConstants.confirm,
                color: ColorConstants.greyColor,
                fontSize: 14,
                textAlign: TextAlign.center,
                weight: FontWeight.w400,
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 6.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorConstants.rich,
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.whiteColor,
                      ),
                      child: const CustomText(
                        text: StringConstants.cancel,
                        color: ColorConstants.rich,
                        fontSize: 14,
                        weight: FontWeight.w500,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Container(
                    height: 6.h,
                    width: 40.w,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.rich,
                      ),
                      child: const CustomText(
                        text: StringConstants.confirmLogout,
                        color: ColorConstants.whiteColor,
                        fontSize: 14,
                        weight: FontWeight.w500,
                      ),
                      onPressed: () {
                        // Get.offAllNamed(AppRoutes.signInScreen);
                        _logout();
                        // authController.logoutUser();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4.h, // Add some space at the bottom
              ),
            ],
          ),
        );
      },
    );
  }

  void _logout() async {
    try {
      GetStorage().remove('user_data');
      GetStorage().remove('token');
      GetStorage().write('isLoggedIn', false); // Set login status to false
      // Navigate to the login screen
      Get.offAllNamed(AppRoutes.signInScreen);
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
