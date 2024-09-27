
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sizer/sizer.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
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
              Get.back();
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
                    Get.toNamed(AppRoutes.productDetailsScreen);
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
            )
          ],
        ),
      ),
    );
  }
}
