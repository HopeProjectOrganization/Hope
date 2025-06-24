import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/notification_dm.dart';
import 'package:http/http.dart' as http;

class NotificationApiService {
  final String baseUrl = 'https://${MyApp.IP}/api/notify';

  // إرسال إشعار لمستخدم بناءً على التوكن
  Future<void> sendToToken(NotificationModel notification) async {
    final response = await http.post(
      Uri.parse('$baseUrl/token'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(notification.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل في إرسال الإشعار للمستخدم');
    }
  }

  // إرسال إشعار لمجموعة بناءً على التوبك
  Future<void> sendToTopic(NotificationModel notification) async {
    final response = await http.post(
      Uri.parse('$baseUrl/topic'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(notification.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل في إرسال الإشعار للتوبك');
    }
  }

  // إرسال إشعار لكل المستخدمين
  Future<void> sendToAll(NotificationModel notification) async {
    final response = await http.post(
      Uri.parse('$baseUrl/all'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(notification.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل في إرسال الإشعار للجميع');
    }
  }
}
