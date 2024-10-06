import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Modules/Home/Widget/product_cart_widget.dart';
import 'package:fashion/Modules/Home/controllers/data_contoller.dart';
import 'package:fashion/Modules/Home/controllers/home_controller.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sizer/sizer.dart';

class Wishlist extends StatefulWidget {
  Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final HomeController homeController = Get.put(HomeController());

  final DataContoller dataContoller = Get.find<DataContoller>();
  // Use the existing controller
  @override
  void initState() {
    super.initState();
    // Fetch favorite products when the screen initializes
    dataContoller
        .fetchFavoriteProducts(); // You need to implement this method in the DataController
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.whiteColor,
        foregroundColor: ColorConstants.whiteColor,
        shadowColor: ColorConstants.whiteColor,
        surfaceTintColor: ColorConstants.whiteColor,
        toolbarHeight: 10.h,
        leadingWidth: 15.w,
        title: const CustomText(
          text: StringConstants.wishlist,
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
      body: Column(
        children: [
          // Container(
          //   height: 7.2.h,
          //   padding: EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
          //   child: ListView.builder(
          //       itemCount: controller.wishlistCategory.length,
          //       scrollDirection: Axis.horizontal,
          //       itemBuilder: (context, index) {
          //         return Container(
          //           width: 28.w,
          //           padding: EdgeInsets.only(left: 4.w),
          //           child: Obx(() {
          //             return CustomButton(
          //               label: controller.wishlistCategory[index],
          //               labelColor: ColorConstants.blackColor,
          //               action: () {
          //                 controller.setSelectedCategory(index);
          //               },
          //               isSelected:
          //                   controller.selectedCategoryIndex.value == index,
          //               btnColor: ColorConstants.whiteColor,
          //               fontSize: 11,
          //               weight: FontWeight.w400,
          //             );
          //           }),
          //         );
          //       }),
          // ),
          Container(
            height: 4.5.h,
            padding: EdgeInsets.symmetric(vertical: 0.3.h),
            margin: EdgeInsets.only(
              left: 4.w,
              right: 4.w,
            ),
            child: Obx(() {
              if (dataContoller.isLoading.value) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Show loading indicator
              }
              return ListView.builder(
                itemCount: dataContoller.salesCategoryItems.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 40.w,
                    padding: EdgeInsets.only(left: 2.w),
                    child: CustomButton(
                      label: dataContoller.salesCategoryItems[index]['name'] ??
                          'Unknown', // Adjust key based on your API response
                      labelColor: ColorConstants.blackColor,
                      action: () {
                        // Handle category selection
                        homeController.setSelectedSalesCategory(index);
                      },
                      isSelected:
                          homeController.selectedsalesCategoryIndex.value ==
                              index,
                      btnColor: ColorConstants.whiteColor,
                      fontSize: 11,
                      weight: FontWeight.w400,
                    ),
                  );
                },
              );
            }),
          ),

          listproductItems(),
        ],
      ),
    );
  }

  Widget listproductItems() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 4.w, right: 4.w),
        child: Obx(
          () {
            if (dataContoller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.69,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                // itemCount: 8,
                itemCount: dataContoller.favoriteProducts.length,
                itemBuilder: (context, index) {
                  final productId = dataContoller.favoriteProducts[index];
                  final product = dataContoller.productsItems
                      .firstWhere((item) => item['_id'] == productId);
                  final categoryId = product['category_id']['_id'];
                  final isFavorite = true;
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.productDetailsScreen,
                          arguments: product);
                    },
                    child: ProductCartWidget(
                      id: product['_id'],
                      name: product['name'],
                      price: product['price'],
                      rating: product['rating'],
                      image: (product['image'] is List &&
                              (product['image'] as List).isNotEmpty)
                          ? product['image'][0]
                          : AssetConstant.pd3, // Fallback image
                      isFavorite: isFavorite,
                      onToggleFavorite: () async {
                        await ApiService.removeFromFavorite(
                            productId, categoryId);
                        dataContoller.favoriteProducts.remove(productId);
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
