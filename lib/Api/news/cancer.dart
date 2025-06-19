import 'dart:convert';

import 'package:hope/model/article.dart';
import 'package:http/http.dart' as http;

class CancerNewsApi {
  static const String _baseUrl = 'https://newsdata.io/api/1/latest';
  static const String _apiKey = 'pub_42fd66850d184b9c9713caa53c843764';

  static Future<List<Article>> fetchNews(String cancerType) async {
    final uri = Uri.parse('$_baseUrl?apikey=$_apiKey'
        '&q=${Uri.encodeComponent('$cancerType cancer')}'
        '&category=health,science,food,technology,environment&language=en');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        final List<dynamic> results = data['results'];
        return results.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('API returned failure: ${data['status']}');
      }
    } else {
      throw Exception('Failed to fetch news: ${response.statusCode}');
    }
  }
}
