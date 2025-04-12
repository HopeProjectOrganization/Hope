import 'package:flutter/material.dart';
import 'package:hope/Api/news/news_service.dart';
import 'package:hope/model/article_dm.dart';
import 'package:hope/ui/screens/aware/awareness/build_article_item.dart';

class NewsList extends StatelessWidget {
  final String type;
  final String apiKey;
  final bool news;

  NewsList({required this.type, required this.apiKey, this.news = false});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleDM>>(
      future: NewsService.fetchNews(type, apiKey, news),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("NewsList Error: ${snapshot.error}");
          return Center(child: Text("Error fetching news: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print("No News Available for $type");
          return const Center(child: Text("No news available."));
        } else {
          final articles = snapshot.data!;
          return buildListView(articles);
        }
      },
    );
  }

  Widget buildListView(List<ArticleDM> articles) => ListView.separated(
    itemBuilder: (context, index) {
          ArticleDM article = articles[index];
          return BuildArticleItem(article: article);
        },
    separatorBuilder: (context, index) =>
        SizedBox(
          height: 10,
        ),
    itemCount: articles.length,
  );
}
