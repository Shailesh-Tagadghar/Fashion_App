import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CategoryWidget extends StatelessWidget {
  final String image;
  final String name;

  const CategoryWidget({
    super.key,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 3.5.w,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 16.w, // Set a width
              height: 7.h,
              decoration: const BoxDecoration(
                color: ColorConstants.background,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Image(
                  image: NetworkImage('${ApiConstants.imageBaseUrl}$image'),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          CustomText(
            text: name,
            color: ColorConstants.blackColor,
            weight: FontWeight.w500,
            fontSize: 9,
          ),
        ],
      ),
    );
  }
}
