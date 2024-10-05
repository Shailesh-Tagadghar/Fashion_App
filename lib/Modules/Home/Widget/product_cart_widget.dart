import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProductCartWidget extends StatelessWidget {
  final String? id;
  final String name;
  final int price;
  final double rating;
  final String? description;
  final String? sizechart;
  final String? colorchart;
  final String image;
  final String? salecategory_id;
  final String? category_id;
  final String? gender;

  const ProductCartWidget({
    super.key,
    this.id,
    required this.name,
    required this.price,
    required this.rating,
    this.description,
    this.sizechart,
    this.colorchart,
    required this.image,
    this.salecategory_id,
    this.category_id,
    this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorConstants.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  '${ApiConstants.imageBaseUrl}$image',
                  fit: BoxFit.fill,
                  width: 100.w,
                  height: 19.h,
                ),
              ),
              Container(
                width: 8.6.w,
                height: 4.4.h,
                margin: const EdgeInsets.only(right: 8, top: 8),
                decoration: BoxDecoration(
                  color: ColorConstants.whiteColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: const EdgeInsets.all(1),
                  iconSize: 22,
                  icon: const Icon(
                    Icons.favorite_outline_outlined,
                    color: ColorConstants.primary,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(
            height: 0.8.h,
          ),
          CustomText(
            text: name,
            fontSize: 11,
            weight: FontWeight.w400,
            color: ColorConstants.blackColor,
          ),
          SizedBox(
            height: 0.4.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: '\$${price.toString()}',
                fontSize: 12,
                weight: FontWeight.w500,
                color: ColorConstants.blackColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber[500],
                    size: 14,
                  ),
                  SizedBox(
                    width: 0.5.w,
                  ),
                  CustomText(
                    text: rating.toString(),
                    fontSize: 10,
                    weight: FontWeight.w400,
                    color: ColorConstants.greyColor,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
