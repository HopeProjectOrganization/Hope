import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Admin/aware/hereditary/hereditary_article_item.dart';
import 'package:hope/Api/hereditary/hereditary_service.dart';
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
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles(widget.type);
  }

  Future<List<Article>> fetchArticles(String type) {
    if (type == 'ALL') {
      return HereditaryService.getAllNews();
    } else {
      return HereditaryService.getByCategory(type);
    }
  }

  Future<void> refreshArticles() async {
    setState(() {
      futureArticles = fetchArticles(widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: futureArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text("Error fetching articles: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No articles available."));
        } else {
          final articles = snapshot.data!;
          return ListView.separated(
            itemCount: articles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => BuildArticleItem(
              article: articles[index],
              onDelete: refreshArticles,
            ),
          );
        }
      },
    );
  }
}
