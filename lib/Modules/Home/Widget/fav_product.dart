import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FavProduct extends StatelessWidget {
  final dynamic product; // Pass the product data
  final bool isFavorite; // To show the favorite icon
  final VoidCallback onFavoriteToggle; // Function to toggle favorite

  const FavProduct({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
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
                  '${ApiConstants.imageBaseUrl}${product['product_id']['image'][0]}',
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
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_outline_outlined,
                    color: ColorConstants.primary,
                  ),
                  onPressed: () async {
                    onFavoriteToggle();
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 0.8.h,
          ),
          CustomText(
            text: product['product_id']['name'],
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
                text: '\$${product['product_id']['price'].toString()}',
                // text: '\$${product['price'].toString()}',
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
                    // text: product['rating'].toString(),
                    text: product['product_id']['rating'].toString(),
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
