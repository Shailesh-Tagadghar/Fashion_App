import 'dart:developer';

import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Home/controllers/home_controller.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/responsive.dart';
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
        title: FittedBox(
          child: CustomText(
            text: StringConstants.payment,
            weight: FontWeight.w500,
            fontSize: Responsive.isDesktop(context) ? 4 : 13,
          ),
        ),
        centerTitle: true,
        leading: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
            left: Responsive.isDesktop(context) ? 0.2.w : 4.w,
          ),
          padding: EdgeInsets.all(
            Responsive.isDesktop(context) ? 0.2.w : 0.6.w,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: ColorConstants.lightGrayColor, width: 1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            iconSize: Responsive.isDesktop(context) ? 20 : 24,
            icon: const Icon(
              Bootstrap.arrow_left,
              color: ColorConstants.blackColor,
            ),
            onPressed: () {
              if (Responsive.isDesktop(context)) {
                Get.toNamed(AppRoutes.homewebScreen);
              } else {
                Get.back();
              }
            },
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: Responsive.isDesktop(context) ? 10.h : 25.h,
          left: Responsive.isDesktop(context) ? 35.w : 6.w,
          right: Responsive.isDesktop(context) ? 35.w : 6.w,
          bottom: Responsive.isDesktop(context) ? 20.h : 10.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Bootstrap.check_circle_fill,
              color: ColorConstants.rich,
              size: Responsive.isDesktop(context) ? 12.h : 12.h,
            ),
            SizedBox(
              height: 2.h,
            ),
            FittedBox(
              child: CustomText(
                text: StringConstants.success,
                color: ColorConstants.blackColor,
                fontSize: Responsive.isDesktop(context)
                    ? 20
                    : Responsive.isDesktop(context)
                        ? 18
                        : 16,
                weight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            FittedBox(
              child: CustomText(
                text: StringConstants.thankyounote,
                color: ColorConstants.greyColor,
                fontSize: Responsive.isDesktop(context)
                    ? 18
                    : Responsive.isDesktop(context)
                        ? 16
                        : 12,
                weight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            CustomButton(
              label: StringConstants.home,
              btnColor: ColorConstants.rich,
              isSelected: true,
              fontSize: Responsive.isDesktop(context)
                  ? 3
                  : Responsive.isDesktop(context)
                      ? 3
                      : 16,
              labelColor: ColorConstants.whiteColor,
              height: Responsive.isDesktop(context)
                  ? 6.h
                  : Responsive.isDesktop(context)
                      ? 6.h
                      : 6.h,
              weight: FontWeight.w500,
              action: () {
                log("final tap::::${_controller.selectedIndex.value}");
                if (Responsive.isDesktop(context)) {
                  Get.toNamed(AppRoutes.homewebScreen);
                } else {
                  Get.offNamed(AppRoutes.navbarScreen);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
