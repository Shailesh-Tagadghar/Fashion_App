import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Home/Widget/product_cart_widget.dart';
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

  final HomeController homeController = Get.put(HomeController());
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
          // Container(
          //   height: 7.2.h,
          //   padding: EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
          //   child: ListView.builder(
          //       itemCount: homeController.wishlistCategory.length,
          //       scrollDirection: Axis.horizontal,
          //       itemBuilder: (context, index) {
          //         return Container(
          //           width: 28.w,
          //           padding: EdgeInsets.only(left: 4.w),
          //           child: Obx(() {
          //             return CustomButton(
          //               label: homeController.wishlistCategory[index],
          //               labelColor: ColorConstants.blackColor,
          //               action: () {
          //                 homeController.setSelectedCategory(index);
          //               },
          //               isSelected:
          //                   homeController.selectedCategoryIndex.value == index,
          //               btnColor: ColorConstants.whiteColor,
          //               fontSize: 11,
          //               weight: FontWeight.w400,
          //             );
          //           }),
          //         );
          //       }),
          // ),

          Obx(
            () => dashboardController.isLoadingCategory.value
                ? const CircularProgressIndicator()
                // SizedBox(
                //     height: 40,
                //     width: 100.w,
                //     child: ListView.builder(
                //         itemCount: categoryItems.length,
                //         scrollDirection: Axis.horizontal,
                //         itemBuilder: (context, index) {
                //           return SizedBox(
                //             width: 140.0,
                //             height: 38.0,
                //             child: Shimmer.fromColors(
                //               baseColor: Color.fromARGB(255, 226, 17, 17)!,
                //               highlightColor: Color.fromARGB(255, 15, 9, 9)!,
                //               child: Container(
                //                 padding: EdgeInsets.all(8),
                //                 decoration: BoxDecoration(
                //                   color: Colors.black.withOpacity(0.08),
                //                   borderRadius: BorderRadius.circular(40),
                //                 ),
                //               ),
                //             ),
                //           );
                //         }),
                //   )
                : Container(
                    height: 38,
                    margin: EdgeInsets.only(top: 1.2.h, bottom: 1.h),
                    child: ListView.builder(
                      itemCount: dataContoller.categoryItems.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var item = dataContoller.categoryItems[index];
                        String categoryName = item.name;
                        String categoryId = item.sId;

                        return Obx(
                          () {
                            bool isSelected =
                                homeController.selectedCategoryId.value ==
                                    categoryId;
                            return InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                // Print the selected categoryId
                                print("Selected Category ID: $categoryId");
                                homeController.selectCategoryId(
                                    categoryId); // Set the _id instead of the name
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: isSelected
                                      ? ColorConstants.primary
                                      : ColorConstants.whiteColor,
                                  border: Border.all(
                                    color: isSelected
                                        ? ColorConstants.primary
                                        : ColorConstants.lightGrayColor,
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 2.w),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: CustomText(
                                    text:
                                        categoryName, // Display the category name
                                    fontSize: 11,
                                    weight: FontWeight.w500,
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
          ),
          listproductItems(),
        ],
      ),
    );
  }

  Widget listproductItems() {
    return Obx(
      () => homeController.isFetchingFavouriteProduct.value
          ? const CircularProgressIndicator()
          : homeController.favouriteProducts.isEmpty
              ? const Center(
                  heightFactor: 18,
                  child: CustomText(
                    text: "Your wishlist is empty.",
                    fontSize: 12,
                    weight: FontWeight.w500,
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.w, right: 4.w),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.77,
                      ),
                      // itemCount: 8,
                      itemCount: homeController.favouriteProducts.length,
                      itemBuilder: (context, index) {
                        // final item = foodItems[index];
                        // return Container(
                        //   padding: const EdgeInsetsDirectional.all(8),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(12),
                        //     color: ColorConstants.whiteColor,
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Stack(
                        //         alignment: Alignment.topRight,
                        //         children: [
                        //           ClipRRect(
                        //             borderRadius: BorderRadius.circular(12),
                        //             child: Image(
                        //               height: 19.h,
                        //               fit: BoxFit.cover,
                        //               width: double.infinity,
                        //               image:
                        //                   const AssetImage(AssetConstant.pd3),
                        //             ),
                        //           ),
                        //           Container(
                        //             width: 8.6.w,
                        //             height: 4.4.h,
                        //             margin:
                        //                 const EdgeInsets.only(right: 8, top: 8),
                        //             decoration: BoxDecoration(
                        //               color: ColorConstants.whiteColor
                        //                   .withOpacity(0.5),
                        //               shape: BoxShape.circle,
                        //             ),
                        //             child: IconButton(
                        //               padding: const EdgeInsets.all(1),
                        //               iconSize: 22,
                        //               icon: const Icon(
                        //                 Icons.favorite_outline_outlined,
                        //                 color: ColorConstants.primary,
                        //               ),
                        //               onPressed: () {},
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(
                        //         height: 0.8.h,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           const CustomText(
                        //             text: StringConstants.productname,
                        //             fontSize: 12,
                        //             weight: FontWeight.w400,
                        //             color: ColorConstants.blackColor,
                        //           ),
                        //           Row(
                        //             children: [
                        //               Icon(
                        //                 Icons.star,
                        //                 color: Colors.amber[500],
                        //                 size: 19,
                        //               ),
                        //               SizedBox(
                        //                 width: 0.5.w,
                        //               ),
                        //               const CustomText(
                        //                 text: StringConstants.rating,
                        //                 fontSize: 12,
                        //                 weight: FontWeight.w400,
                        //                 color: ColorConstants.greyColor,
                        //               ),
                        //             ],
                        //           )
                        //         ],
                        //       ),
                        //       SizedBox(
                        //         height: 0.4.h,
                        //       ),
                        //       const CustomText(
                        //         text: '\$${StringConstants.productprice}',
                        //         fontSize: 12,
                        //         weight: FontWeight.w500,
                        //         color: ColorConstants.blackColor,
                        //       )
                        //     ],
                        //   ),
                        // );

                        final item = homeController.favouriteProducts[index];
                        return ProductCartWidget(
                          id: item.productId?.sId,
                          name: item.productId?.name,
                          price: item.productId?.price,
                          rating: item.productId?.rating,
                          image: item.productId?.image?[0],
                          category_id: item.productId?.categoryId,
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}
