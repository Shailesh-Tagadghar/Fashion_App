import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/responsive.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BannerWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const BannerWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage('${ApiConstants.imageBaseUrl}$image'),
              fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(10),
          color: ColorConstants.lightGrayColor,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            top: 2.h,
            bottom: 1.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                // width: 40.w,
                width: Responsive.isDesktop(context) ? 50.w : 40.w,
                child: FittedBox(
                  child: CustomText(
                    text: title,
                    color: ColorConstants.blackColor,
                    weight: FontWeight.w600,
                    // fontSize: 11,
                    fontSize: Responsive.isDesktop(context) ? 10 : 11,
                  ),
                ),
              ),
              SizedBox(
                // width: 37.w,
                width: Responsive.isDesktop(context) ? 45.w : 37.w,

                child: FittedBox(
                  child: CustomText(
                    text: subtitle,
                    color: ColorConstants.greyColor,
                    weight: FontWeight.w500,
                    // fontSize: 11,
                    fontSize: Responsive.isDesktop(context) ? 10 : 11,
                  ),
                ),
              ),
              SizedBox(
                height: Responsive.isDesktop(context) ? 1.5.h : 1.h,
              ),
              CustomButton(
                label: StringConstants.shopnowBtn,
                isSelected: true,
                btnColor: ColorConstants.primary,
                // height: 4.h,
                height: Responsive.isDesktop(context) ? 5.5.h : 4.h,
                // width: 27.w,
                width: Responsive.isDesktop(context) ? 25.w : 27.w,
                weight: FontWeight.w500,
                // fontSize: 9,
                fontSize: Responsive.isDesktop(context) ? 4.5 : 9,
              ),
            ],
          ),
        ));
  }
}
