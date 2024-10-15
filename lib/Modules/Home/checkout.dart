import 'dart:developer';

import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Home/controllers/home_controller.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sizer/sizer.dart';

class Checkout extends StatelessWidget {
  Checkout({super.key});

  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.whiteColor,
        foregroundColor: ColorConstants.blackColor,
        shadowColor: ColorConstants.whiteColor,
        surfaceTintColor: ColorConstants.whiteColor,
        toolbarHeight: 10.h,
        leadingWidth: 15.w,
        title: const CustomText(
          text: StringConstants.payment,
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
          left: 6.w,
          right: 6.w,
          bottom: 10.h,
          top: 25.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Bootstrap.check_circle_fill,
              color: ColorConstants.rich,
              size: 12.h,
            ),
            SizedBox(
              height: 2.h,
            ),
            const CustomText(
              text: StringConstants.success,
              color: ColorConstants.blackColor,
              fontSize: 16,
              weight: FontWeight.w500,
            ),
            SizedBox(
              height: 1.5.h,
            ),
            const CustomText(
              text: StringConstants.thankyounote,
              color: ColorConstants.greyColor,
              fontSize: 12,
              weight: FontWeight.w400,
            ),
            const Spacer(),
            CustomButton(
              label: StringConstants.home,
              btnColor: ColorConstants.rich,
              isSelected: true,
              fontSize: 16,
              labelColor: ColorConstants.whiteColor,
              height: 6.h,
              weight: FontWeight.w500,
              action: () {
                log("final tap::::${_controller.selectedIndex.value}");
                Get.offNamed(AppRoutes.navbarScreen);
              },
            )
          ],
        ),
      ),
    );
  }
}
