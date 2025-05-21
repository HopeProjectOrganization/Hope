import 'dart:convert';

import 'package:hope/main.dart';
import 'package:http/http.dart' as http;

Future<void> submitUserMeals({
  required int userId,
  required String category,
  required List<String> mealIds,
}) async {
  final url = Uri.parse('http://${MyApp.IP}/api/user-meals');

  final now = DateTime.now();
  final body = {
    'userId': userId,
    'dateTime': now.toIso8601String(),
    'category': category.toLowerCase(),
    'mealIds': mealIds,
  };

  print('🚀 Sending request to: $url');
  print('📦 Payload: $body');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(body),
  );

  print('📨 Response status: ${response.statusCode}');
  print('📨 Response body: "${response.body}"');

  if (response.statusCode == 200 || response.statusCode == 201) {
    if (response.body.isNotEmpty) {
      try {
        final data = json.decode(response.body);
        print('📦 Response JSON parsed: $data');
      } catch (e) {
        print('⚠️ Warning: response body is not valid JSON: $e');
      }
    } else {
      print('ℹ️ Response body is empty');
    }
    print('✅ Meals submitted successfully');
  } else {
    print('❌ Failed to submit meals: ${response.statusCode}');
    throw Exception('API submission failed');
  }
}
