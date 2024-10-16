import 'package:fashion/Modules/Auth/Widget/custom_text.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Homeweb extends StatefulWidget {
  const Homeweb({super.key});

  @override
  State<Homeweb> createState() => _HomewebState();
}

class _HomewebState extends State<Homeweb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            bottom: 6.5.h,
            top: 5.h,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Home',
                    color: ColorConstants.blackColor,
                    fontSize: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
