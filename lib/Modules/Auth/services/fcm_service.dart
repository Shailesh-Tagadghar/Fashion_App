import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FcmService {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // final GetStorage _storage = GetStorage();
  String? fcm_token = '';

  Future<void> initialize() async {
    //   String? token = await _firebaseMessaging.getToken();

    //   if (token != null) {
    //     _storage.write('fcm_token', token);
    //     log("FCM Token: $token");
    //   } else {
    //     log("Failed to get FCM Token");
    //   }
    // }

    try {
      fcm_token = kIsWeb
          ? 'Default_Fcm_Token'
          : await FirebaseMessaging.instance.getToken();
      GetStorage().write('fcm_token', fcm_token);
    } catch (e) {
      fcm_token = 'Default_Fcm_Token';
    }
  }

// try {
//       fcm_token = kIsWeb
//           ? 'Default_Fcm_Token'
//           : await FirebaseMessaging.instance.getToken();
//       GetStorage().write('fcm_token', fcm_token);
//     } catch (e) {
//       fcm_token = 'Default_Fcm_Token';
//     }
}
