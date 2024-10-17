import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Modules/Home/Widget/product_cart_widget.dart';
import 'package:fashion/Modules/Home/controllers/data_contoller.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/responsive.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sizer/sizer.dart';

class Search extends StatelessWidget {
  Search({super.key});

  final searchController = TextEditingController();
  final searchResults = [].obs;

  @override
  Widget build(BuildContext context) {
    final DataContoller dataContoller = Get.put(DataContoller());
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.whiteColor,
        toolbarHeight: 10.h,
        leadingWidth: 15.w,
        title: FittedBox(
          child: CustomText(
            text: StringConstants.search,
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
                Get.toNamed(AppRoutes.homewebScreen);
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: Responsive.isDesktop(context) ? 25.w : 5.w,
          right: Responsive.isDesktop(context) ? 25.w : 5.w,
          bottom: 2.h,
          top: Responsive.isDesktop(context) ? 4.h : 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  // Icons.search,
                  Bootstrap.search,
                  size: 24,
                  color: ColorConstants.rich,
                ),
                hintText: StringConstants.search,
                hintStyle: const TextStyle(
                  color: ColorConstants.greyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: const BorderSide(
                    color: ColorConstants.background,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: const BorderSide(
                    color: ColorConstants.background,
                  ),
                ),
              ),
              onChanged: (text) async {
                // Fetch search results
                List<dynamic> results =
                    await ApiService.fetchSearchResults(text);
                searchResults.value = results;
              },
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  child: CustomText(
                    text: StringConstants.recent,
                    color: ColorConstants.blackColor,
                    fontSize: Responsive.isDesktop(context)
                        ? 4
                        : Responsive.isDesktop(context)
                            ? 7
                            : 14,
                    weight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    searchController.clear();
                    searchResults.clear();
                  },
                  child: FittedBox(
                    child: CustomText(
                      text: StringConstants.clear,
                      color: ColorConstants.rich,
                      fontSize: Responsive.isDesktop(context)
                          ? 4
                          : Responsive.isDesktop(context)
                              ? 5
                              : 14,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Divider(
              color: ColorConstants.background,
              height: 2.h,
              thickness: 1,
            ),
            SizedBox(
              height: 2.h,
            ),
            // Display search results
            Obx(
              () {
                if (dataContoller.isLoading.value) {
                  return const CircularProgressIndicator();
                }

                if (searchResults.isEmpty) {
                  return const Text('No products found');
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      var product = searchResults[index];
                      return ListTile(
                        contentPadding: EdgeInsets.only(
                          bottom: Responsive.isDesktop(context)
                              ? 14.h
                              : Responsive.isTablet(context)
                                  ? 13.h
                                  : 1.h,
                          left: Responsive.isDesktop(context)
                              ? 4.w
                              : Responsive.isTablet(context)
                                  ? 4.w
                                  : 4.w,
                          right: Responsive.isDesktop(context)
                              ? 2.w
                              : Responsive.isTablet(context)
                                  ? 2.w
                                  : 2.w,
                          top: Responsive.isDesktop(context)
                              ? 14.h
                              : Responsive.isTablet(context)
                                  ? 13.h
                                  : 1.h,
                        ),
                        textColor: ColorConstants.blackColor,
                        titleTextStyle: TextStyle(
                          color: ColorConstants.blackColor,
                          fontSize: Responsive.isDesktop(context)
                              ? 24
                              : Responsive.isTablet(context)
                                  ? 20
                                  : 19,
                          fontWeight: FontWeight.w400,
                        ),
                        subtitleTextStyle: TextStyle(
                          color: ColorConstants.blackColor,
                          fontSize: Responsive.isTablet(context)
                              ? 24
                              : Responsive.isDesktop(context)
                                  ? 20
                                  : 19,
                          fontWeight: FontWeight.w400,
                        ),
                        tileColor: ColorConstants.lightGrayColor,
                        leading: Image.network(
                          '${ApiConstants.imageBaseUrl}${product['image'][0]}',
                          // Ensure this URL is valid
                          fit: BoxFit.fill,
                          height: Responsive.isDesktop(context)
                              ? 10.h
                              : Responsive.isTablet(context)
                                  ? 30.h
                                  : 40.h,
                          width: Responsive.isDesktop(context)
                              ? 10.w
                              : Responsive.isTablet(context)
                                  ? 30.w
                                  : 25.w,
                        ),
                        title: Text(
                            'Name : ${product['name']}'), // Assuming 'name' is a field
                        subtitle: Text('Price : ${product['price']}'
                            .toString()), // Adjust as per your data

                        onTap: () {
                          // Navigate to product details
                          if (Responsive.isDesktop(context)) {
                            Get.toNamed(AppRoutes.productDwebScreen,
                                arguments: product);
                          } else {
                            Get.toNamed(AppRoutes.productDetailsScreen,
                                arguments: product);
                          }
                        },
                      );
                    },
                  ),
                  //     GridView.builder(
                  //   padding: EdgeInsets.zero,
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: Responsive.isDesktop(context)
                  //         ? 4
                  //         : Responsive.isTablet(context)
                  //             ? 3
                  //             : 2,
                  //     childAspectRatio: Responsive.isDesktop(context)
                  //         ? 0.4
                  //         : 0.69, // Adjusts the size of the items
                  //     crossAxisSpacing: Responsive.isDesktop(context)
                  //         ? 4
                  //         : 4.0, // Spacing between columns
                  //     mainAxisSpacing: Responsive.isDesktop(context)
                  //         ? 4
                  //         : 2.0, // Spacing between rows
                  //   ),
                  //   itemCount: searchResults.length,
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemBuilder: (context, index) {
                  //     final item = searchResults[index];
                  //     return GestureDetector(
                  //       onTap: () {
                  //         // Navigate to product details page
                  //         Get.toNamed(AppRoutes.productDetailsScreen,
                  //             arguments: item);
                  //       },
                  //       child: ProductCartWidget(
                  //         name: item['name'],
                  //         price: item['price'],
                  //         rating: item['rating'],
                  //         image: (item['image'] is List &&
                  //                 (item['image'] as List).isNotEmpty)
                  //             ? item['image']
                  //                 [0] // Use the first image from the list
                  //             : AssetConstant.pd3, // Fallback image
                  //         isFavorite: false,
                  //         onToggleFavorite: (p0) {},
                  //       ),
                  //     );
                  //   },
                  // ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
