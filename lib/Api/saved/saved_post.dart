import 'dart:convert';

import 'package:hope/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SavedPost {
  static Future<bool> addToSaved({
    required int postId,
    required String postStringId,
    required String postType,
  }) async {
    final url = Uri.parse('http://${MyApp.IP}/api/favorites/add');

    // جلب التوكن من SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token =
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJiYXNzZWxAZ21haWwuY29tIiwiaWF0IjoxNzQ5NzkzMzUxLCJleHAiOjE3NTAwNTI1NTF9.OAhDIPGIdU31mvKwCnjwXoQznIN764SC-q_LnIsAOOQ';
    //prefs.getString('auth_token');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // ضيف التوكن الصحيح
      },
      body: jsonEncode({
        "postId": postId,
        "postStringId": postStringId,
        "postType": postType,
      }),
    );

    return response.statusCode == 200;
  }
}