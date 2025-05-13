import 'dart:convert';

import 'package:hope/main.dart';
import 'package:http/http.dart' as http;

class ChatApiService {
  static String baseUrl = 'http://${MyApp.IP}/api/chat';

  static Future<String> sendPrompt(String prompt) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'role': 'user',
        'content': prompt,
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('فشل الاتصال بالخادم المحلي');
    }
  }
}
