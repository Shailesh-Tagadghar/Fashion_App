import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FcmService {
  String? fcm_token = '';

  Future<void> initialize() async {
    try {
      fcm_token = kIsWeb
          ? 'Default_Fcm_Token'
          : await FirebaseMessaging.instance.getToken();
      GetStorage().write('fcm_token', fcm_token);
    } catch (e) {
      fcm_token = 'Default_Fcm_Token';
    }
  }
}
