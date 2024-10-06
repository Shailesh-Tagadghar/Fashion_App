import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Home/controllers/home_controller.dart';
// import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CartItemWidget extends StatelessWidget {
  final String image;
  final String title;
  final String size;
  final String price;

  const CartItemWidget({
    super.key,
    required this.image,
    required this.title,
    required this.size,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    return Padding(
      padding: EdgeInsets.only(
        left: 2.w,
        right: 2.w,
        top: 1.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              // '${ApiConstants.imageBaseUrl}$image',
              image,
              width: 25.w,
              height: 12.h,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: 4.w,
          ),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 1.h,
                ),
                CustomText(
                  text: title,
                  fontSize: 13,
                  weight: FontWeight.w500,
                  color: ColorConstants.blackColor.withOpacity(0.8),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                CustomText(
                  text: "Size: $size",
                  fontSize: 12,
                  color: ColorConstants.greyColor,
                  weight: FontWeight.w400,
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "\$$price",
                      fontSize: 13,
                      weight: FontWeight.w500,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6.5.w,
                              height: 3.h,
                              decoration: const BoxDecoration(
                                color: ColorConstants.lightGrayColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: IconButton(
                                padding: const EdgeInsets.all(1),
                                icon: const Icon(
                                  Icons.remove,
                                  color: ColorConstants.blackColor,
                                  size: 18,
                                ),
                                onPressed: controller.decrement,
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Obx(
                              () => CustomText(
                                text: controller.quantity.value.toString(),
                                fontSize: 14,
                                color: ColorConstants.blackColor,
                                weight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Container(
                              width: 6.5.w,
                              height: 3.h,
                              decoration: const BoxDecoration(
                                color: ColorConstants.rich,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: IconButton(
                                padding: const EdgeInsets.all(1),
                                icon: const Icon(
                                  Icons.add,
                                  color: ColorConstants.whiteColor,
                                  size: 18,
                                ),
                                onPressed: controller.increment,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Counter Buttons
        ],
      ),
    );
  }
}
