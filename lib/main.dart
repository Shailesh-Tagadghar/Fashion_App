import 'package:fashion/Controllers/global_controller_binding.dart';
import 'package:fashion/Modules/Auth/services/fcm_service.dart';
import 'package:fashion/Routes/app_pages.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:fashion/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmService = FcmService();
  await fcmService.initialize();
  await GetStorage.init();

  runApp(const FashionApp());
}

class FashionApp extends StatelessWidget {
  const FashionApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (
        context,
        orientation,
        deviceType,
      ) {
        return GetMaterialApp(
          title: StringConstants.projectText,
          debugShowCheckedModeBanner: false,
          initialBinding: GlobalControllerBindings(),
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
