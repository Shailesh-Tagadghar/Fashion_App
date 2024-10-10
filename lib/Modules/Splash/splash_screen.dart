import 'dart:async';

import 'package:fashion/Modules/Auth/sign_in.dart';
import 'package:fashion/Modules/Home/navbar.dart';
import 'package:fashion/Routes/app_routes.dart';
import 'package:fashion/Utils/Constants/asset_constant.dart';
import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final RxBool showLogo = true.obs;
  final RxBool showLottie = false.obs;
  String? finalEmail;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    getValidationData().whenComplete(() async {
      //  Timer(const Duration(seconds: 3), () => Get.to(finalEmail == null ? LoginView(): MyHomePage()));
      Timer(const Duration(seconds: 3),
          () => Get.to(finalEmail == null ? SignIn() : const Navbar()));
    });
    showLogo.value = false;
    showLottie.value = true;

    Timer(const Duration(seconds: 3), () {
      final userData = storage.read('user_data');
      print('uuuuuuuuuuuuuuuuuuu ${userData}');
      if (userData != null) {
        Get.offAllNamed(AppRoutes.navbarScreen);
      } else {
        Get.offAllNamed(AppRoutes.signInScreen);
      }
    });
    ;
    // Fetch shared preferences data
    getValidationData();
  }

  Future<void> getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      finalEmail = obtainedEmail;
    });
    print(finalEmail);
  }

  @override
  Widget build(BuildContext context) {
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
