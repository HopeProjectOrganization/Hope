import 'dart:convert';

import 'package:http/http.dart' as http;

extension ApiHelper on Uri {
  Future<bool> sendJsonPost(Map<String, dynamic> data) async {
    final response = await http.post(this,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> sendJsonPut(Map<String, dynamic> data) async {
    final response = await http.put(this,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    return response.statusCode == 200;
  }
}
