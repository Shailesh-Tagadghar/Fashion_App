import 'dart:developer';

import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Home/controllers/data_contoller.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CouponItemWidget extends StatelessWidget {
  final String title;
  final String descreption;
  final String amount;
  final String copy;

  const CouponItemWidget({
    super.key,
    required this.title,
    required this.descreption,
    required this.amount,
    required this.copy,
  });

  @override
  Widget build(BuildContext context) {
    final dataController = Get.find<DataContoller>();
    return Padding(
      padding: EdgeInsets.only(
        top: Responsive.isDesktop(context) ? 2.h : 0.2.h,
        left: Responsive.isDesktop(context) ? 22.w : 1.5.w,
        right: Responsive.isDesktop(context) ? 22.w : 1.5.w,
      ),
      child: Column(
        children: [
          Container(
            // height: 24.15.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                color: ColorConstants.lightGrayColor,
                // width: 0.3,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: Responsive.isDesktop(context) ? 2.h : 2.h,
                    left: Responsive.isDesktop(context) ? 7.w : 4.w,
                    right: Responsive.isDesktop(context) ? 7.w : 4.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        // text: StringConstants.welcome,
                        text: title,
                        fontSize: Responsive.isDesktop(context)
                            ? 4
                            : Responsive.isTablet(context)
                                ? 10
                                : 14,
                        color: ColorConstants.blackColor,
                        weight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      CustomText(
                        text: descreption,
                        fontSize: Responsive.isDesktop(context)
                            ? 3.5
                            : Responsive.isTablet(context)
                                ? 8.5
                                : 12.5,
                        color: ColorConstants.greyColor,
                        weight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      Row(
                        children: [
                          const Image(
                            image: AssetImage(
                              AssetConstant.percent,
                            ),
                            height: 24,
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          CustomText(
                            text: amount,
                            fontSize: Responsive.isDesktop(context)
                                ? 4
                                : Responsive.isTablet(context)
                                    ? 10
                                    : 14,
                            color: ColorConstants.blackColor,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                GestureDetector(
                  onTap: () {
                    dataController.setCoupon(title);
                    log('Coupon Value : $title');
                    if (Responsive.isDesktop(context) &&
                        Responsive.isTablet(context)) {
                      Get.toNamed(AppRoutes.cartwebScreen);
                    } else {
                      Get.back();
                    }
                  },
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    height: Responsive.isDesktop(context)
                        ? 6.h
                        : Responsive.isTablet(context)
                            ? 6.h
                            : 6.h,
                    width: Responsive.isDesktop(context)
                        ? 50.w
                        : Responsive.isTablet(context)
                            ? 70.w
                            : 100.w,
                    decoration: const BoxDecoration(
                      color: ColorConstants.background,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: CustomText(
                      text: copy,
                      fontSize: Responsive.isDesktop(context)
                          ? 5
                          : Responsive.isTablet(context)
                              ? 12
                              : 16,
                      weight: FontWeight.w500,
                      color: ColorConstants.rich,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
