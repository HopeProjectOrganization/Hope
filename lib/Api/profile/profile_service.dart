import 'dart:convert';

import 'package:hope/model/get_profile.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  // دالة تأخذ التوكن كوسيط
  Future<GetUserProfileData> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.48:8081/api/profile'),
      headers: {
        'Authorization': 'Bearer $token', // إرسال التوكن مع الهيدر
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      print("Response body: ${response.body}"); // طباعة الاستجابة الكاملة
      return GetUserProfileData.fromJson(json); // العودة بالبيانات
    } else {
      print(
          "Failed to load user profile: ${response.statusCode}"); // طباعة حالة الخطأ
      throw Exception('Failed to load user profile');
    }
  }
}
