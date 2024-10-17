import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/controllers/auth_controller.dart';
import 'package:fashion/Modules/Auth/controllers/validation.dart';
import 'package:fashion/Modules/Home/Widget/banner_widget.dart';
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

class Homeweb extends StatefulWidget {
  const Homeweb({super.key});

  @override
  State<Homeweb> createState() => _HomewebState();
}

class _HomewebState extends State<Homeweb> {
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
      log('Data after Login / Register / Restart -- : $dataStorage');
      log('Carousal itesms : ${dataContoller.carousalItems.length}');
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
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                          child: CustomText(
                            text: StringConstants.home,
                            color: ColorConstants.whiteColor,
                            fontSize: Responsive.isDesktop(context) ? 4 : 11,
                            weight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: Responsive.isDesktop(context) ? 2.5.w : 2.w,
                        ),
                        FittedBox(
                          child: CustomText(
                            text: StringConstants.cart,
                            color: ColorConstants.whiteColor,
                            fontSize: Responsive.isDesktop(context) ? 4 : 11,
                            weight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: Responsive.isDesktop(context) ? 2.5.w : 2.w,
                        ),
                        FittedBox(
                          child: CustomText(
                            text: StringConstants.wishlist,
                            color: ColorConstants.whiteColor,
                            fontSize: Responsive.isDesktop(context) ? 4 : 11,
                            weight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: Responsive.isDesktop(context) ? 2.5.w : 2.w,
                        ),
                        FittedBox(
                          child: CustomText(
                            text: StringConstants.search,
                            color: ColorConstants.whiteColor,
                            fontSize: Responsive.isDesktop(context) ? 4 : 11,
                            weight: FontWeight.w500,
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
            Obx(
              () => dataContoller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: Responsive.isDesktop(context) ? 70.h : 18.h,
                      width: 100.w,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                          },
                        ),
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dataContoller.carousalItems.length,
                          onPageChanged: (index) {
                            homeController.currentPage.value = index;
                          },
                          itemBuilder: (context, index) {
                            final item = dataContoller.carousalItems[index];
                            return BannerWidget(
                              // image: AssetConstant.banner2tp,
                              image: item['image'] ?? AssetConstant.banner1,
                              title: item['title'] ?? 'No Title',
                              subtitle: item['subtitle'] ?? 'No Subtitle',
                            );
                          },
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: Responsive.isDesktop(context) ? 2.h : 2.h,
            ),
            Container(
              decoration: const BoxDecoration(
                color: ColorConstants.foreground,
              ),
              height: Responsive.isDesktop(context) ? 8.h : 8.h,
              width: 100.w,
              child: Padding(
                padding: EdgeInsets.only(
                  top: Responsive.isDesktop(context) ? 2.h : 2.h,
                  left: Responsive.isDesktop(context) ? 4.w : 4.w,
                  right: Responsive.isDesktop(context) ? 4.w : 4.w,
                  bottom: Responsive.isDesktop(context) ? 2.h : 2.h,
                ),
                // padding: EdgeInsets.symmetric(
                //   vertical: Responsive.isDesktop(context)
                //       ? 2.h
                //       : 1.5.h, // Adjusted padding for mobile
                //   horizontal: Responsive.isDesktop(context) ? 4.w : 3.w,
                // ),
                child: Row(
                  children: [
                    FittedBox(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: StringConstants.category,
                        color: ColorConstants.blackColor,
                        fontSize: Responsive.isDesktop(context) ? 4 : 11,
                        weight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context) ? 4.w : 2.w,
                    ),
                    Obx(() {
                      if (dataContoller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        // Dropdown for web
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorConstants.rich, // Add color
                              borderRadius: BorderRadius.circular(
                                  8), // Add border radius for a rounded effect
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      0.1), // Light shadow for depth
                                  blurRadius: 6,
                                  offset: const Offset(0, 4), // Shadow position
                                ),
                              ],
                            ),
                            width: Responsive.isDesktop(context) ? 200 : 150,
                            height: Responsive.isDesktop(context) ? 60 : 60,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                padding: EdgeInsets.all(
                                  Responsive.isDesktop(context) ? 10 : 6,
                                ),
                                value: dataContoller
                                        .selectedCategoryId.value.isNotEmpty
                                    ? dataContoller.selectedCategoryId.value
                                    : null,
                                hint: Text(
                                  'Select Category',
                                  style: TextStyle(
                                    fontSize: Responsive.isDesktop(context)
                                        ? 16
                                        : 14, // Responsive font size
                                    color: Colors.white, // Text color
                                  ),
                                ),
                                items: dataContoller.categoryItems
                                    .map<DropdownMenuItem<String>>((item) {
                                  return DropdownMenuItem<String>(
                                    value: item['_id'],
                                    child: Text(
                                      item['name'] ?? 'No name',
                                      style: TextStyle(
                                        fontSize: Responsive.isDesktop(context)
                                            ? 16
                                            : 14, // Responsive text size
                                        color: Colors
                                            .black, // Dropdown item text color
                                      ),
                                    ),
                                  );
                                }).toList(),
                                dropdownColor: Colors.white,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white, // Dropdown icon color
                                  size: Responsive.isDesktop(context)
                                      ? 30
                                      : 24, // Adjust icon size
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != null && newValue.isNotEmpty) {
                                    dataContoller.selectedCategoryId.value =
                                        newValue;
                                    Get.toNamed(AppRoutes.categoryScreen,
                                        arguments: newValue);
                                    log('Selected Category ID: $newValue');
                                  }
                                },
                                style: TextStyle(
                                  color: Colors
                                      .white, // Text color for the selected item
                                  fontSize: Responsive.isDesktop(context)
                                      ? 16
                                      : 14, // Font size
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Responsive.isDesktop(context) ? 2.h : 2.h,
            ),
          ],
        ),
      ),
    );
  }
}
