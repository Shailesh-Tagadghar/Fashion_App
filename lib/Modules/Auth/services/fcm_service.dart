import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GetStorage _storage = GetStorage();

  Future<void> initialize() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      _storage.write('fcm_token', token);
      print("FCM Token: $token");
    } else {
      print("Failed to get FCM Token");
    }
  }
}
