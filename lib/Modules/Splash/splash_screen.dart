import 'dart:async';

import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  final RxBool showLogo = true.obs;
  final RxBool showLottie = false.obs;

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = GetStorage().read('isLoggedIn') ?? false;
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
              ? Image.asset(AssetConstant.splashLogo)
              : showLottie.value
                  ? Lottie.asset(
                      AssetConstant.clothLottie,
                      // AssetConstant.tryLottie,
                    )
                  : const SizedBox(),
        ),
      ),
    );
  }
}
