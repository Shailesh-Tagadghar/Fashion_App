import 'dart:convert';
import 'package:dotted_line/dotted_line.dart';
import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/controllers/auth_controller.dart';
import 'package:fashion/Modules/Auth/controllers/validation.dart';
import 'package:fashion/Modules/Home/Widget/cart_web_widget.dart';
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
    final DataContoller dataContoller = Get.find<DataContoller>();
    final String userName = dataStorage?['data']['name'] ?? 'Demo';
    final String userImage = dataStorage?['data']['image'] ?? '';
    final imageUrl = userImage.isNotEmpty
        ? '${ApiConstants.imageBaseUrl}$userImage'
        : AssetConstant.pd1;

    nameController.text = validationController.userName.value;
    dataContoller.fetchCarts();
    dataContoller.fetchCheckout();
    // log('disssssssss ${dataContoller.discount.value}');
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

          //cart details
          Padding(
            padding: EdgeInsets.only(
              top: Responsive.isDesktop(context) ? 4.h : 2.h,
              left: Responsive.isDesktop(context) ? 4.w : 4.w,
              right: Responsive.isDesktop(context) ? 4.w : 4.w,
            ),
            child: Row(
              children: [
                // cart container
                Container(
                  height: Responsive.isDesktop(context)
                      ? 60.h
                      : Responsive.isTablet(context)
                          ? 40.h
                          : 70.h,
                  width: Responsive.isDesktop(context)
                      ? 55.w
                      : Responsive.isTablet(context)
                          ? 55.w
                          : 55.w,
                  color: ColorConstants.foreground,
                  child: Obx(
                    () {
                      if (dataContoller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (dataContoller.cartsItems.isEmpty) {
                        return const Center(
                          child: CustomText(
                            text: 'No cart data available',
                            fontSize: 14,
                            weight: FontWeight.w500,
                          ),
                        );
                      }
                      final products =
                          dataContoller.cartsItems['product'] ?? [];
                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final item = products[index];
                          final product = item['product_id'] ?? {};
                          final size = item['size'] ?? 'N/A';
                          final productName =
                              product['name'] ?? 'Unknown Product';
                          final productPrice = product['price'] ?? 0;
                          final productImage =
                              product['image']?.isNotEmpty == true
                                  ? product['image'][0]
                                  : AssetConstant.pd1; // Fallback image
                          final cartIdP = item['_id'].toString();
                          // final quantity = product['qty'];
                          final quantityValue =
                              item['qty'] ?? 1; // Default to 1 if null
                          final quantity =
                              RxInt(quantityValue); // Wrap it in RxInt
                          return CartWebWidget(
                            image: productImage,
                            title: productName,
                            size: size,
                            price: productPrice.toString(),
                            quantity: quantity,
                            cartIdP: cartIdP,
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: Responsive.isDesktop(context)
                      ? 2.w
                      : Responsive.isTablet(context)
                          ? 2.w
                          : 2.w,
                ),
                //checkout
                Container(
                  height: Responsive.isDesktop(context)
                      ? 60.h
                      : Responsive.isTablet(context)
                          ? 40.h
                          : 70.h,
                  width: Responsive.isDesktop(context)
                      ? 30.w
                      : Responsive.isTablet(context)
                          ? 25.w
                          : 20.w,
                  color: ColorConstants.foreground,
                  child: Column(
                    children: [
                      Builder(
                        builder: (BuildContext context) {
                          dataContoller.isAppliedDone.value = false;
                          return Padding(
                            padding: EdgeInsets.only(
                              top: Responsive.isDesktop(context) ? 4.h : 2.h,
                              left: Responsive.isDesktop(context) ? 4.w : 4.w,
                              right: Responsive.isDesktop(context) ? 4.w : 4.w,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: Responsive.isDesktop(context)
                                              ? 0.1.w
                                              : 1.w,
                                          right: Responsive.isDesktop(context)
                                              ? 0.1.w
                                              : 1.w,
                                        ),
                                        child: Obx(
                                          () => TextField(
                                            controller: TextEditingController(
                                                text: dataContoller
                                                    .selectedCoupon.value),
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              suffixIcon: Padding(
                                                padding: EdgeInsets.only(
                                                  right: Responsive.isDesktop(
                                                          context)
                                                      ? 0.4.w
                                                      : 1.5.w,
                                                  top: 0.5.h,
                                                  bottom: 0.5.h,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    dataContoller.selectedCoupon
                                                            .value.isNotEmpty
                                                        ? dataContoller
                                                                    .isAppliedDone
                                                                    .value ==
                                                                true
                                                            ? () {}
                                                            : dataContoller
                                                                .verifyCoupon()
                                                        : Get.toNamed(AppRoutes
                                                            .couponScreen);
                                                  },
                                                  child: Obx(() => CustomButton(
                                                        label: StringConstants
                                                            .apply,
                                                        fontSize: Responsive
                                                                .isDesktop(
                                                                    context)
                                                            ? 4
                                                            : Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 4
                                                                : 4,
                                                        isSelected: true,
                                                        labelColor:
                                                            ColorConstants
                                                                .whiteColor,
                                                        btnColor: dataContoller
                                                                    .isAppliedDone
                                                                    .value ==
                                                                true
                                                            ? ColorConstants
                                                                .greyColor
                                                            : ColorConstants
                                                                .rich,
                                                        height: Responsive
                                                                .isDesktop(
                                                                    context)
                                                            ? 4.h
                                                            : Responsive
                                                                    .isTablet(
                                                                        context)
                                                                ? 4.h
                                                                : 4.h,
                                                        width: Responsive
                                                                .isDesktop(
                                                                    context)
                                                            ? 8.w
                                                            : 8.w,
                                                        weight: FontWeight.w400,
                                                      )),
                                                ),
                                              ),
                                              hintText: StringConstants.promo,
                                              hintStyle: TextStyle(
                                                color: ColorConstants.greyColor,
                                                fontSize: Responsive.isDesktop(
                                                        context)
                                                    ? 14
                                                    : Responsive.isTablet(
                                                            context)
                                                        ? 10
                                                        : 7,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                borderSide: const BorderSide(
                                                  color:
                                                      ColorConstants.background,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                borderSide: const BorderSide(
                                                  color:
                                                      ColorConstants.background,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                borderSide: const BorderSide(
                                                  color:
                                                      ColorConstants.background,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FittedBox(
                                            child: CustomText(
                                              text: StringConstants.subtotal,
                                              color: ColorConstants.greyColor,
                                              fontSize: Responsive.isDesktop(
                                                      context)
                                                  ? 4
                                                  : Responsive.isTablet(context)
                                                      ? 3
                                                      : 3,
                                              weight: FontWeight.w400,
                                            ),
                                          ),
                                          Obx(
                                            () => FittedBox(
                                              child: CustomText(
                                                text:
                                                    '\$${dataContoller.subtotal.value.toStringAsFixed(2)}',
                                                color:
                                                    ColorConstants.blackColor,
                                                fontSize: Responsive.isDesktop(
                                                        context)
                                                    ? 4
                                                    : Responsive.isTablet(
                                                            context)
                                                        ? 3
                                                        : 3,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FittedBox(
                                            child: CustomText(
                                              text: StringConstants.delivery,
                                              color: ColorConstants.greyColor,
                                              fontSize: Responsive.isDesktop(
                                                      context)
                                                  ? 4
                                                  : Responsive.isTablet(context)
                                                      ? 3
                                                      : 3,
                                              weight: FontWeight.w400,
                                            ),
                                          ),
                                          Obx(
                                            () => FittedBox(
                                              child: CustomText(
                                                text:
                                                    '\$${dataContoller.deliveryFee.value.toStringAsFixed(2)}',
                                                color:
                                                    ColorConstants.blackColor,
                                                fontSize: Responsive.isDesktop(
                                                        context)
                                                    ? 4
                                                    : Responsive.isTablet(
                                                            context)
                                                        ? 3
                                                        : 3,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FittedBox(
                                            child: CustomText(
                                              text: StringConstants.discount,
                                              color: ColorConstants.greyColor,
                                              fontSize: Responsive.isDesktop(
                                                      context)
                                                  ? 4
                                                  : Responsive.isTablet(context)
                                                      ? 3
                                                      : 3,
                                              weight: FontWeight.w400,
                                            ),
                                          ),
                                          Obx(
                                            () => FittedBox(
                                              child: CustomText(
                                                text:
                                                    '-\$${dataContoller.discount.value > 0 ? dataContoller.discount.value.toStringAsFixed(2) : '0.00'}',
                                                color:
                                                    ColorConstants.blackColor,
                                                fontSize: Responsive.isDesktop(
                                                        context)
                                                    ? 4
                                                    : Responsive.isTablet(
                                                            context)
                                                        ? 3
                                                        : 3,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      DottedLine(
                                        dashColor:
                                            ColorConstants.lightGrayColor,
                                        lineThickness: 1,
                                        dashGapColor: ColorConstants.whiteColor,
                                        dashGapLength: 2.w,
                                        dashLength: 2.w,
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FittedBox(
                                            child: CustomText(
                                              text: StringConstants.total,
                                              color: ColorConstants.greyColor,
                                              fontSize: Responsive.isDesktop(
                                                      context)
                                                  ? 4
                                                  : Responsive.isTablet(context)
                                                      ? 3
                                                      : 3,
                                              weight: FontWeight.w400,
                                            ),
                                          ),
                                          Obx(
                                            () => FittedBox(
                                              child: CustomText(
                                                text:
                                                    '\$${(dataContoller.total.value).toStringAsFixed(2)}',
                                                color:
                                                    ColorConstants.blackColor,
                                                fontSize: Responsive.isDesktop(
                                                        context)
                                                    ? 4
                                                    : Responsive.isTablet(
                                                            context)
                                                        ? 3
                                                        : 3,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      CustomButton(
                                        label: StringConstants.checkoutbtn,
                                        fontSize: Responsive.isDesktop(context)
                                            ? 4
                                            : Responsive.isTablet(context)
                                                ? 4
                                                : 4,
                                        btnColor: ColorConstants.rich,
                                        isSelected: true,
                                        height: Responsive.isDesktop(context)
                                            ? 6.h
                                            : Responsive.isTablet(context)
                                                ? 4.h
                                                : 4.h,
                                        weight: FontWeight.w400,
                                        action: () async {
                                          await dataContoller.checkout();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
