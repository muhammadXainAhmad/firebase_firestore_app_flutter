import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("PERMISSION GRANTED!");
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("PROVISIONAL PERMISSION GRANTED!");
      }
    } else {
      if (kDebugMode) {
        print("PERMISSION DENIED!");
      }
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void onTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
       if (kDebugMode) {
        print("TOKEN REFRESHED!");
      }
    });
  }
}
