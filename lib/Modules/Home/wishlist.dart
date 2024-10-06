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
                    child: Obx(() {
                      // Check if this index is the selected one
                      bool isSelected =
                          homeController.selectedsalesCategoryIndex.value ==
                              index;

                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            isSelected
                                ? ColorConstants.rich
                                : ColorConstants.whiteColor,
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide(
                                color: isSelected
                                    ? ColorConstants.rich
                                    : ColorConstants.lightGrayColor,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // Handle category selection
                          homeController.setSelectedSalesCategory(index);
                          String selectedSaleCategoryId =
                              dataContoller.salesCategoryItems[index]['_id'];
                          dataContoller.selectedCategoryId.value =
                              selectedSaleCategoryId; // Store selected category ID
                          dataContoller.fetchSalesCategoryProducts(
                              selectedSaleCategoryId); // Fetch products for the selected category
                        },
                        child: Center(
                          child: Text(
                            dataContoller.salesCategoryItems[index]['name'] ??
                                'Unknown',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: isSelected
                                  ? ColorConstants.whiteColor
                                  : ColorConstants.blackColor,
                            ),
                          ),
                        ),
                      );
                    }),
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
