import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Modules/Home/controllers/data_contoller.dart';
import 'package:fashion/Modules/Home/controllers/home_controller.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
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
    final dataContoller = Get.find<DataContoller>();
    final homeController = Get.find<HomeController>();
    return Padding(
      padding: EdgeInsets.only(
        left: 1.5.w,
        right: 1.5.w,
        top: 0.2.h,
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
                    left: 4.w,
                    right: 4.w,
                    top: 2.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        // text: StringConstants.welcome,
                        text: title,
                        fontSize: 14,
                        color: ColorConstants.blackColor,
                        weight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      CustomText(
                        text: descreption,
                        fontSize: 12.5,
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
                            fontSize: 14,
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
                  onTap: () async {
                    homeController.setCoupon(title);
                    print('Coupon Value : $title');
                    // Call the verifyCoupon method and await the response
                    var couponResponse = await ApiService().verifyCoupon(
                      homeController.selectedCoupon.value.toString(),
                      dataContoller.subtotal.value.toInt(),
                      dataContoller.discount.value.toInt(),
                      dataContoller.deliveryFee.value.toInt(),
                    );

                    // Update the checkout data in the controller
                    if (couponResponse != null) {
                      switch (couponResponse.status) {
                        case 200:
                          dataContoller
                              .updateCheckoutData(couponResponse.data!);
                          print(
                              'Checkout data updated with coupon: ${couponResponse.data}');
                          print(
                              'Coupon applied successfully: Enjoy Discount of ${couponResponse.data!.discount} INR!');
                          break;
                        case 400:
                          print(
                              'Invalid coupon: ${couponResponse.message ?? "Coupon does not meet criteria."}');
                          break;
                        case 404:
                          print(
                              'Coupon not found: ${couponResponse.message ?? "No coupon found."}');
                          break;
                        case 500:
                          print(
                              'Server error: ${couponResponse.message ?? "Please try again later."}');
                          break;
                        default:
                          print(
                              'Unexpected error: ${couponResponse.message ?? "An error occurred."}');
                      }
                    } else {
                      print('Error: couponResponse is null.');
                    }
                    Get.back();
                  },
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    height: 6.h,
                    width: 100.w,
                    decoration: const BoxDecoration(
                      color: ColorConstants.background,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: CustomText(
                      text: copy,
                      fontSize: 16,
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
