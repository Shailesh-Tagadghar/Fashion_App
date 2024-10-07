import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/controllers/validation.dart';
import 'package:fashion/Modules/Home/controllers/home_controller.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class Productdetails extends StatelessWidget {
  Productdetails({super.key});

  final HomeController homeController = Get.find();
  final ValidationController validationController =
      Get.put(ValidationController());

  @override
  Widget build(BuildContext context) {
    // Fetching product data from Get.arguments
    final productData = Get.arguments ?? {};
    final String productId = productData['_id'] ?? 'ID';
    final String productName = productData['name'] ?? 'Name';
    final String productDescription =
        productData['description'] ?? 'Description';
    final String productGender = productData['gender'] ?? 'Male';
    final double productPrice = (productData['price'] != null)
        ? double.parse(productData['price'].toString())
        : 0.0;
    final double productRating = (productData['rating'] != null)
        ? double.parse(productData['rating'].toString())
        : 0.0;

    // Handling image list with null safety

    final List<String> imageList = productData['image'] != null
        ? List<String>.from(productData['image'])
            .map((image) => ApiConstants.imageBaseUrl + image)
            .toList()
        : [
            AssetConstant.pd3,
            AssetConstant.pd2,
            AssetConstant.pd1,
          ];

    final List<String> sizeChart = productData['sizechart'] != null
        ? List<String>.from(productData['sizechart'])
        : [];
    final List<String> colorChart = productData['colorchart'] != null
        ? List<String>.from(productData['colorchart'])
        : [];

    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: 46.5.h,
                    child: PageView.builder(
                      controller: homeController.pageController,
                      itemCount: imageList.length,
                      onPageChanged: (value) {
                        homeController.changeActivePage(value);
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          imageList[index],
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5.8.w),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorConstants.whiteColor,
                            ),
                            child: IconButton(
                              padding: const EdgeInsets.all(1),
                              iconSize: 24,
                              icon: const Icon(
                                Icons.arrow_back,
                                color: ColorConstants.blackColor,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                          const CustomText(
                            text: StringConstants.product,
                            fontSize: 14,
                            weight: FontWeight.w500,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5.8.w),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorConstants.whiteColor,
                            ),
                            child: IconButton(
                              iconSize: 26,
                              icon: const Icon(
                                Icons.favorite_border_rounded,
                                color: ColorConstants.blackColor,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 2.5.h,
                          top: 26.h,
                        ),
                        height: 6.8.h,
                        width: 31.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: ColorConstants.whiteColor,
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageList.length,
                          itemBuilder: (context, index) {
                            bool isSelected =
                                homeController.activePage.value == index;

                            return InkWell(
                              onTap: () {
                                // Update the active page and jump to the selected page in PageView
                                homeController.changeActivePage(index);
                                homeController.pageController.jumpToPage(index);
                              },
                              child: Transform.scale(
                                scale: isSelected ? 1.2 : 1.0,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: 0.8.h,
                                    bottom: 0.8.h,
                                    left: 1.5.w,
                                    right: 1.4.w,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      imageList[index].toString(),
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 6.w,
                  left: 6.w,
                  top: 4.h,
                  bottom: 4.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //API
                        CustomText(
                          text: '$productGender${StringConstants.styles}',
                          fontSize: 12,
                          weight: FontWeight.w400,
                          color: ColorConstants.greyColor,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber[500],
                              size: 25,
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            //API
                            CustomText(
                              text: productRating.toString(),
                              fontSize: 13,
                              weight: FontWeight.w400,
                              color: ColorConstants.greyColor,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    CustomText(
                      text: productName,
                      fontSize: 14,
                      weight: FontWeight.w500,
                      color: ColorConstants.blackColor,
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    const CustomText(
                      text: StringConstants.product,
                      fontSize: 13,
                      weight: FontWeight.w500,
                      color: ColorConstants.blackColor,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: productDescription,
                          color: ColorConstants.greyColor,
                          fontSize: 12,
                          weight: FontWeight.w500,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const CustomText(
                            text: StringConstants.readMore,
                            color: ColorConstants.rich,
                            fontSize: 12,
                            weight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    Divider(
                      thickness: 0.02.h,
                      color: ColorConstants.greyColor,
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    const CustomText(
                      text: StringConstants.sizeText,
                      color: ColorConstants.blackColor,
                      weight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    SizedBox(
                      height: 0.7.h,
                    ),
                    SizedBox(
                      height: 4.h,
                      child: ListView.builder(
                        itemCount: sizeChart.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          String size = sizeChart[index];
                          return Obx(
                            () {
                              bool isSelected =
                                  homeController.selectedProductSize.value ==
                                      size;
                              return InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  homeController.selectSize(size);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: isSelected
                                        ? ColorConstants.primary
                                        : ColorConstants.whiteColor,
                                    border: Border.all(
                                      color: isSelected
                                          ? ColorConstants.primary
                                          : ColorConstants.lightGrayColor,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(right: 4.w),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12.0,
                                      right: 12.0,
                                    ),
                                    child: CustomText(
                                      text: size,
                                      fontSize: 11,
                                      weight: FontWeight.w600,
                                      color: isSelected
                                          ? ColorConstants.whiteColor
                                          : ColorConstants.blackColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 0.1.h,
                    ),
                    Obx(() => CustomText(
                          text: validationController.sizeError.value,
                          color: ColorConstants.errorColor,
                          fontSize: 10,
                          weight: FontWeight.w400,
                        )),
                    SizedBox(
                      height: 1.5.h,
                    ),

                    //API
                    Row(
                      children: [
                        const CustomText(
                          text: StringConstants.colorText,
                          color: ColorConstants.blackColor,
                          weight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        const CustomText(
                          text: StringConstants.color,
                          color: ColorConstants.greyColor,
                          weight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Obx(() => CustomText(
                              text: validationController.colorError.value,
                              color: ColorConstants.errorColor,
                              fontSize: 10,
                              weight: FontWeight.w400,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    SizedBox(
                      height: 3.5.h,
                      child: ListView.builder(
                        itemCount: colorChart.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          String colorHex = colorChart[index];
                          return InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              homeController.selectColor(colorHex);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 2.w),
                              height: 3.5.h,
                              width: 6.5.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(int.parse(colorHex)),
                                shape: BoxShape.circle,
                              ),
                              child: Obx(
                                () => Container(
                                  height: 12,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: homeController
                                                .selectedProductColor.value ==
                                            colorHex
                                        ? ColorConstants.whiteColor
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 10.h,
        width: 100.w,
        decoration: const BoxDecoration(
          color: ColorConstants.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.lightGrayColor,
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: StringConstants.priceText,
                  fontSize: 12.5,
                  color: ColorConstants.greyColor,
                  weight: FontWeight.w400,
                ),
                CustomText(
                  text: '\$$productPrice',
                  fontSize: 13.5,
                  weight: FontWeight.w500,
                ),
              ],
            ),
            SizedBox(
              width: 5.w,
            ),
            SizedBox(
              width: 50.w,
              height: 5.8.h,
              child: CustomButton(
                label: StringConstants.addCart,
                btnColor: ColorConstants.rich,
                height: 6.h,
                weight: FontWeight.w400,
                isSelected: true,
                action: () {
                  homeController.selectedIndex.value = 1;
                  var size = homeController.selectedProductSize.value;
                  var color = homeController.selectedProductColor
                      .value; // Assume you have a similar method for color
                  validationController.validateSize(size);
                  validationController.validateColor(color);
                  if (validationController.sizeError.value.isNotEmpty ||
                      validationController.colorError.value.isNotEmpty) {
                    // Optionally show a message or toast here
                    print(
                        "Validation errors: ${validationController.sizeError.value}, ${validationController.colorError.value}");
                    return; // Stop execution if there are errors
                  }
                  homeController.addProductToCart(productId, size);
                  Get.toNamed(AppRoutes.navbarScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
