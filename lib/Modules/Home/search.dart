import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Modules/Home/controllers/data_contoller.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
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
        title: const CustomText(
          text: StringConstants.search,
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
              // Get.back();
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 5.w,
          right: 5.w,
          bottom: 2.h,
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
                const CustomText(
                  text: StringConstants.recent,
                  color: ColorConstants.blackColor,
                  fontSize: 14,
                  weight: FontWeight.w500,
                ),
                GestureDetector(
                  onTap: () {
                    searchController.clear();
                    searchResults.clear();
                  },
                  child: const CustomText(
                    text: StringConstants.clear,
                    color: ColorConstants.rich,
                    fontSize: 14,
                    weight: FontWeight.w500,
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
                          bottom: 1.h,
                          left: 4.w,
                          right: 2.w,
                          top: 1.h,
                        ),
                        textColor: ColorConstants.blackColor,
                        titleTextStyle: const TextStyle(
                          color: ColorConstants.blackColor,
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                        ),
                        subtitleTextStyle: const TextStyle(
                          color: ColorConstants.blackColor,
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                        ),
                        tileColor: ColorConstants.lightGrayColor,
                        leading: Image.network(
                          '${ApiConstants.imageBaseUrl}${product['image'][0]}', // Ensure this URL is valid
                          fit: BoxFit.fill,
                          height: 40.h,
                          width: 25.w,
                        ),
                        title: Text(
                            'Name : ${product['name']}'), // Assuming 'name' is a field
                        subtitle: Text('Price : ${product['price']}'
                            .toString()), // Adjust as per your data

                        onTap: () {
                          // Navigate to product details
                          Get.toNamed(AppRoutes.productDetailsScreen,
                              arguments: product);
                        },
                      );
                    },
                  ),
                  //     GridView.builder(
                  //   padding: EdgeInsets.zero,
                  //   gridDelegate:
                  //       const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2, // Number of items per row
                  //     childAspectRatio: 0.69, // Adjusts the size of the items
                  //     crossAxisSpacing: 4.0, // Spacing between columns
                  //     mainAxisSpacing: 4.0, // Spacing between rows
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
