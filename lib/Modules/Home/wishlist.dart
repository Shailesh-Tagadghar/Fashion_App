import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Modules/Home/Widget/product_cart_widget.dart';
import 'package:fashion/Modules/Home/controllers/data_contoller.dart';
import 'package:fashion/Modules/Home/controllers/home_controller.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/responsive.dart';
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
        title: FittedBox(
          child: CustomText(
            text: StringConstants.wishlist,
            weight: FontWeight.w500,
            fontSize: Responsive.isDesktop(context) ? 4 : 13,
          ),
        ),
        centerTitle: true,
        leading: FittedBox(
          child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
              left: Responsive.isDesktop(context) ? 0.2.w : 4.w,
            ),
            padding: EdgeInsets.all(
              Responsive.isDesktop(context) ? 0.2.w : 0.6.w,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                  color: ColorConstants.lightGrayColor,
                  width: Responsive.isDesktop(context) ? 0 : 1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              iconSize: Responsive.isDesktop(context) ? 20 : 24,
              icon: const Icon(
                Bootstrap.arrow_left,
                color: ColorConstants.blackColor,
              ),
              onPressed: () {
                if (Responsive.isDesktop(context)) {
                  Get.toNamed(AppRoutes.homewebScreen);
                } else {
                  Get.toNamed(AppRoutes.navbarScreen);
                }
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: Responsive.isDesktop(context) ? 5.h : 4.5.h,
            padding: EdgeInsets.symmetric(
                vertical: Responsive.isDesktop(context) ? 0.1.h : 0.3.h),
            margin: EdgeInsets.only(
              left: 4.w,
              right: 4.w,
              top: Responsive.isDesktop(context) ? 4.h : 0,
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
                    width: Responsive.isDesktop(context)
                        ? 20.w
                        : Responsive.isTablet(context)
                            ? 24.w
                            : 40.w,
                    height: Responsive.isDesktop(context) ? 5.h : 4.5.h,
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
                      fontSize: Responsive.isDesktop(context)
                          ? 4
                          : Responsive.isTablet(context)
                              ? 7
                              : 10,
                      weight: FontWeight.w400,
                    ),
                  );
                },
              );
            }),
          ),
          SizedBox(
            height: Responsive.isDesktop(context) ? 4.h : 0,
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isDesktop(context)
                      ? 4
                      : Responsive.isTablet(context)
                          ? 3
                          : 2,
                  childAspectRatio: Responsive.isDesktop(context)
                      ? 0.4
                      : 0.69, // Adjusts the size of the items
                  crossAxisSpacing: Responsive.isDesktop(context)
                      ? 4
                      : 4.0, // Spacing between columns
                  mainAxisSpacing: Responsive.isDesktop(context) ? 4 : 2.0,
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
                      onToggleFavorite: (isNowFavorite) async {
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
