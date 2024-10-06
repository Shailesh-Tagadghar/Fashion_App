import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Modules/Home/Widget/banner_widget.dart';
import 'package:fashion/Modules/Home/Widget/category_widget.dart';
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

class Home extends StatelessWidget {
  Home({super.key});

  final HomeController homeController = Get.put(HomeController());
  final DataContoller dataContoller = Get.put(DataContoller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            bottom: 6.5.h,
            top: 5.h,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: StringConstants.location,
                        color: ColorConstants.greyColor,
                        fontSize: 10,
                        weight: FontWeight.w400,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: ColorConstants.rich,
                            size: 16,
                          ),
                          SizedBox(
                            width: 0.5.w,
                          ),
                          SizedBox(
                            height: 2.3.h,
                            width: 32.w,
                            child: Obx(
                              () => DropdownButton<String>(
                                value: homeController.dropdownValue.value,
                                underline: const SizedBox(),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: ColorConstants.greyColor,
                                ),
                                iconSize: 5.5.w,
                                elevation: 0,
                                // dropdownColor:
                                //     const Color.fromARGB(150, 0, 0, 0),
                                dropdownColor: ColorConstants.whiteColor,
                                style: const TextStyle(
                                  color: ColorConstants.blackColor,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                ),
                                items: <String>[
                                  StringConstants.location,
                                  StringConstants.dropLoc1,
                                  StringConstants.dropLoc2,
                                ].map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.bottomLeft,
                                      value: value,
                                      child: Text(value),
                                    );
                                  },
                                ).toList(),
                                onChanged: (String? newValue) {
                                  homeController.setDropdownValue(newValue!);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: ColorConstants.background,
                      border: Border.all(
                          color: ColorConstants.background, width: 1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      color: ColorConstants.background,
                      iconSize: 4.9.w,
                      icon: const Icon(
                        Icons.notification_important,
                        color: ColorConstants.blackColor,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 75.w,
                    height: 5.h,
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: ColorConstants.rich,
                          size: 28,
                        ),
                        hintText: StringConstants.search,
                        hintStyle: const TextStyle(
                          color: ColorConstants.greyColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: const BorderSide(
                            color: ColorConstants.lightGrayColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: const BorderSide(
                            color: ColorConstants.lightGrayColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: const BorderSide(
                            color: ColorConstants.lightGrayColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: ColorConstants.rich,
                      border: Border.all(
                          color: ColorConstants.background, width: 1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      iconSize: 4.9.w,
                      icon: const Icon(
                        Bootstrap.sliders,
                        color: ColorConstants.whiteColor,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Obx(
                () => dataContoller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        height: 18.h,
                        width: 100.w,
                        child: PageView.builder(
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
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: StringConstants.category,
                    color: ColorConstants.blackColor,
                    fontSize: 13,
                    weight: FontWeight.w500,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await dataContoller.fetchProducts();
                    },
                    child: const CustomText(
                      text: StringConstants.seeAll,
                      color: ColorConstants.rich,
                      fontSize: 11,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Obx(
                () {
                  if (dataContoller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return SizedBox(
                      height: 10.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dataContoller.categoryItems.length,
                        itemBuilder: (context, index) {
                          final item = dataContoller.categoryItems[index];
                          final isSelected =
                              dataContoller.selectedCategoryId.value ==
                                  item['_id'];

                          return GestureDetector(
                            onTap: () {
                              // Fetch products by category when clicked
                              dataContoller.fetchCategoryProducts(item['_id']);
                            },
                            child: CategoryWidget(
                              image: item['image'] ?? AssetConstant.cat1,
                              name: item['name'] ?? 'No name',
                              isSelected:
                                  isSelected, // Highlight selected category
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: StringConstants.flash,
                      color: ColorConstants.blackColor,
                      fontSize: 14,
                      weight: FontWeight.w500,
                    ),
                    const Spacer(),
                    const CustomText(
                      text: StringConstants.timer,
                      color: ColorConstants.greyColor,
                      fontSize: 11,
                      weight: FontWeight.w400,
                    ),
                    buildTimeContainer(
                        homeController.hours.value.toString().padLeft(2, '0'),
                        context),
                    Container(
                      padding: const EdgeInsets.all(4),
                      child: const CustomText(
                        text: ":",
                        fontSize: 14,
                        weight: FontWeight.w400,
                      ),
                    ),
                    buildTimeContainer(
                        homeController.minutes.value.toString().padLeft(2, '0'),
                        context),
                    Container(
                      padding: const EdgeInsets.all(4),
                      child: const CustomText(
                        text: ":",
                        fontSize: 14,
                        weight: FontWeight.w400,
                      ),
                    ),
                    buildTimeContainer(
                        homeController.seconds.value.toString().padLeft(2, '0'),
                        context),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Container(
                height: 4.5.h,
                padding: EdgeInsets.symmetric(vertical: 0.3.h),
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
                      // return Container(
                      //   width: 40.w,
                      //   padding: EdgeInsets.only(left: 2.w),
                      //   child: CustomButton(
                      //     label: dataContoller.salesCategoryItems[index]
                      //             ['name'] ??
                      //         'Unknown', // Adjust key based on your API response
                      //     labelColor: ColorConstants.blackColor,
                      //     action: () {
                      //       // Handle category selection
                      //       homeController.setSelectedSalesCategory(index);
                      //       String selectedSaleCategoryId =
                      //           dataContoller.salesCategoryItems[index]['_id'];
                      //       dataContoller.selectedCategoryId.value =
                      //           selectedSaleCategoryId; // Store selected category ID
                      //       dataContoller.fetchSalesCategoryProducts(
                      //           selectedSaleCategoryId); // Fetch products for the selected category
                      //       // dataContoller.update();
                      //     },
                      //     isSelected:
                      //         homeController.selectedsalesCategoryIndex.value ==
                      //             index,
                      //     btnColor: ColorConstants.whiteColor,
                      //     fontSize: 11,
                      //     weight: FontWeight.w400,
                      //   ),
                      // );

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
                              String selectedSaleCategoryId = dataContoller
                                  .salesCategoryItems[index]['_id'];
                              dataContoller.selectedCategoryId.value =
                                  selectedSaleCategoryId; // Store selected category ID
                              dataContoller.fetchSalesCategoryProducts(
                                  selectedSaleCategoryId); // Fetch products for the selected category
                            },
                            child: Center(
                              child: Text(
                                dataContoller.salesCategoryItems[index]
                                        ['name'] ??
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
              SizedBox(
                height: 1.5.h,
              ),
              Obx(
                () {
                  if (dataContoller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return GridView.builder(
                      // padding: EdgeInsets.only(
                      //   bottom: 8.h,
                      // ),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of items per row
                        childAspectRatio: 0.69, // Adjusts the size of the items
                        crossAxisSpacing: 4.0, // Spacing between columns
                        mainAxisSpacing: 4.0, // Spacing between rows
                      ),
                      itemCount: dataContoller.productsItems.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = dataContoller.productsItems[index];
                        final productId = item['_id'];
                        final categoryId = item['category_id']['_id'];
                        final isFavorite = dataContoller.favoriteProducts
                            .contains(productId); // Track favorites

                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.productDetailsScreen,
                                arguments: item);
                          },
                          child: ProductCartWidget(
                            name: item['name'],
                            price: item['price'],
                            rating: item['rating'],
                            image: (item['image'] is List &&
                                    (item['image'] as List).isNotEmpty)
                                ? item['image']
                                    [0] // Use the first image from the list
                                : AssetConstant.pd3, // Fallback image
                            isFavorite: isFavorite,
                            onToggleFavorite: () async {
                              if (isFavorite) {
                                await ApiService.removeFromFavorite(
                                    productId, categoryId);
                                dataContoller.favoriteProducts
                                    .remove(productId);
                              } else {
                                await ApiService.addToFavorites(
                                    productId, categoryId);
                                dataContoller.favoriteProducts.add(productId);
                              }
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimeContainer(String time, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: ColorConstants.lightGrayColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: CustomText(
            text: time,
            fontSize: 10,
            weight: FontWeight.w400,
            color: ColorConstants.primary,
          ),
        ),
      ],
    );
  }
}
