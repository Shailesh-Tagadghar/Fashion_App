import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double fontSize;
  final FontWeight? weight;
  final TextAlign? textAlign;
  final TextDecoration? decoration;

  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontSize = 14,
    this.weight,
    this.textAlign,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? ColorConstants.blackColor,
        fontSize: fontSize.sp,
        fontWeight: weight ?? FontWeight.bold,
        decoration: decoration ?? TextDecoration.none,
        decorationColor: ColorConstants.rich,
      ),
      textAlign: textAlign,
    );
  }
}
