import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomField extends StatelessWidget {
  final String? hintText;
  final Color? hintTextColor;
  final double fontSize;
  final TextInputType keyboardType;
  final bool obscureText;
  final String obscuringCharacter;
  final bool showPasswordIcon;
  final VoidCallback? onIconPressed;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isDropdown;
  final List<String>? genderdropdown;
  final bool isPhoneNumber;
  final String? selectedCountryCode;
  final Function(String)? onCountryCodeChanged;
  final List<String>? countryCodes;
  final bool readonly;

  const CustomField({
    super.key,
    this.hintText,
    this.fontSize = 14,
    this.hintTextColor = ColorConstants.greyColor,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.obscuringCharacter = '*',
    this.showPasswordIcon = false,
    this.onIconPressed,
    this.controller,
    this.onChanged,
    this.isDropdown = false,
    this.genderdropdown,
    this.isPhoneNumber = false,
    this.selectedCountryCode,
    this.onCountryCodeChanged,
    this.countryCodes,
    this.readonly = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isDropdown && genderdropdown != null) {
      return DropdownButtonFormField<String>(
        dropdownColor: ColorConstants.whiteColor,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: ColorConstants.lightGrayColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: ColorConstants.lightGrayColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: ColorConstants.errorColor,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintTextColor,
            fontSize: kIsWeb ? 4 : 14,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
        items: genderdropdown!.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          if (onChanged != null) {
            onChanged!(newValue!);
          }
        },
        value: controller?.text.isNotEmpty ?? false ? controller?.text : null,
      );
    } else if (isPhoneNumber) {
      return TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 8.0,
            ),
            child: DropdownButton<String>(
              value: selectedCountryCode,
              dropdownColor: ColorConstants.whiteColor,
              items: countryCodes?.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                onCountryCodeChanged!(newValue!);
              },
              underline: const SizedBox(),
              // Remove the dropdown underline
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: ColorConstants.lightGrayColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: ColorConstants.lightGrayColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: ColorConstants.errorColor,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintTextColor,
            fontSize: kIsWeb ? 4 : 14,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
        onChanged: onChanged,
      );
    } else {
      return TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter,
        controller: controller,
        onChanged: onChanged,
        enabled: readonly,
        style: TextStyle(
          color: ColorConstants.blackColor,
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w400,
        ),
        // cursorRadius: const Radius.circular(8),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: kIsWeb ? 2.w : 4.w,
            right: kIsWeb ? 2.w : 4.w,
            bottom: 1.h,
            top: 1.h,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintTextColor,
            fontSize: fontSize.sp,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: showPasswordIcon
              ? IconButton(
                  icon: Icon(
                    // obscureText ? Icons.visibility_off : Icons.visibility,
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: onIconPressed,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: ColorConstants.lightGrayColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: ColorConstants.lightGrayColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: ColorConstants.lightGrayColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: ColorConstants.errorColor,
            ),
          ),
        ),
      );
    }
  }
}
