import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationHandler {
  static Future sendNotification({
    required String fcmToken,
    required String message,
    bool isTopic = false,
  }) async {
    await http
        .post(
      Uri.https('fcm.googleapis.com', '/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAA1UAS1QE:APA91bH7zNOlj5Gq1hTK8-6mPNVdme5dDrwYjr_8M32B0nIsn7fBXrR0XngAkErQ1g26qE9nEEvy9GHc8A6WElXmoxd9KZVqAp6vDw_SarnTQYe3oOBWZXObHbM3WnOf5R0ePaoU4WEF',
      },
      body: jsonEncode({
        "notification": {
          "body": message,
          "title": "Anchor",
        },
        "data": {
          "number": 6,
        },
        "priority": "high",
        "to": isTopic ? "/topics/$fcmToken" : fcmToken
      }),
    )
        .then((value) {
      print(value.statusCode);
      print(value.body);
    });
  }
}
