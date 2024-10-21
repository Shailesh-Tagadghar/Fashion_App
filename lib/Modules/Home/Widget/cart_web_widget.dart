import 'dart:developer';

import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Modules/Home/controllers/data_contoller.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/api_constants.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CartWebWidget extends StatefulWidget {
  final String image;
  final String title;
  final String size;
  final String price;
  final String? cartIdP;
  final RxInt quantity;

  const CartWebWidget({
    super.key,
    required this.image,
    required this.title,
    required this.size,
    required this.price,
    required this.quantity,
    this.cartIdP,
  });

  @override
  State<CartWebWidget> createState() => _CartWebWidgetState();
}

class _CartWebWidgetState extends State<CartWebWidget> {
  @override
  Widget build(BuildContext context) {
    final DataContoller dataContoller = Get.find<DataContoller>();
    final products = dataContoller.cartsItems['product'] ?? [];

    // final products = carts['product'] ?? [];

    final removeProduct = products.firstWhere(
        (element) => element['_id'] == widget.cartIdP,
        orElse: () => null)?['_id'];

    return Padding(
      padding: EdgeInsets.only(
        top: Responsive.isDesktop(context) ? 4.h : 2.h,
        left: Responsive.isDesktop(context) ? 4.w : 4.w,
        right: Responsive.isDesktop(context) ? 4.w : 4.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          FittedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                '${ApiConstants.imageBaseUrl}${widget.image}',
                // image,
                width: Responsive.isDesktop(context)
                    ? 8.w
                    : Responsive.isTablet(context)
                        ? 6.w
                        : 4.w,
                height: Responsive.isDesktop(context)
                    ? 8.h
                    : Responsive.isTablet(context)
                        ? 6.h
                        : 4.h,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            width: Responsive.isDesktop(context)
                ? 2.w
                : Responsive.isTablet(context)
                    ? 2.w
                    : 2.w,
          ),
          //title
          FittedBox(
            child: CustomText(
              text: widget.title,
              fontSize: Responsive.isDesktop(context)
                  ? 3
                  : Responsive.isTablet(context)
                      ? 3
                      : 3,
              weight: FontWeight.w500,
              color: ColorConstants.blackColor.withOpacity(0.8),
            ),
          ),
          SizedBox(
            width: Responsive.isDesktop(context)
                ? 2.w
                : Responsive.isTablet(context)
                    ? 2.w
                    : 2.w,
          ),
          //price
          FittedBox(
            child: Column(
              children: [
                FittedBox(
                  child: CustomText(
                    text: "price",
                    fontSize: Responsive.isDesktop(context)
                        ? 3
                        : Responsive.isTablet(context)
                            ? 3
                            : 3,
                    weight: FontWeight.w500,
                    color: ColorConstants.blackColor.withOpacity(0.8),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                FittedBox(
                  child: CustomText(
                    text: "\$${widget.price}",
                    fontSize: Responsive.isDesktop(context)
                        ? 3
                        : Responsive.isTablet(context)
                            ? 3
                            : 3,
                    weight: FontWeight.w500,
                    color: ColorConstants.blackColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: Responsive.isDesktop(context)
                ? 2.w
                : Responsive.isTablet(context)
                    ? 2.w
                    : 2.w,
          ),

          //increment // decrement
          Column(
            children: [
              Row(
                children: [
                  Container(
                    width: Responsive.isDesktop(context)
                        ? 1.2.w
                        : Responsive.isTablet(context)
                            ? 1.2.w
                            : 1.2.w,
                    height: Responsive.isDesktop(context)
                        ? 3.h
                        : Responsive.isTablet(context)
                            ? 3.h
                            : 3.h,
                    decoration: const BoxDecoration(
                      color: ColorConstants.lightGrayColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(1),
                      icon: Icon(
                        Icons.remove,
                        color: ColorConstants.blackColor,
                        size: Responsive.isDesktop(context)
                            ? 14
                            : Responsive.isTablet(context)
                                ? 12
                                : 10,
                      ),
                      // onPressed: controller.decrement,
                      onPressed: () {
                        if (widget.quantity.value > 1) {
                          widget.quantity.value -= 1; // Decrease quantity
                          ApiService().addQuantity(
                              widget.quantity.value, widget.cartIdP ?? '');
                        }
                        dataContoller.fetchCheckout();
                        Get.toNamed(AppRoutes.cartwebScreen);
                      },
                    ),
                  ),
                  SizedBox(
                    width: Responsive.isDesktop(context)
                        ? 0.5.w
                        : Responsive.isTablet(context)
                            ? 0.5.w
                            : 0.5.w,
                  ),
                  Obx(
                    () => FittedBox(
                      child: CustomText(
                        // text: controller.quantity.value.toString(),
                        text: widget.quantity.value.toString(),
                        fontSize: Responsive.isDesktop(context)
                            ? 3
                            : Responsive.isTablet(context)
                                ? 3
                                : 3,
                        color: ColorConstants.blackColor,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Responsive.isDesktop(context)
                        ? 0.5.w
                        : Responsive.isTablet(context)
                            ? 0.5.w
                            : 0.5.w,
                  ),
                  Container(
                    width: Responsive.isDesktop(context)
                        ? 1.2.w
                        : Responsive.isTablet(context)
                            ? 1.2.w
                            : 1.2.w,
                    height: Responsive.isDesktop(context)
                        ? 3.h
                        : Responsive.isTablet(context)
                            ? 3.h
                            : 3.h,
                    decoration: const BoxDecoration(
                      color: ColorConstants.rich,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(1),
                      icon: Icon(
                        Icons.add,
                        color: ColorConstants.whiteColor,
                        size: Responsive.isDesktop(context)
                            ? 14
                            : Responsive.isTablet(context)
                                ? 12
                                : 10,
                      ),
                      // onPressed: controller.increment,
                      onPressed: () {
                        widget.quantity.value += 1; // Increase quantity
                        ApiService().addQuantity(
                            widget.quantity.value, widget.cartIdP ?? '');
                        dataContoller.fetchCheckout();
                        Get.toNamed(AppRoutes.cartwebScreen);
                        log('on tap increase cart id in cart screen : ${widget.cartIdP}');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(
            width: Responsive.isDesktop(context)
                ? 2.w
                : Responsive.isTablet(context)
                    ? 2.w
                    : 2.w,
          ),
          //total
          FittedBox(
            child: Column(
              children: [
                FittedBox(
                  child: CustomText(
                    text: "Total",
                    fontSize: Responsive.isDesktop(context)
                        ? 3
                        : Responsive.isTablet(context)
                            ? 3
                            : 3,
                    weight: FontWeight.w500,
                    color: ColorConstants.blackColor.withOpacity(0.8),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                FittedBox(
                  child: CustomText(
                    text: "\$${widget.price}",
                    fontSize: Responsive.isDesktop(context)
                        ? 3
                        : Responsive.isTablet(context)
                            ? 3
                            : 3,
                    weight: FontWeight.w500,
                    color: ColorConstants.blackColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: Responsive.isDesktop(context)
                ? 2.w
                : Responsive.isTablet(context)
                    ? 2.w
                    : 2.w,
          ),
          //remove
          Column(
            children: [
              FittedBox(
                child: CustomText(
                  text: "Action",
                  fontSize: Responsive.isDesktop(context)
                      ? 3
                      : Responsive.isTablet(context)
                          ? 3
                          : 3,
                  weight: FontWeight.w500,
                  color: ColorConstants.blackColor.withOpacity(0.8),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              FittedBox(
                child: GestureDetector(
                  onTap: () {
                    // async {
                    //   try {
                    //     log('Product Cart id for remove : $removeProduct');

                    //     // Call the API to remove the product
                    //     await ApiService.removeProduct(removeProduct);
                    //     // Remove the item from the cartsItems map
                    //     dataContoller.cartsItems.removeWhere((key, value) =>
                    //         value['_id'].toString() == removeProduct.toString());

                    //     await dataContoller.fetchCarts();

                    //     Get.toNamed(AppRoutes.cartwebScreen);

                    //     log('Product successfully removed.');
                    //   } catch (e) {
                    //     log('Error removing product: $e');
                    //   }
                    //   Get.toNamed(AppRoutes.cartwebScreen);
                    ApiService.removeProduct(removeProduct);
                    Get.toNamed(AppRoutes.cartwebScreen);
                    setState(() {});
                  },
                  child: CustomText(
                    decoration: TextDecoration.underline,
                    text: "Remove",
                    fontSize: Responsive.isDesktop(context)
                        ? 3
                        : Responsive.isTablet(context)
                            ? 3
                            : 3,
                    weight: FontWeight.w500,
                    color: ColorConstants.rich.withOpacity(0.8),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
