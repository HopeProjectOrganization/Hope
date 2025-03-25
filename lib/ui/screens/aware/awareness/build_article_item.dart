import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class BuildArticleItem extends StatelessWidget {
  const BuildArticleItem({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.image,
  });

  final String image;
  final String title;
  final String description;

  final String date;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
