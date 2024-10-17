import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GetStorage _storage = GetStorage();
  String? fcmToken = '';

  Future<void> initialize() async {
    try {
      if (kIsWeb) {
        // Web-specific initialization
        fcmToken = await _initializeForWeb();
      } else {
        // Mobile (iOS/Android) initialization
        fcmToken = await _initializeForMobile();
      }
      if (fcmToken != null) {
        _storage.write('fcm_token', fcmToken);
        log("FCM Token: $fcmToken");
      } else {
        log("Failed to get FCM Token");
      }
    } catch (e) {
      log('Error initializing FCM: $e');
      fcmToken = 'Default_Fcm_Token'; // Use a default token in case of an error
      _storage.write('fcm_token', fcmToken);
    }
  }

  // Initialize FCM for mobile (iOS/Android)
  Future<String?> _initializeForMobile() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission for FCM on mobile');
      return await _firebaseMessaging.getToken();
    } else {
      log('User declined or has not accepted FCM permission on mobile');
      return null;
    }
  }

  // Initialize FCM for web
  Future<String?> _initializeForWeb() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission for FCM on web');
      return await _firebaseMessaging.getToken(vapidKey: "YOUR_VAPID_KEY");
    } else {
      log('User declined or has not accepted FCM permission on web');
      return null;
    }
  }
}
