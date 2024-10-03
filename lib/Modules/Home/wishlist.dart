import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Home/Widget/fav_product.dart';
import 'package:fashion/Modules/Home/controllers/data_contoller.dart';
import 'package:fashion/Modules/Home/controllers/home_controller.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sizer/sizer.dart';

class Wishlist extends StatelessWidget {
  Wishlist({super.key});

  final HomeController controller = Get.put(HomeController());
  final DataContoller dataContoller = Get.put(DataContoller());

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
            height: 7.2.h,
            padding: EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
            child: ListView.builder(
                itemCount: controller.wishlistCategory.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 28.w,
                    padding: EdgeInsets.only(left: 4.w),
                    child: Obx(() {
                      return CustomButton(
                        label: controller.wishlistCategory[index],
                        labelColor: ColorConstants.blackColor,
                        action: () {
                          controller.setSelectedCategory(index);
                        },
                        isSelected:
                            controller.selectedCategoryIndex.value == index,
                        btnColor: ColorConstants.whiteColor,
                        fontSize: 11,
                        weight: FontWeight.w400,
                      );
                    }),
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
            }
            if (dataContoller.favoriteProducts.isEmpty) {
              return const Center(
                child: Text('No favorite products yet'),
              );
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.77,
              ),
              // itemCount: 8,
              itemCount: dataContoller.favoriteProducts.length,
              itemBuilder: (context, index) {
                if (dataContoller.favoriteProducts[index] == null) {
                  return const Center(
                      child: Text('Product data is unavailable'));
                }
                var product = dataContoller.favoriteProducts[index];

                return FavProduct(
                  product: product, // Pass the product data to ProductWidget
                  isFavorite: dataContoller.favoriteProducts.contains(product),
                  onFavoriteToggle: () {
                    dataContoller.toggleFavoriteProduct(product);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
