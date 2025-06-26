import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/saved/saved_post.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/article.dart';
import 'package:hope/ui/screens/aware/shared_widgets/article/article_card.dart';
import 'package:hope/ui/screens/aware/shared_widgets/article/content.dart';
import 'package:hope/ui/shared_widgets/utils/formate_date.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsArticleScreen extends StatefulWidget {
  static const routeName = '/article';

  const NewsArticleScreen({super.key});

  @override
  State<NewsArticleScreen> createState() => _NewsArticleScreenState();
}

class _NewsArticleScreenState extends State<NewsArticleScreen> {
  late String type;

  bool isSaved = false;

  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  late Article article;
  late String category;
  bool isInitialized = false;

  void checkIfFavorite(String articleId) async {
    try {
      final savedArticles = await SavedPostService.fetchSavedArticles(category);
      final isInFavorites = savedArticles.any((a) => a.articleId == articleId);
      setState(() {
        isSaved = isInFavorites;
      });
    } catch (e) {
      print("Failed to check favorite: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    if (!isInitialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      article = args['article'];
      category = args['category'];
      type = args['type']; // ← الجديد
      isInitialized = true;
      checkIfFavorite(article.articleId);
    }

    final String image =
        (article.imageUrl != null && article.imageUrl!.trim().isNotEmpty)
            ? article.imageUrl!
            : 'https://via.placeholder.com/300x200.png?text=No+Image';

    final String title = (article.title != null && article.title.length > 80)
        ? "${article.title.substring(0, 50)}..."
        : article.title ?? 'No Title';

    final String date = formatDate(article.pubDate);
    final String author = (article.creator != null &&
            article.creator.toString().toLowerCase() != 'null' &&
            article.creator.toString().trim().isNotEmpty)
        ? article.creator.toString()
        : 'Unknown';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Teal,
        centerTitle: true,
        title: Text("News", style: Theme.of(context).textTheme.titleMedium),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              AppIcons.save,
              color: isSaved ? AppColors.yellow : null,
            ),
            onPressed: () async {
              print("article.id: ${article.id}");
              print("article.articleId: ${article.articleId}");
              print("category: $category");

              if (article.articleId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Article ID is missing")),
                );
                return;
              }

              try {
                if (isSaved) {
                  final success = await SavedPostService.deleteFavorite(
                    postId: article.id,
                    postType: category,
                  );

                  if (success) {
                    setState(() => isSaved = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Removed from saved articles")),
                    );
                  }
                } else {
                  // إضافة للمفضلة
                  final success = await SavedPostService.addToSaved(
                    postId: article.id,
                    postStringId: article.articleId,
                    postType: category,
                  );

                  if (success) {
                    setState(() => isSaved = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Saved to your articles")),
                    );
                  }
                }
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Action failed")),
                );
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ArticleCard(
            title: title,
            imageUrl: image,
            author: author,
            date: date,
          ),
          const SizedBox(height: 12),
          Content(content: article.description),
          if (article.link != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.Teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => launchUrl(Uri.parse(article.link)),
                icon: const Icon(Icons.open_in_new, color: AppColors.white),
                label: const Text("Read Full Article",
                    style: TextStyle(color: AppColors.white)),
              ),
            ),
          // ignore: unnecessary_null_comparison
          if (article.sourceName != null || article.sourceUrl != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.Teal),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.sourceName != null)
                      Row(
                        children: [
                          if (article.sourceIcon != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.network(
                                article.sourceIcon!,
                                width: 20,
                                height: 20,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              ),
                            ),
                          Text(
                            article.sourceName,
                            style: const TextStyle(
                              color: AppColors.gray,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    if (article.sourceUrl != null) ...[
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => launchUrl(Uri.parse(article.sourceUrl)),
                        child: Text(
                          article.sourceUrl,
                          style: const TextStyle(
                            color: AppColors.Teal,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy,
                                size: 18, color: AppColors.gray),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: article.sourceUrl));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Source link copied")),
                              );
                            },
                          ),
                          const Text("Copy link",
                              style: TextStyle(color: AppColors.gray)),
                        ],
                      )
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
