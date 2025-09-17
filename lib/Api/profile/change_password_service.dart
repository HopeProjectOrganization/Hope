import 'dart:convert';

import 'package:hope/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordService {
  static Future<String?> resetPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final token = await _getToken();

    if (token == null) {
      return null;
    }

    final url = Uri.parse("${MyApp.IP}/api/profile");

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return data['message'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
