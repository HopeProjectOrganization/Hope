import 'package:flutter/material.dart';
import 'package:hope/Admin/aware/high_risk/build_article_high.dart';
import 'package:hope/Api/high_risk/highrisk_serivce.dart';
import 'package:hope/model/article.dart';

class AdminHighPeopleList extends StatefulWidget {
  final String type;

  const AdminHighPeopleList({required this.type, super.key});

  @override
  State<AdminHighPeopleList> createState() => _AdminHighPeopleListState();
}

class _AdminHighPeopleListState extends State<AdminHighPeopleList> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles(widget.type);
  }

  Future<List<Article>> fetchArticles(String type) {
    if (type == 'ALL') {
      return HighRiskService().getAll();
    } else {
      return HighRiskService.getByCategory(type);
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
            itemBuilder: (context, index) => BuildArticleHigh(
              article: articles[index],
              onDelete: refreshArticles,
            ),
          );
        }
      },
    );
  }
}
