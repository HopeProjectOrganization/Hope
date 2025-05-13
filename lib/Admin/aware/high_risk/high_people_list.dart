import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Admin/aware/high_risk/build_article_high.dart';
import 'package:hope/main.dart';
import 'package:hope/model/news_model.dart';
import 'package:http/http.dart' as http;

class AdminHighPeopleList extends StatefulWidget {
  final String type;
  final bool news;

  const AdminHighPeopleList({required this.type, this.news = false, super.key});

  @override
  State<AdminHighPeopleList> createState() => _AdminNewsListState();
}

class _AdminNewsListState extends State<AdminHighPeopleList> {
  late Future<List<NewsModel>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNewsFromLocalAPI(widget.type);
  }

  Future<List<NewsModel>> fetchNewsFromLocalAPI(String type) async {
    late Uri url;

    if (type == 'ALL') {
      url = Uri.parse('http://${MyApp.IP}/api/highrisk');
    } else {
      url = Uri.parse('http://${MyApp.IP}/api/highrisk/category/$type');
    }

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => NewsModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<void> refreshNews() async {
    setState(() {
      futureNews = fetchNewsFromLocalAPI(widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsModel>>(
      future: futureNews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error fetching news: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No news available."));
        } else {
          final articles = snapshot.data!;
          return buildListView(articles);
        }
      },
    );
  }

  Widget buildListView(List<NewsModel> articles) => ListView.separated(
        itemBuilder: (context, index) {
          NewsModel article = articles[index];
          return BuildArticleHigh(
            article: article,
            onDelete: refreshNews, // ← يعمل تحديث بعد الحذف
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: articles.length,
      );
}
