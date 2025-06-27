import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hope/Admin/aware/hereditary/addHereditaryScreen.dart';
import 'package:hope/Admin/aware/shared_widgets/article/article_screen.dart';
import 'package:hope/Api/hereditary/hereditary_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/article.dart';
import 'package:hope/ui/screens/aware/shared_widgets/article/article_screen.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';

class BuildArticleItem extends StatefulWidget {
  final VoidCallback? onDelete;
  final Article article;

  const BuildArticleItem({
    super.key,
    required this.article,
    this.onDelete,
  });

  @override
  State<BuildArticleItem> createState() => _BuildArticleItemState();
}

class _BuildArticleItemState extends State<BuildArticleItem> {
  bool isDeleting = false;

  Future<void> deleteArticle(int id) async {
    setState(() => isDeleting = true);
    try {
      await HereditaryService.deleteNews(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deleted successfully')),
      );
      widget.onDelete?.call();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final String image = article.imageUrl ?? '';
    final String title = article.title.length > 70
        ? "${article.title.substring(0, 70)}..."
        : article.title;
    final String description =
        (article.content != null && article.content!.length > 50)
            ? "${article.content!.substring(0, 35)}..."
            : article.content ?? '';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.Teal),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.46,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AdminNewsArticleScreen.routeName,
                    arguments: {
                      'article': article,
                      'type': 'HEREDITARY_PEOPLE',
                    },
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.image_not_supported, size: 100),
                    placeholder: (_, __) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(title, style: Theme.of(context).textTheme.labelSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          description,
                          style: Theme.of(context).textTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          title: 'Edit',
                          onClick: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              AdminHereditaryEditorScreen.routeName,
                              arguments: {
                                'id': article.id,
                                'articleId': article.articleId,
                                'title': article.title,
                                'link': article.link,
                                'creator': article.creator,
                                'description': article.description,
                                'content': article.content,
                                'pubDate': article.pubDate,
                                'imageUrl': article.imageUrl,
                                'sourceName': article.sourceName,
                                'sourceUrl': article.sourceUrl,
                                'sourceIcon': article.sourceIcon,
                                'category': article.category,
                              },
                            );

                            if (result == true) {
                              widget.onDelete?.call(); // يعمل refresh للبيانات
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: isDeleting
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                title: 'Delete',
                                onClick: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Confirm Delete"),
                                      content: const Text(
                                          "Are you sure you want to delete this article?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            deleteArticle(article.id!);
                                          },
                                          child: const Text("Delete",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
