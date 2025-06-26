import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Admin/aware/hereditary/hereditary_article_item.dart';
import 'package:hope/main.dart';
import 'package:hope/model/article.dart';
import 'package:http/http.dart' as http;

class AdminHereditaryList extends StatefulWidget {
  final String type;
  final bool news;

  const AdminHereditaryList({required this.type, this.news = false, super.key});

  @override
  State<AdminHereditaryList> createState() => _AdminNewsListState();
}

class _AdminNewsListState extends State<AdminHereditaryList> {
  late Future<List<Article>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNewsFromLocalAPI(widget.type);
  }

  Future<List<Article>> fetchNewsFromLocalAPI(String type) async {
    late Uri url;

    if (type == 'ALL') {
      url = Uri.parse('https://${MyApp.IP}/api/hereditary');
    } else {
      url = Uri.parse('https://${MyApp.IP}/api/hereditary/category/$type');
    }

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Hereditary');
    }
  }

  Future<void> refreshNews() async {
    setState(() {
      futureNews = fetchNewsFromLocalAPI(widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: futureNews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child:
                  Text("Error fetching Hereditary posts : \${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No Hereditary posts available."));
        } else {
          final articles = snapshot.data!;
          return buildListView(articles);
        }
      },
    );
  }

  Widget buildListView(List<Article> articles) => ListView.separated(
        itemBuilder: (context, index) {
          Article article = articles[index];
          return BuildArticleItem(
            article: article,
            onDelete: refreshNews, // ← يعمل تحديث بعد الحذف
            showAllFields: true, // عرض كل الحقول الجديدة
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: articles.length,
      );
}
