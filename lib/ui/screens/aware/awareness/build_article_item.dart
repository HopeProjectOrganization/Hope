import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/article_dm.dart';
import 'package:hope/ui/screens/aware/shared_widgets/article/article_screen.dart';
import 'package:hope/ui/shared_widgets/utils/formate_date.dart';

class BuildArticleItem extends StatelessWidget {
  const BuildArticleItem({
    super.key, required this.article});

  final ArticleDM article;

  @override
  Widget build(BuildContext context) {
    final String image = article.urlToImage ?? '';
    final String title = (article.title != null && article.title!.length > 80)
        ? "${article.title!.substring(0, 80)}..."
        : article.title ?? '';
    final String description =
        (article.description != null && article.description!.length > 50)
            ? "${article.description!.substring(0, 35)}..."
            : article.description ?? '';
    final String date = formatDate(article.publishedAt);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, NewsArticleScreen.routeName,
            arguments: article);
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.purple)),
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
                        CachedNetworkImage(
                      imageUrl: image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(
                        Icons.image_not_supported,
                        size: 100,
                      ),
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            description,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
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
