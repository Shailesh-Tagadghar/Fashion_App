import 'package:fashion/Modules/Auth/controllers/auth_controller.dart';
import 'package:fashion/Modules/Auth/services/fcm_service.dart';
import 'package:fashion/Modules/Home/controllers/data_contoller.dart';
import 'package:fashion/Modules/Home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'network_connectivity_controller.dart';

///
/// Initial Controller Binding
///
class GlobalControllerBindings extends Bindings {
  @override
  void dependencies() {
    // login controller initialisation
    Get.put(
      NetworkConnectivityController(),
    );

    Get.put(
      AuthController(),
    );
    Get.put(
      HomeController(),
    );
    Get.put(
      PageController(),
    );
    Get.put(
      DataContoller(),
    );
    Get.put(
      FcmService(),
    );
  }
}
