import 'package:flutter/material.dart';
import 'package:hope/Api/hereditary/hereditary_service.dart';
import 'package:hope/Api/high_risk/highrisk_serivce.dart';
import 'package:hope/Api/news/news_service.dart';
import 'package:hope/model/article.dart';
import 'package:hope/ui/screens/aware/awareness/build_article_item.dart';

class NewsList extends StatelessWidget {
  final String type;
  final Map<String, String> hereditaryTypeMap;

  const NewsList(
      {Key? key, required this.type, required this.hereditaryTypeMap})
      : super(key: key);

  bool isHereditaryCategory(String type) {
    return hereditaryTypeMap.containsKey(type);
  }

  bool isHighRiskCategory(String type) {
    const highRiskKeywords = [
      "smokers",
      "obese",
      "family",
      "elderly",
      "radiation",
      "inflammation",
      "unhealthy",
      "pregnant",
      "weak",
      "mutation",
      "inactive",
      "polluted",
      "chemical"
    ];
    return highRiskKeywords
        .any((keyword) => type.toLowerCase().contains(keyword));
  }

  Future<List<Article>> getCorrectSource() {
    if (isHereditaryCategory(type)) {
      final apiValue = hereditaryTypeMap[type]!;
      return HereditaryService.getByCategory(apiValue);
    } else if (isHighRiskCategory(type)) {
      final categoryEnum = type.toUpperCase().replaceAll(" ", "_");
      return HighRiskService.getByCategory(categoryEnum);
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
          print('📛 Snapshot is empty or null');
          print('📛 Raw data: ${snapshot.data}');
          return const Center(child: Text('No news available.'));
        }

        final articles = snapshot.data!;
        print('✅ Articles loaded: ${articles.length}');

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
