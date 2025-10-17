import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FcmService {
  Future<AccessCredentials> accessServerKey() async {
    final serviceAccountPath = dotenv.env['PATH_TO_KEY'];
    String serviceAccountJson = await rootBundle.loadString(
      serviceAccountPath!,
    );
    final serviceAccount = ServiceAccountCredentials.fromJson(
      serviceAccountJson,
    );
    if (kDebugMode) {
      print("json: $serviceAccountJson");
    }

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = await clientViaServiceAccount(serviceAccount, scopes);
    return client.credentials;
  }

  Future<bool> sendPushNotification({
    required String deviceToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    if (deviceToken.isEmpty) return false;

    final credentials = await accessServerKey();
    final accessToken = credentials.accessToken.data;
    final projectId = dotenv.env['PROJECT_ID'];

    if (kDebugMode) {
      print("accessToken: ${dotenv.env['PROJECT_ID']}");
    }

    final url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
    );

    final message = {
      'message': {
        'token': deviceToken,
        'notification': {'title': title, 'body': body},
        'data': data ?? {},
      },
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Notification Successfully Sent!');
      }
      return true;
    } else {
      if (kDebugMode) {
        print('Failed to Send Notification: ${response.body}');
      }
      return false;
    }
  }
}
