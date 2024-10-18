import 'dart:convert';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/controllers/auth_controller.dart';
import 'package:fashion/Modules/Auth/controllers/validation.dart';
import 'package:fashion/Modules/Home/controllers/data_contoller.dart';
import 'package:fashion/Modules/Home/controllers/home_controller.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/responsive.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

class Cartweb extends StatefulWidget {
  const Cartweb({super.key});

  @override
  State<Cartweb> createState() => _CartwebState();
}

class _CartwebState extends State<Cartweb> {
  final ValidationController validationController =
      Get.put(ValidationController());

  final AuthController authController = Get.put(AuthController());
  final DataContoller dataContoller = Get.put(DataContoller());
  final HomeController homeController = Get.put(HomeController());

  final TextEditingController nameController = TextEditingController();
  Map<String, dynamic>? dataStorage;

  @override
  void initState() {
    super.initState();
    dataContoller.onInit();

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
      // log('Data after Login / Register / Restart -- : $dataStorage');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userName = dataStorage?['data']['name'] ?? 'Demo';
    final String userImage = dataStorage?['data']['image'] ?? '';
    final imageUrl = userImage.isNotEmpty
        ? '${ApiConstants.imageBaseUrl}$userImage'
        : AssetConstant.pd1;

    nameController.text = validationController.userName.value;
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: Column(
        children: [
          //header
          Container(
            decoration: const BoxDecoration(color: ColorConstants.rich),
            height: Responsive.isDesktop(context) ? 8.h : 4.h,
            child: Padding(
              padding: EdgeInsets.only(
                // top: Responsive.isDesktop(context) ? 2.h : 2.h,
                left: Responsive.isDesktop(context) ? 4.w : 4.w,
                right: Responsive.isDesktop(context) ? 4.w : 4.w,
                // bottom: Responsive.isDesktop(context) ? 2.h : 2.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FittedBox(
                        child: GestureDetector(
                          onTap: () {
                            if (Responsive.isDesktop(context)) {
                              Get.toNamed(AppRoutes.homewebScreen);
                            } else {
                              Get.toNamed(AppRoutes.navbarScreen);
                            }
                          },
                          child: CustomText(
                            text: StringConstants.home,
                            color: ColorConstants.whiteColor,
                            fontSize: Responsive.isDesktop(context) ? 4 : 11,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isDesktop(context) ? 2.5.w : 2.w,
                      ),
                      FittedBox(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.cartwebScreen);
                          },
                          child: CustomText(
                            text: StringConstants.cart,
                            color: ColorConstants.whiteColor,
                            fontSize: Responsive.isDesktop(context) ? 4 : 11,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isDesktop(context) ? 2.5.w : 2.w,
                      ),
                      FittedBox(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.wishlistScreen);
                          },
                          child: CustomText(
                            text: StringConstants.wishlist,
                            color: ColorConstants.whiteColor,
                            fontSize: Responsive.isDesktop(context) ? 4 : 11,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isDesktop(context) ? 2.5.w : 2.w,
                      ),
                      FittedBox(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.searchScreen);
                          },
                          child: CustomText(
                            text: StringConstants.search,
                            color: ColorConstants.whiteColor,
                            fontSize: Responsive.isDesktop(context) ? 4 : 11,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: SizedBox(
                          height: Responsive.isDesktop(context) ? 5.h : 5.h,
                          width: Responsive.isDesktop(context) ? 3.w : 3.w,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isDesktop(context) ? 1.w : 1.w,
                      ),
                      FittedBox(
                        child: CustomText(
                          text: 'Hello, $userName',
                          color: ColorConstants.whiteColor,
                          fontSize: Responsive.isDesktop(context) ? 4 : 11,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: Responsive.isDesktop(context) ? 2.h : 2.h,
          ),
        ],
      ),
    );
  }
}
