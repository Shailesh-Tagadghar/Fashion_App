import 'dart:developer';

import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Modules/Home/Widget/coupon_item_widget.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/responsive.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sizer/sizer.dart';

class Coupon extends StatelessWidget {
  Coupon({super.key});

  // Observable state
  final couponItems = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  @override
  Widget build(BuildContext context) {
    // Fetch coupons when the widget is built
    if (isLoading.value) {
      _fetchCoupons();
    }

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
            text: StringConstants.coupon,
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
          // decoration: BoxDecoration(
          //   border: Border.all(color: ColorConstants.lightGrayColor, width: 1),
          //   shape: BoxShape.circle,
          // ),
          child: IconButton(
            iconSize: Responsive.isDesktop(context) ? 20 : 24,
            icon: const Icon(
              Bootstrap.arrow_left,
              color: ColorConstants.blackColor,
            ),
            onPressed: () {
              if (Responsive.isDesktop(context)) {
                Get.toNamed(AppRoutes.cartwebScreen);
              } else {
                Get.back();
              }
            },
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: Responsive.isDesktop(context) ? 2.h : 0.h,
          left: Responsive.isDesktop(context) ? 4.w : 6.w,
          right: Responsive.isDesktop(context) ? 4.w : 6.w,
          bottom: Responsive.isDesktop(context) ? 2.h : 2.h,
        ),
        child: Obx(() => isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: CustomText(
                      text: StringConstants.offers,
                      fontSize: Responsive.isDesktop(context)
                          ? 7
                          : Responsive.isTablet(context)
                              ? 10
                              : 15,
                      weight: FontWeight.w500,
                      color: ColorConstants.blackColor,
                    ),
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: couponItems.length,
                      itemBuilder: (context, index) {
                        final item = couponItems[index];
                        return Column(
                          children: [
                            CouponItemWidget(
                              title: item['title'] ?? 'No Title',
                              descreption:
                                  item['descreption'] ?? 'No Description',
                              amount:
                                  '${StringConstants.offertext} ${item['amount']}% ${StringConstants.offertextII}',
                              copy: 'Copy',
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              )),
      ),
    );
  }

  Future<void> _fetchCoupons() async {
    try {
      final coupons = await ApiService.fetchCoupons();
      couponItems.assignAll(coupons); // Update the observable list
      isLoading.value = false; // Update loading state
    } catch (e) {
      log('Error fetching coupons: $e');
      isLoading.value = false; // Stop loading even on error
    }
  }
}
