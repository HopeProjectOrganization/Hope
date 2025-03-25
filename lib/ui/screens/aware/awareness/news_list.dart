import 'package:flutter/material.dart';
import 'package:hope/Api/news/news_service.dart';
import 'package:hope/model/article_dm.dart';
import 'package:hope/ui/screens/aware/awareness/build_article_item.dart';
import 'package:intl/intl.dart';

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
          print(
              "NewsList Error: ${snapshot.error}");
          return Center(child: Text("Error fetching news: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print("No News Available for $type");
          return const Center(child: Text("No news available."));
          return Center(child: Text("Error: ${snapshot.error.toString()}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No articles available"));
        } else {
          final articles = snapshot.data!;
          return buildListView(articles);
        }
      },
    );
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "Unknown Date";
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat("dd MMM yyyy").format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }

  Widget buildListView(List<ArticleDM> articles) => ListView.separated(
        itemBuilder: (context, index) {
          var article = articles[index];
          return BuildArticleItem(
            image: article.urlToImage ?? '',
            title: (article.title != null && article.title!.length > 80)
                ? "${article.title!.substring(0, 80)}..."
                : article.title ?? '',
            description: (article.description != null &&
                    article.description!.length > 50)
                ? "${article.description!.substring(0, 35)}..."
                : article.description ?? '',
            date: formatDate(article.publishedAt),
          );
        },
        separatorBuilder: (context, index) => SizedBox(
          height: 10,
        ),
        itemCount: articles.length,
      );
      itemBuilder: (context, index) {
        var article = articles[index];
        return BuildArticleItem(
          image: article.urlToImage ?? '',
          title: (article.title != null && article.title!.length > 70)
              ? "${article.title!.substring(0, 70)}..."
              : article.title ?? '',
          description:
              (article.description != null && article.description!.length > 50)
                  ? "${article.description!.substring(0, 35)}..."
                  : article.description ?? '',
          date: formatDate(article.publishedAt),
        );
      },
      separatorBuilder: (context, index) => SizedBox(
            height: 10,
          ),
      itemCount: articles.length);
}
