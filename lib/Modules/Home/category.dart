import 'dart:developer';

import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Modules/Home/Widget/product_cart_widget.dart';
import 'package:fashion/Modules/Home/controllers/data_contoller.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/responsive.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sizer/sizer.dart';

class Category extends StatelessWidget {
  Category({super.key});
  final DataContoller dataContoller = Get.find<DataContoller>();

  @override
  Widget build(BuildContext context) {
    final categoryId = Get.arguments as String;
    log('Category ID from arguments : $categoryId');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (categoryId.isNotEmpty) {
        dataContoller.fetchCategoryProducts(categoryId);
      }
    });

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
            text: StringConstants.categoryProduct,
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
                Get.back();
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: Responsive.isDesktop(context) ? 2.h : 0.h,
          left: Responsive.isDesktop(context) ? 4.w : 4.w,
          right: Responsive.isDesktop(context) ? 4.w : 4.w,
        ),
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
                  mainAxisSpacing: Responsive.isDesktop(context)
                      ? 4
                      : 2.0, // Spacing between rows
                ),
                // itemCount: 8,
                itemCount: dataContoller.productsItems.length,
                itemBuilder: (context, index) {
                  final item = dataContoller.productsItems[index];
                  final productId = item['_id'];
                  final categoryId = item['category_id']['_id'];
                  final isFavorite =
                      dataContoller.favoriteProducts.contains(productId);
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.productDetailsScreen,
                          arguments: item);
                    },
                    child: ProductCartWidget(
                      id: item['_id'],
                      name: item['name'],
                      price: item['price'],
                      rating: item['rating'],
                      image: (item['image'] is List &&
                              (item['image'] as List).isNotEmpty)
                          ? item['image'][0]
                          : AssetConstant.pd3, // Fallback image
                      isFavorite: isFavorite,
                      onToggleFavorite: (isNowFavorite) async {
                        if (isFavorite) {
                          await ApiService.removeFromFavorite(
                              productId, categoryId);
                          dataContoller.favoriteProducts.remove(productId);
                        } else {
                          await ApiService.addToFavorites(
                              productId, categoryId);
                          dataContoller.favoriteProducts.add(productId);
                        }
                        dataContoller.favoriteProducts.refresh();
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
