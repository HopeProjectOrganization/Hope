import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/article.dart';
import 'package:hope/ui/screens/aware/shared_widgets/article/article_screen.dart';
import 'package:hope/ui/shared_widgets/utils/formate_date.dart';

class BuildArticleItem extends StatelessWidget {
  const BuildArticleItem({
    super.key,
    required this.article,
    required this.selectedCancerType,
  });

  final Article article;
  final String selectedCancerType;

  @override
  Widget build(BuildContext context) {
    final String image = article.imageUrl ?? '';
    final String title = (article.title != null && article.title.length > 70)
        ? "${article.title.substring(0, 50)}..."
        : article.title ?? '';
    final String description =
        (article.description != null && article.description.length > 50)
            ? "${article.description.substring(0, 25)}..."
            : article.description ?? '';
    final String date = formatDate(article.pubDate);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          NewsArticleScreen.routeName,
          arguments: {
            'article': article,
            'category': selectedCancerType,
          },
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.Teal)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.35,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        //Image.asset(AppAssets.result ,)
                        image.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: image,
                                height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.image_not_supported,
                                  size: 100,
                      ),
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Container(
                                height: 200,
                                width: double.infinity,
                                color: AppColors.gray.withOpacity(0.2),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 100,
                                  color: AppColors.gray,
                                ),
                              ),
                  )),
              SizedBox(
                height: 20,
              ),
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            date,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
