import 'dart:convert';

import 'package:http/http.dart' as http;

class ChatApiService {
  static const String baseUrl = 'http://192.168.78.153:8080/api/chat';

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
