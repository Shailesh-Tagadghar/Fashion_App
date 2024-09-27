
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomRichText extends StatelessWidget {
  final String? text;
  final String? linktext;
  final void Function()? onTap;
  final TextStyle? linktextStyle;
  final Color? color;
  final double fontSize;
  final FontWeight? weight;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final double? underlineGap;

  const CustomRichText({
    super.key,
    this.linktext,
    this.text,
    this.onTap,
    this.linktextStyle,
    this.color,
    this.fontSize = 14,
    this.weight,
    this.textAlign,
    this.decoration,
    this.underlineGap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: text,
            style: TextStyle(
              color: color ?? ColorConstants.blackColor,
              fontSize: fontSize.sp,
              fontWeight: weight ?? FontWeight.bold,
            ),
          ),
          TextSpan(
            text: linktext,
            style: linktextStyle ??
                TextStyle(
                  color: ColorConstants.rich,
                  fontSize: fontSize.sp,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
