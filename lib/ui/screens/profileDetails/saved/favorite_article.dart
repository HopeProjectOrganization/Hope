// article_favorites.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/saved/saved_post.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/article.dart';
import 'package:hope/ui/screens/aware/shared_widgets/article/article_screen.dart';
import 'package:lottie/lottie.dart';

class ArticleFavorites extends StatelessWidget {
  final Map<String, String> articleCategories;
  final VoidCallback onRefresh;

  const ArticleFavorites({
    required this.articleCategories,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    if (articleCategories.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .9,
              width: MediaQuery.of(context).size.width * .9,
              child: Lottie.asset('assets/lottie/saved.json'), // animation path
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: articleCategories.entries.map<Widget>((entry) {
        final categoryKey = entry.key;
        final categoryTitle = entry.value;

        return FutureBuilder<List<Article>>(
          future: SavedPostService.fetchSavedArticles(categoryKey),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Text('Error in $categoryTitle: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox();
            }

            final articles = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    categoryTitle,
                      style: Theme.of(context).textTheme.labelLarge),
                ),
                ...articles.map<Widget>((article) {
                  return GestureDetector(
                    onTap: () async {
                      Navigator.pushNamed(
                        context,
                        NewsArticleScreen.routeName,
                        arguments: {
                          'article': article,
                          'type': article.category,
                          'category': categoryKey,
                        },
                      ).then((_) => onRefresh());
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cloudi,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              article.imageUrl ?? '',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${appLocalizations.articleName}: ${article.title}",
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${appLocalizations.category} ${article.category}",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      }).toList(),
    );
  }
}

