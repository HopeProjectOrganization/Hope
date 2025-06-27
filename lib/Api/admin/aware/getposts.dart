// import 'dart:convert';
//
// import 'package:hope/main.dart';
// import 'package:hope/model/article_dm.dart';
// import 'package:http/http.dart' as http;
//
// class NewsService {
//   static Future<List<ArticleDM>> fetchNews(String type) async {
//     final String baseUrl = 'https://${MyApp.IP}/api/news';
//     final String url = (type.toLowerCase() == 'all')
//         ? baseUrl
//         : '$baseUrl/${type.toLowerCase()}';
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((json) => ArticleDM.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load news');
//     }
//   }
// }
