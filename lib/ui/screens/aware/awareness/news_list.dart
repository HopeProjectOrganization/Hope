import 'package:flutter/material.dart';
import 'package:hope/Api/hereditary/hereditary_service.dart';
import 'package:hope/Api/high_risk/highrisk_serivce.dart';
import 'package:hope/Api/news/news_service.dart';
import 'package:hope/model/article.dart';
import 'package:hope/ui/screens/aware/awareness/build_article_item.dart';

class NewsList extends StatelessWidget {
  final String type;

  const NewsList({Key? key, required this.type}) : super(key: key);

  bool isHereditaryCategory(String type) {
    return type.toLowerCase().startsWith("hereditary");
  }

  bool isHighRiskCategory(String type) {
    const highRiskKeywords = [
      "smokers",
      "obese",
      "family",
      "elderly",
      "radiation",
      "inflammation",
      "unhealthy"
    ];
    return highRiskKeywords
        .any((keyword) => type.toLowerCase().contains(keyword.toLowerCase()));
  }

  Future<List<Article>> getCorrectSource() {
    if (isHereditaryCategory(type)) {
      final formattedType = type.replaceAll(' ', '_').toUpperCase();
      return HereditaryService.getByCategory(formattedType);
    } else if (isHighRiskCategory(type)) {
      // 💡 نحول الاسم للي يناسب الـ enum: SMOKERS
      final formattedType = type.replaceAll(' ', '_').toUpperCase();
      return HighRiskService.getByCategory(formattedType);
    } else {
      return NewsApiService().getNewsByCategory(type == "All" ? "all" : type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: getCorrectSource(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No news available.'));
        }

        final articles = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: articles.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return BuildArticleItem(
              article: articles[index],
              selectedCancerType: type,
            );
          },
        );
      },
    );
  }
}
