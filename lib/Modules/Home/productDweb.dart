import 'dart:convert';
import 'dart:developer';

import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
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

class ProductDWeb extends StatefulWidget {
  ProductDWeb({super.key});

  @override
  State<ProductDWeb> createState() => _ProductDWebState();
}

class _ProductDWebState extends State<ProductDWeb> {
  final homeController = Get.find<HomeController>();

  final dataContoller = Get.find<DataContoller>();

  final ValidationController validationController =
      Get.put(ValidationController());

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
    // Fetching product data from Get.arguments
    final productData = Get.arguments ?? {};
    final String productId = productData['_id'] ?? 'ID';
    final String productName = productData['name'] ?? 'Name';
    final String productDescription =
        productData['description'] ?? 'Description';
    final double productPrice = (productData['price'] != null)
        ? double.parse(productData['price'].toString())
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

    //data for header
    final String userName = dataStorage?['data']['name'] ?? 'Demo';
    final String userImage = dataStorage?['data']['image'] ?? '';
    final imageUrl = userImage.isNotEmpty
        ? '${ApiConstants.imageBaseUrl}$userImage'
        : AssetConstant.pd1;

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
                left: Responsive.isDesktop(context) ? 4.w : 4.w,
                right: Responsive.isDesktop(context) ? 4.w : 4.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FittedBox(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.homewebScreen);
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

          //Product Detail
          Wrap(
            spacing: 20,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            runSpacing: 20,
            textDirection: TextDirection.ltr,
            verticalDirection: VerticalDirection.down,
            // direction: Axis.vertical,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: Responsive.isDesktop(context) ? 2.h : 2.h,
                  left: Responsive.isDesktop(context)
                      ? 4.w
                      : Responsive.isTablet(context)
                          ? 3.w
                          : 2.w,
                  right: Responsive.isDesktop(context)
                      ? 4.w
                      : Responsive.isTablet(context)
                          ? 3.w
                          : 2.w,
                  bottom: Responsive.isDesktop(context) ? 2.h : 2.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: Responsive.isDesktop(context)
                          ? 35.w
                          : Responsive.isTablet(context)
                              ? 25.w
                              : 20.w,
                      height: Responsive.isDesktop(context)
                          ? 50.h
                          : Responsive.isTablet(context)
                              ? 50.h
                              : 50.h,
                      color: ColorConstants.background,
                      child: imageList.isNotEmpty
                          ? Image.network(
                              imageList[0], // Fetch the first image
                              fit: BoxFit.fill,
                            )
                          : Image.asset(
                              AssetConstant
                                  .pd1, // Default image in case the list is empty
                              fit: BoxFit.fill,
                            ),
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? 4.w
                          : Responsive.isTablet(context)
                              ? 2.w
                              : 2.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: CustomText(
                            text: productName,
                            fontSize: Responsive.isDesktop(context)
                                ? 4
                                : Responsive.isTablet(context)
                                    ? 7
                                    : 10,
                            weight: FontWeight.w500,
                            color: ColorConstants.blackColor,
                          ),
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 2.h : 2.h,
                        ),
                        FittedBox(
                          child: CustomText(
                            text: '\$$productPrice',
                            fontSize: Responsive.isDesktop(context)
                                ? 4
                                : Responsive.isTablet(context)
                                    ? 7
                                    : 10,

                            // fontSize: Responsive.isDesktop(context) ? 4 : 13.5,
                            weight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 2.h : 2.h,
                        ),
                        FittedBox(
                          child: Row(
                            children: [
                              CustomText(
                                text: productDescription,
                                color: ColorConstants.greyColor,
                                fontSize: Responsive.isDesktop(context)
                                    ? 3
                                    : Responsive.isTablet(context)
                                        ? 7
                                        : 10,

                                // fontSize:
                                //     Responsive.isDesktop(context) ? 3 : 12,
                                weight: FontWeight.w500,
                              ),
                              SizedBox(
                                width:
                                    Responsive.isDesktop(context) ? 0.5.w : 1.w,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: CustomText(
                                  text: StringConstants.readMore,
                                  color: ColorConstants.rich,
                                  fontSize: Responsive.isDesktop(context)
                                      ? 3
                                      : Responsive.isTablet(context)
                                          ? 7
                                          : 10,

                                  // fontSize:
                                  //     Responsive.isDesktop(context) ? 3 : 12,
                                  weight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 2.h : 2.h,
                        ),
                        SizedBox(
                          height: 2.h,
                          width: 26.w,
                          child: Divider(
                            height: 1.5,
                            color: ColorConstants.lightGrayColor,
                            thickness: 0.1.h,
                          ),
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 2.h : 2.h,
                        ),
                        FittedBox(
                          child: CustomText(
                            text: StringConstants.colorText,
                            color: ColorConstants.blackColor,
                            weight: FontWeight.w500,
                            fontSize: Responsive.isDesktop(context)
                                ? 3
                                : Responsive.isTablet(context)
                                    ? 7
                                    : 10,
                          ),
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 1.h : 0.7.h,
                        ),
                        // Color Options with proper constraints
                        Wrap(
                          spacing: 10,
                          children: colorChart.map((color) {
                            return Obx(() => GestureDetector(
                                  onTap: () => selectColor(color),
                                  child: Container(
                                    width: Responsive.isDesktop(context)
                                        ? 45
                                        : Responsive.isTablet(context)
                                            ? 35
                                            : 20,
                                    height: Responsive.isDesktop(context)
                                        ? 45
                                        : Responsive.isTablet(context)
                                            ? 35
                                            : 20,
                                    decoration: BoxDecoration(
                                      color: HexColor(
                                          color), // Convert hex to color
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: homeController
                                                    .selectedProductColor
                                                    .value ==
                                                color
                                            ? Colors.black
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                ));
                          }).toList(),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Obx(() => CustomText(
                              text: validationController.colorError.value,
                              color: ColorConstants.errorColor,
                              fontSize: Responsive.isDesktop(context)
                                  ? 3
                                  : Responsive.isTablet(context)
                                      ? 7
                                      : 10,
                              weight: FontWeight.w400,
                            )),
                        SizedBox(
                          height: 0.1.h,
                        ),
                        FittedBox(
                          child: CustomText(
                            text: StringConstants.sizeText,
                            color: ColorConstants.blackColor,
                            weight: FontWeight.w500,
                            fontSize: Responsive.isDesktop(context)
                                ? 3
                                : Responsive.isTablet(context)
                                    ? 7
                                    : 10,
                          ),
                        ),

                        SizedBox(
                          height: Responsive.isDesktop(context) ? 1.h : 0.7.h,
                        ),
                        // Display size options
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: sizeChart.map((size) {
                            return Obx(() => GestureDetector(
                                  onTap: () => selectSize(size),
                                  child: Container(
                                    width: Responsive.isDesktop(context)
                                        ? 45
                                        : Responsive.isTablet(context)
                                            ? 35
                                            : 20,
                                    height: Responsive.isDesktop(context)
                                        ? 45
                                        : Responsive.isTablet(context)
                                            ? 35
                                            : 20,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: homeController
                                                  .selectedProductSize.value ==
                                              size
                                          ? Colors.blueAccent
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: homeController
                                                    .selectedProductSize
                                                    .value ==
                                                size
                                            ? Colors.black
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        color: homeController
                                                    .selectedProductSize
                                                    .value ==
                                                size
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: Responsive.isDesktop(context)
                                            ? 10
                                            : Responsive.isTablet(context)
                                                ? 7
                                                : 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ));
                          }).toList(),
                        ),
                        SizedBox(
                          height: 0.1.h,
                        ),
                        Obx(() => CustomText(
                              text: validationController.sizeError.value,
                              color: ColorConstants.errorColor,
                              fontSize: Responsive.isDesktop(context)
                                  ? 3
                                  : Responsive.isTablet(context)
                                      ? 7
                                      : 10,
                              weight: FontWeight.w400,
                            )),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 6.h : 2.h,
                        ),
                        SizedBox(
                          width: Responsive.isDesktop(context) ? 45.h : 50.w,
                          height: Responsive.isDesktop(context) ? 6.h : 5.8.h,
                          child: CustomButton(
                            label: StringConstants.addCart,
                            btnColor: ColorConstants.rich,
                            fontSize: Responsive.isDesktop(context)
                                ? 4
                                : Responsive.isTablet(context)
                                    ? 7
                                    : 10,
                            height: Responsive.isDesktop(context) ? 6.h : 6.h,
                            weight: FontWeight.w400,
                            isSelected: true,
                            action: () {
                              // homeController.selectedIndex.value = 1;
                              var size =
                                  homeController.selectedProductSize.value;
                              var color = homeController.selectedProductColor
                                  .value; // Assume you have a similar method for color
                              validationController.validateSize(size);
                              validationController.validateColor(color);
                              if (validationController
                                      .sizeError.value.isNotEmpty ||
                                  validationController
                                      .colorError.value.isNotEmpty) {
                                // Optionally show a message or toast here
                                log("Validation errors: ${validationController.sizeError.value}, ${validationController.colorError.value}");
                                return; // Stop execution if there are errors
                              }
                              homeController.addProductToCart(productId, size);
                              Get.snackbar(
                                  'Product added to cart', 'Done Added');
                              // Get.toNamed(AppRoutes.navbarScreen);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Function to select a color
  void selectColor(String color) {
    homeController.selectedProductColor.value = color;
  }

  // Function to select a size
  void selectSize(String size) {
    homeController.selectedProductSize.value = size;
  }
}

// Helper function to convert Hex string to Flutter Color
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('0X', '').replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor; // Add opacity if not provided
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
