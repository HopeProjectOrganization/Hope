import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Api/add/add_service.dart';
import 'package:hope/ui/screens/home/home.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String _apiUrl =
      'http://192.168.1.45:8081/api/v1/auth/authenticate';

  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    try {
      showLoading(context);
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

      hideLoading(context);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final token = data['token'];

        await AddService().storeToken(token);

        Navigator.pushNamed(context, HomeScreen.routeName);
        print('Login successful: $token');
      } else {
        _showError(context, "Email or password may be incorrect");
      }
    } catch (e) {
      print('Error during login: $e');
      _showError(context, "An error occurred during login");
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red),
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.pushNamedAndRemoveUntil(
        context, '/', (route) => false); // العودة لصفحة البداية
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
