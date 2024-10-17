import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/controllers/auth_controller.dart';
import 'package:fashion/Modules/Auth/controllers/validation.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Modules/Home/Widget/banner_widget.dart';
import 'package:fashion/Modules/Home/Widget/product_cart_widget.dart';
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

class Homeweb extends StatefulWidget {
  const Homeweb({super.key});

  @override
  State<Homeweb> createState() => _HomewebState();
}

class _HomewebState extends State<Homeweb> {
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
      log('Data after Login / Register / Restart -- : $dataStorage');
      log('Carousal itesms : ${dataContoller.carousalItems.length}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userName = dataStorage?['data']['name'] ?? 'Demo';
    final String userImage = dataStorage?['data']['image'] ?? '';
    final imageUrl = userImage.isNotEmpty
        ? '${ApiConstants.imageBaseUrl}$userImage'
        : AssetConstant.pd1;

    nameController.text = validationController.userName.value;
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: SingleChildScrollView(
        child: Column(
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

            //banner
            Obx(
              () => dataContoller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: Responsive.isDesktop(context)
                          ? 70.h
                          : Responsive.isTablet(context)
                              ? 50.h
                              : 18.h,
                      width: 100.w,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                          },
                        ),
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
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
            ),
            SizedBox(
              height: Responsive.isDesktop(context) ? 2.h : 2.h,
            ),

            //category
            Container(
              decoration: const BoxDecoration(
                color: ColorConstants.foreground,
              ),
              height: Responsive.isDesktop(context) ? 8.h : 8.h,
              width: 100.w,
              child: Padding(
                padding: EdgeInsets.only(
                  top: Responsive.isDesktop(context) ? 2.h : 2.h,
                  left: Responsive.isDesktop(context) ? 4.w : 4.w,
                  right: Responsive.isDesktop(context) ? 4.w : 4.w,
                  bottom: Responsive.isDesktop(context) ? 2.h : 2.h,
                ),
                // padding: EdgeInsets.symmetric(
                //   vertical: Responsive.isDesktop(context)
                //       ? 2.h
                //       : 1.5.h, // Adjusted padding for mobile
                //   horizontal: Responsive.isDesktop(context) ? 4.w : 3.w,
                // ),
                child: Row(
                  children: [
                    FittedBox(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: StringConstants.category,
                        color: ColorConstants.blackColor,
                        fontSize: Responsive.isDesktop(context) ? 4 : 11,
                        weight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context) ? 4.w : 2.w,
                    ),
                    Obx(() {
                      if (dataContoller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        // Dropdown for web
                        // Ensure there's at least one item in categoryItems
                        if (dataContoller.categoryItems.isEmpty) {
                          return const Center(
                              child: Text('No categories available'));
                        }

                        String? selectedValue =
                            dataContoller.selectedCategoryId.value.isNotEmpty
                                ? dataContoller.selectedCategoryId.value
                                : null;

                        // Ensure selectedValue exists in categoryItems
                        bool isValidValue = dataContoller.categoryItems
                            .any((item) => item['_id'] == selectedValue);
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorConstants.rich, // Add color
                              borderRadius: BorderRadius.circular(
                                  8), // Add border radius for a rounded effect
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      0.1), // Light shadow for depth
                                  blurRadius: 6,
                                  offset: const Offset(0, 4), // Shadow position
                                ),
                              ],
                            ),
                            width: Responsive.isDesktop(context) ? 200 : 150,
                            height: Responsive.isDesktop(context) ? 60 : 60,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                padding: EdgeInsets.all(
                                  Responsive.isDesktop(context) ? 5 : 6,
                                ),
                                // value: dataContoller
                                //         .selectedCategoryId.value.isNotEmpty
                                //     ? dataContoller.selectedCategoryId.value
                                //     : null,
                                value: isValidValue ? selectedValue : null,

                                hint: Text(
                                  'Select Category',
                                  style: TextStyle(
                                    fontSize: Responsive.isDesktop(context)
                                        ? 16
                                        : 14, // Responsive font size
                                    color: Colors.white, // Text color
                                  ),
                                ),
                                items: dataContoller.categoryItems
                                    .map<DropdownMenuItem<String>>((item) {
                                  return DropdownMenuItem<String>(
                                    value: item['_id'],
                                    child: Text(
                                      item['name'] ?? 'No name',
                                      style: TextStyle(
                                        fontSize: Responsive.isDesktop(context)
                                            ? 16
                                            : 14, // Responsive text size
                                        color: Colors
                                            .black, // Dropdown item text color
                                      ),
                                    ),
                                  );
                                }).toList(),
                                dropdownColor: Colors.white,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white, // Dropdown icon color
                                  size: Responsive.isDesktop(context)
                                      ? 30
                                      : 24, // Adjust icon size
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != null && newValue.isNotEmpty) {
                                    dataContoller.selectedCategoryId.value =
                                        newValue;
                                    Get.toNamed(AppRoutes.categoryScreen,
                                        arguments: newValue);
                                    log('Selected Category ID: $newValue');
                                  }
                                },
                                style: TextStyle(
                                  color: Colors
                                      .white, // Text color for the selected item
                                  fontSize: Responsive.isDesktop(context)
                                      ? 16
                                      : 14, // Font size
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Responsive.isDesktop(context) ? 2.h : 2.h,
            ),

            // Sales Category Items with 'All' Button
            Padding(
              padding: EdgeInsets.only(
                left: Responsive.isDesktop(context) ? 4.w : 4.w,
                right: Responsive.isDesktop(context) ? 4.w : 4.w,
              ),
              child: Container(
                height: Responsive.isDesktop(context) ? 5.h : 4.5.h,
                padding: EdgeInsets.symmetric(
                    vertical: Responsive.isDesktop(context) ? 0.1.h : 0.3.h),
                child: Obx(() {
                  if (dataContoller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Row(
                    children: [
                      // All Button
                      Container(
                        width: Responsive.isDesktop(context) ? 20.w : 28.w,
                        height: Responsive.isDesktop(context) ? 5.h : 4.5.h,
                        padding: EdgeInsets.symmetric(
                            vertical:
                                Responsive.isDesktop(context) ? 0.1.h : 0.3.h),
                        child: Obx(() {
                          // Check if the 'All' button is selected
                          bool isSelected =
                              homeController.selectedsalesCategoryIndex.value ==
                                  -1;

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
                              // Fetch all products and mark 'All' as selected
                              dataContoller.fetchProducts();
                              homeController.setSelectedSalesCategory(
                                  -1); // -1 indicates the 'All' button
                            },
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  'All',
                                  style: TextStyle(
                                    fontSize:
                                        Responsive.isDesktop(context) ? 14 : 11,
                                    fontWeight: FontWeight.w400,
                                    color: isSelected
                                        ? ColorConstants.whiteColor
                                        : ColorConstants.blackColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      // Sales Category List
                      Expanded(
                        child: ListView.builder(
                          itemCount: dataContoller.salesCategoryItems.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              width:
                                  Responsive.isDesktop(context) ? 20.w : 28.w,
                              padding: EdgeInsets.only(left: 2.w),
                              child: Obx(() {
                                // Check if this index is the selected one
                                bool isSelected = homeController
                                        .selectedsalesCategoryIndex.value ==
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
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                    homeController
                                        .setSelectedSalesCategory(index);
                                    String selectedSaleCategoryId =
                                        dataContoller.salesCategoryItems[index]
                                            ['_id'];
                                    dataContoller.selectedCategoryId.value =
                                        selectedSaleCategoryId; // Store selected category ID
                                    dataContoller.fetchSalesCategoryProducts(
                                        selectedSaleCategoryId); // Fetch products for the selected category
                                  },
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        dataContoller.salesCategoryItems[index]
                                                ['name'] ??
                                            'Unknown',
                                        style: TextStyle(
                                          fontSize:
                                              Responsive.isDesktop(context)
                                                  ? 14
                                                  : 11,
                                          fontWeight: FontWeight.w400,
                                          color: isSelected
                                              ? ColorConstants.whiteColor
                                              : ColorConstants.blackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            SizedBox(
              height: Responsive.isDesktop(context) ? 2.h : 2.h,
            ),

            //products
            Padding(
              padding: EdgeInsets.only(
                left: Responsive.isDesktop(context) ? 4.w : 4.w,
                right: Responsive.isDesktop(context) ? 4.w : 4.w,
              ),
              child: Obx(
                () {
                  if (dataContoller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return GridView.builder(
                      // padding: EdgeInsets.only(
                      //   bottom: 8.h,
                      // ),
                      padding: EdgeInsets.zero,
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
                      // itemCount: dataContoller.productsItems.length,
                      itemCount: dataContoller.filteredProductsItems.length,

                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // final item = dataContoller.productsItems[index];
                        final item = dataContoller.filteredProductsItems[index];

                        final productId = item['_id'];
                        final categoryId = item['category_id']['_id'];
                        final isFavorite = dataContoller.favoriteProducts
                            .contains(productId); // Track favorites

                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.productDwebScreen,
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
                            onToggleFavorite: (isNowFavorite) async {
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
          ],
        ),
      ),
    );
  }
}
