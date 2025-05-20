import 'dart:convert';

import 'package:hope/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SavedPost {
  static Future<bool> addToSaved({
    required double postId,
    required String postType,
  }) async {
    final url = Uri.parse('http://${MyApp.IP}/api/favorites/add');

    // جلب التوكن من SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token =
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJiYXNzZWxAZ21haWwuY29tIiwiaWF0IjoxNzQ3NzU0MjQwLCJleHAiOjE3NDgwMTM0NDB9.gVmNo8BoXmIdmvqeR7ytioNZep8MR5hHqhTZ_UtAo8Y';
    //prefs.getString('auth_token');

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
    print("THE ARTICLE ID IS ${postId}}");
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response.statusCode == 200;
  }
}
