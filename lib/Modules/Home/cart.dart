import 'package:dotted_line/dotted_line.dart';
import 'package:fashion/Modules/Auth/Widget/custom_button.dart';
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Modules/Auth/services/api_service.dart';
import 'package:fashion/Modules/Home/Widget/cart_item_widget.dart';
import 'package:fashion/Modules/Home/controllers/data_contoller.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sizer/sizer.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final DataContoller dataContoller = Get.find<DataContoller>();

    dataContoller.fetchCarts();
    dataContoller.fetchCheckout();
    print('disssssssss ${dataContoller.discount.value}');
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.whiteColor,
        foregroundColor: ColorConstants.whiteColor,
        shadowColor: ColorConstants.whiteColor,
        surfaceTintColor: ColorConstants.whiteColor,
        toolbarHeight: 10.h,
        leadingWidth: 15.w,
        title: const CustomText(
          text: StringConstants.cart,
          weight: FontWeight.w500,
          fontSize: 13,
        ),
        centerTitle: true,
        leading: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
            left: 4.w,
          ),
          padding: EdgeInsets.all(
            0.6.w,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: ColorConstants.lightGrayColor, width: 1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            iconSize: 24,
            icon: const Icon(
              Bootstrap.arrow_left,
              color: ColorConstants.blackColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
      ),
      body: Obx(
        () {
          if (dataContoller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (dataContoller.cartsItems.isEmpty) {
            return const Center(
              child: CustomText(
                text: 'No cart data available',
                fontSize: 14,
                weight: FontWeight.w500,
              ),
            );
          }
          final products = dataContoller.cartsItems['product'] ?? [];

          return Padding(
            padding: EdgeInsets.only(
              left: 3.w,
              right: 3.w,
              bottom: 2.h,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final item = products[index];
                      final product = item['product_id'] ?? {};
                      final size = item['size'] ?? 'N/A';
                      final productName = product['name'] ?? 'Unknown Product';
                      final productPrice = product['price'] ?? 0;
                      final productImage = product['image']?.isNotEmpty == true
                          ? product['image'][0]
                          : AssetConstant.pd1; // Fallback image
                      print(
                          'Coupon Codtttttttte : ${dataContoller.selectedCoupon}');
                      return Dismissible(
                        key: Key(item.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: const Icon(Icons.delete,
                              color: Colors.white), // Delete icon
                        ),
                        confirmDismiss: (direction) async {
                          return await showDeleteBottomSheet(context, index);
                        },
                        onDismissed: (direction) {
                          // Remove the item from the list
                          dataContoller.cartsItems['product'].removeAt(index);
                          print(
                              'Data $productName Name remove from cart screen after remove cart...');
                        },
                        child: CartItemWidget(
                          image: productImage,
                          title: productName,
                          size: size,
                          price: productPrice.toString(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 10.h,
                  ),
                  child: CustomButton(
                    label: StringConstants.checkout,
                    btnColor: ColorConstants.rich,
                    labelColor: ColorConstants.whiteColor,
                    isSelected: true,
                    action: () {
                      showCheckout(context);
                    },
                    height: 6.h,
                    fontSize: 14,
                    weight: FontWeight.w500,
                    width: 85.w,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool> showDeleteBottomSheet(BuildContext context, int index) async {
    final DataContoller dataContoller = Get.put(DataContoller());
    final carts = dataContoller.cartsItems;

    final removeProduct = carts['product'][index]['_id'];
    final products = carts['product'] ?? [];
    // final product = products[index]['product_id'] ?? {};
    // final size = products[index]['size'] ?? 'N/A';
    // final productName = product['name'] ?? 'Unknown Product';
    // final productPrice = product['price'] ?? 0;
    // final productImage = product['image']?.isNotEmpty == true
    //     ? product['image'][0]
    //     : AssetConstant.pd1; // Fallback image
    final item = products[index];
    final product = item['product_id'] ?? {};
    final size = item['size'] ?? 'N/A';
    final productName = product['name'] ?? 'Unknown Product';
    final productPrice = product['price'] ?? 0;
    final productImage = product['image']?.isNotEmpty == true
        ? product['image'][0]
        : AssetConstant.pd1; // Fallback image

    return await Get.bottomSheet(
          Container(
            height: 36.h,
            width: 100.w,
            padding: EdgeInsets.only(
              top: 1.5.h,
              bottom: 4.h,
              left: 2.w,
              right: 2.w,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const CustomText(
                  // StringConstants.profileHead1LogoutTxt,
                  text: StringConstants.removeFromCart,
                  fontSize: 16,
                  weight: FontWeight.w500,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Divider(
                  color: ColorConstants.background,
                  height: 1.h,
                  thickness: 2,
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                CartItemWidget(
                  image: productImage,
                  title: productName,
                  size: size,
                  price: productPrice.toString(),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 42.w,
                      child: CustomButton(
                        height: 6.h,
                        label: StringConstants.cancel,
                        action: () => Get.back(),
                        btnColor: ColorConstants.rich,
                        isSelected: true,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    SizedBox(
                      width: 42.w,
                      child: CustomButton(
                        height: 6.h,
                        label: StringConstants.remove,
                        isSelected: true,
                        action: () {
                          print('Product Cart id for remove : $removeProduct');

                          ApiService.removeProduct(removeProduct);
                          dataContoller.cartsItems.remove(index);
                          Get.back(result: true);
                        },
                        fontSize: 14,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          isDismissible: true,
        ) ??
        false;
  }

  void showCheckout(BuildContext context) {
    // final homeController = Get.find<HomeController>();
    final DataContoller dataController = Get.find<DataContoller>();
    dataController.fetchCheckout();

    showModalBottomSheet(
      context: context,
      backgroundColor: ColorConstants.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        dataController.isAppliedDone.value = false;
        return Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            bottom: 4.h,
            top: 3.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 1.w,
                        right: 1.w,
                      ),
                      child: Obx(
                        () => TextField(
                          controller: TextEditingController(
                              text: dataController.selectedCoupon.value),
                          readOnly: true,
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(
                                right: 1.5.w,
                                top: 0.5.h,
                                bottom: 0.5.h,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  dataController.selectedCoupon.value.isNotEmpty
                                      ? dataController.isAppliedDone.value ==
                                              true
                                          ? () {}
                                          : dataController.verifyCoupon()
                                      : Get.toNamed(AppRoutes.couponScreen);
                                },
                                child: Obx(() => CustomButton(
                                      label: StringConstants.apply,
                                      isSelected: true,
                                      labelColor: ColorConstants.whiteColor,
                                      btnColor:
                                          dataController.isAppliedDone.value ==
                                                  true
                                              ? ColorConstants.greyColor
                                              : ColorConstants.rich,
                                      height: 4.5.h,
                                      width: 25.w,
                                      weight: FontWeight.w400,
                                    )),
                              ),
                            ),
                            hintText: StringConstants.promo,
                            hintStyle: const TextStyle(
                              color: ColorConstants.greyColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: const BorderSide(
                                color: ColorConstants.background,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: const BorderSide(
                                color: ColorConstants.background,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: const BorderSide(
                                color: ColorConstants.background,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: StringConstants.subtotal,
                          color: ColorConstants.greyColor,
                          fontSize: 12,
                          weight: FontWeight.w400,
                        ),
                        Obx(
                          () => CustomText(
                            text:
                                '\$${dataController.subtotal.value.toStringAsFixed(2)}',
                            color: ColorConstants.blackColor,
                            fontSize: 12,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: StringConstants.delivery,
                          color: ColorConstants.greyColor,
                          fontSize: 12,
                          weight: FontWeight.w400,
                        ),
                        Obx(
                          () => CustomText(
                            text:
                                '\$${dataController.deliveryFee.value.toStringAsFixed(2)}',
                            color: ColorConstants.blackColor,
                            fontSize: 12,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: StringConstants.discount,
                          color: ColorConstants.greyColor,
                          fontSize: 12,
                          weight: FontWeight.w400,
                        ),
                        Obx(
                          () => CustomText(
                            text:
                                '-\$${dataController.discount.value > 0 ? dataController.discount.value.toStringAsFixed(2) : '0.00'}',
                            color: ColorConstants.blackColor,
                            fontSize: 12,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    DottedLine(
                      dashColor: ColorConstants.lightGrayColor,
                      lineThickness: 1,
                      dashGapColor: ColorConstants.whiteColor,
                      dashGapLength: 2.w,
                      dashLength: 2.w,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: StringConstants.total,
                          color: ColorConstants.greyColor,
                          fontSize: 12,
                          weight: FontWeight.w400,
                        ),
                        Obx(
                          () => CustomText(
                            text:
                                '\$${(dataController.total.value).toStringAsFixed(2)}',
                            color: ColorConstants.blackColor,
                            fontSize: 12,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    CustomButton(
                      label: StringConstants.checkoutbtn,
                      btnColor: ColorConstants.rich,
                      isSelected: true,
                      height: 6.h,
                      weight: FontWeight.w400,
                      action: () async {
                        await dataController.checkout();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
