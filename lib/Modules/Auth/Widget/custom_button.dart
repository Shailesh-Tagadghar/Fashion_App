
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final void Function()? action;
  final Color? btnColor, labelColor;
  final double? width;
  final FontWeight? weight;
  final double fontSize;
  final double? height;
  final bool isSelected;

  const CustomButton({
    super.key,
    required this.label,
    this.action,
    this.btnColor,
    this.labelColor,
    this.weight,
    this.fontSize = 14,
    this.width,
    this.height,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Get.height,
      width: width ?? Get.width,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            isSelected
                ? ColorConstants.rich
                : (btnColor ?? ColorConstants.rich),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: BorderSide(
                color: isSelected
                    ? ColorConstants.rich
                    : ColorConstants
                        .lightGrayColor, // Border color for non-selected buttons
                width: 1,
              ),
            ),
          ),
        ),
        onPressed: action,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                fontSize: fontSize.sp,
                fontWeight: weight ?? FontWeight.bold,
                color: isSelected
                    ? ColorConstants.whiteColor
                    : ColorConstants.blackColor),
          ),
        ),
      ),
    );
  }
}
