
import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfileWidget extends StatelessWidget {
  final String? name;
  final IconData? icon;

  final Function()? onTap;

  const ProfileWidget({
    super.key,
    this.name,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: ColorConstants.whiteColor,
          height: 6.h,
          child: ListTile(
            contentPadding: EdgeInsets.only(
              left: 0.4.w,
              right: 0.4.w,
              // bottom: 0.5.h,
            ),
            onTap: onTap,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 29,
                  color: ColorConstants.rich,
                ),
                SizedBox(
                  width: 3.w,
                ),
                CustomText(
                  text: name!,
                  color: ColorConstants.blackColor,
                  fontSize: 14,
                  weight: FontWeight.w400,
                ),
              ],
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: ColorConstants.rich,
              size: 24,
            ),
          ),
        ),
        Divider(
          height: 1.h,
          thickness: 1,
          color: ColorConstants.background,
        ),
      ],
    );
  }
}
