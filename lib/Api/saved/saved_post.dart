import 'dart:convert';

import 'package:hope/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SavedPost {
  static Future<bool> addToSaved({
    required int postId,
    required String postType,
  }) async {
    final url = Uri.parse('http://${MyApp.IP}/api/favorites/add');

    // جلب التوكن من SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      print('No token found!');
      return false; // أو ممكن ترجعي رسالة للمستخدم
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'postType': postType,
        'postId': postId,
      }),
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response.statusCode == 200;
  }
}
