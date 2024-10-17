import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class ProductCartWidget extends StatefulWidget {
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
  bool isFavorite; // New property
  final Function(bool) onToggleFavorite; // New callback

  ProductCartWidget({
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
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  State<ProductCartWidget> createState() => _ProductCartWidgetState();
}

class _ProductCartWidgetState extends State<ProductCartWidget> {
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
                  '${ApiConstants.imageBaseUrl}${widget.image}',
                  fit: BoxFit.fill,
                  width: 100.w,
                  height: Responsive.isDesktop(context) ? 34.h : 19.h,
                ),
              ),
              Container(
                width: 8.6.w,
                height: 4.4.h,
                margin: EdgeInsets.only(
                    right: Responsive.isDesktop(context) ? 0.01 : 8,
                    top: Responsive.isDesktop(context) ? 4 : 8),
                decoration: BoxDecoration(
                  color: ColorConstants.whiteColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: const EdgeInsets.all(1),
                  iconSize: Responsive.isDesktop(context) ? 34 : 22,
                  icon: Icon(
                    widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.isFavorite
                        ? ColorConstants.rich
                        : ColorConstants.blackColor,
                  ),
                  // onPressed: widget.onToggleFavorite,
                  onPressed: () {
                    setState(() {
                      widget.isFavorite = !widget.isFavorite;
                    });
                    widget.onToggleFavorite(widget.isFavorite);
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: Responsive.isDesktop(context) ? 1 : 0.8.h,
          ),
          FittedBox(
            child: CustomText(
              text: widget.name,
              fontSize: Responsive.isDesktop(context) ? 4 : 11,
              weight: FontWeight.w400,
              color: ColorConstants.blackColor,
            ),
          ),
          SizedBox(
            height: 0.4.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                child: CustomText(
                  text: '\$${widget.price.toString()}',
                  fontSize: Responsive.isDesktop(context) ? 4 : 12,
                  weight: FontWeight.w500,
                  color: ColorConstants.blackColor,
                ),
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
                  FittedBox(
                    child: CustomText(
                      text: widget.rating.toString(),
                      fontSize: Responsive.isDesktop(context) ? 3 : 10,
                      weight: FontWeight.w400,
                      color: ColorConstants.greyColor,
                    ),
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
