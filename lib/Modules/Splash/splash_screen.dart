import 'dart:async';
import 'dart:developer';

import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final RxBool showLogo = true.obs;

  final RxBool showLottie = false.obs;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = GetStorage().read('isLoggedIn') ?? false;
    log('login status : $isLoggedIn');
    Timer(const Duration(seconds: 3), () {
      showLogo.value = false;
      showLottie.value = true;

      Timer(const Duration(seconds: 3), () {
        if (isLoggedIn) {
          Get.offAllNamed(AppRoutes.navbarScreen);
        } else {
          Get.offAllNamed(AppRoutes.signInScreen);
        }
      });
    });
    return Scaffold(
      backgroundColor: ColorConstants.background,
      body: Center(
        child: Obx(
          () => showLogo.value
              ? Image.asset(
                  AssetConstant.splashLogo,
                  height: 20.h,
                  width: 50.w,
                )
              : showLottie.value
                  ? Lottie.asset(
                      AssetConstant.clothLottie,
                      height: 50.h,
                      width: 80.w,
                      // AssetConstant.tryLottie,
                    )
                  : const SizedBox(),
        ),
      ),
    );
  }
}
