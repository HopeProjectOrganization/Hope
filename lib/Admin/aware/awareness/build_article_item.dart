import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hope/Admin/aware/awareness/addNewsScreen.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/main.dart';
import 'package:hope/model/news_model.dart';
import 'package:hope/ui/screens/aware/shared_widgets/article/article_screen.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:http/http.dart' as http;

class BuildArticleItem extends StatefulWidget {
  final VoidCallback? onDelete;

  const BuildArticleItem({
    super.key,
    required this.article,
    this.onDelete,
  });

  final NewsModel article;

  @override
  State<BuildArticleItem> createState() => _BuildArticleItemState();
}

class _BuildArticleItemState extends State<BuildArticleItem> {
  bool isDeleting = false;

  Future<void> deleteArticle(int id) async {
    setState(() => isDeleting = true);
    final url = Uri.parse('http://${MyApp.IP}/api/news/delete/$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted successfully')),
        );
        if (widget.onDelete != null) widget.onDelete!();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: ${response.statusCode}')),
        );
      }
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
    final String title = (article.title != null && article.title!.length > 70)
        ? "${article.title!.substring(0, 70)}..."
        : article.title ?? '';
    final String description =
        (article.content != null && article.content!.length > 50)
            ? "${article.content!.substring(0, 35)}..."
            : article.content ?? '';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.Teal),
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
                    NewsArticleScreen.routeName,
                    arguments: article,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.image_not_supported,
                      size: 100,
                    ),
                    placeholder: (context, url) =>
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
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
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
                          onClick: () {
                            Navigator.pushNamed(
                              context,
                              AdminNewsEditorScreen.routeName,
                              arguments: {
                                'id': article.id,
                                'title': article.title,
                                'content': article.content,
                                'category': article.category,
                                'imageUrl': article.imageUrl,
                              },
                            );
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
                                      title: Text("Confirm Delete"),
                                      content: Text(
                                          "Are you sure you want to delete this article?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            deleteArticle(article.id!);
                                          },
                                          child: Text("Delete",
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
