import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/ui/screens/home/home.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String _apiUrl =
      'http://192.168.1.58:8081/api/v1/auth/authenticate';

  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    try {
      showLoading(context); // عرض الديالوج
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      hideLoading(context); // إخفاء الديالوج عند الانتهاء

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final token = data['token'];
        print("TOKEEEEEEEEN : $token");

        if (token != null) {
          await storeToken(token); // تخزين التوكن في SharedPreferences
          Navigator.pushNamed(
              context, HomeScreen.routeName); // الانتقال للصفحة الرئيسية
          print('Login successful: $token');
        } else {
          showMessage(context, "Token not found in response");
        }
      } else {
        showMessage(context, "Email or password may be incorrect");
      }
    } catch (e) {
      print('Error during login: $e');
      showMessage(context, "An error occurred during login: $e");
    }
  }

  // دالة لتخزين التوكن في SharedPreferences
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print('Token stored: $token');
  }

  // دالة لجلب التوكن من SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}

