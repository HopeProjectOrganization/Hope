import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/article_dm.dart';
import 'package:hope/ui/screens/aware/shared_widgets/article/article_card.dart';
import 'package:hope/ui/screens/aware/shared_widgets/article/content.dart';
import 'package:hope/ui/shared_widgets/utils/formate_date.dart';

class NewsArticleScreen extends StatelessWidget {
  static const routeName = '/article';

  const NewsArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final article = ModalRoute.of(context)!.settings.arguments as ArticleDM;

    final String image = article.urlToImage ?? '';
    final String title = (article.title != null && article.title!.length > 80)
        ? "${article.title!.substring(0, 80)}..."
        : article.title ?? 'No Title';

    final String date = formatDate(article.publishedAt);
    final String author = article.author ?? 'Unknown';

    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.Teal,
          centerTitle: true,
          title: Text(
            "News",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.favorite_outline_sharp,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Text(
            date,
            style: TextStyle(color: AppColors.gray),
          ),
          SizedBox(height: 16),
          ArticleCard(
            title: title,
            imageUrl: image,
            author: author,
            date: date,
          ),
          Content(content: article.content),
        ]));
  }
}
