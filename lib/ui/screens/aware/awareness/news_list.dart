import 'package:flutter/material.dart';
import 'package:hope/Api/news/news_service.dart';
import 'package:hope/model/article_dm.dart';
import 'package:hope/ui/screens/aware/awareness/build_article_item.dart';
import 'package:intl/intl.dart';

class NewsList extends StatelessWidget {
  final String type;
  final String apiKey;

  NewsList({required this.type, required this.apiKey});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleDM>>(
      future: NewsService.fetchNews(type, apiKey),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error.toString()}"));
        } else {
          final articles = snapshot.data as List<ArticleDM>;
          return buildListView(snapshot.data ?? [])
              //   ListView.builder(
              //   itemCount: articles.length,
              //   itemBuilder: (context, index) {
              //     final article = articles[index];
              //     return Card(
              //       margin: EdgeInsets.all(8.0),
              //       child: ListTile(
              //         leading: article["urlToImage"] != null
              //             ? ClipRRect(
              //             borderRadius: BorderRadius.circular(12),
              //             child: CachedNetworkImage(
              //               imageUrl: article["urlToImage"],
              //               errorWidget: (context, url, error) => Center(
              //                 child: Icon(Icons.error),
              //               ),
              //               placeholder: (context, url) => Center(
              //                   child: CircularProgressIndicator(
              //                     strokeWidth: 1,
              //                   )),
              //             ))
              //             : Icon(Icons.image_not_supported),
              //         title: Text(article["title"] ?? "No Title"),
              //         subtitle: Text(article["source"]["name"] ?? "Unknown Source"),
              //         onTap: () {
              //           showDialog(
              //             context: context,
              //             builder: (context) => AlertDialog(
              //               title: Text(article["title"] ?? "No Title"),
              //               content: Text(article["description"] ?? "No Description"),
              //               actions: [
              //                 TextButton(
              //                   onPressed: () => Navigator.pop(context),
              //                   child: Text("Close"),
              //                 ),
              //                 TextButton(
              //                   onPressed: () {
              //                   },
              //                   child: Text("Read More"),
              //                 ),
              //               ],
              //             ),
              //           );
              //         },
              //       ),
              //     );
              //   },
              // )
              ;
        }
      },
    );
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "Unknown Date";
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat("dd MMM yyyy").format(dateTime); // شكل: 25 Mar 2025
    } catch (e) {
      return "Invalid Date";
    }
  }

  Widget buildListView(List<ArticleDM> articles) => ListView.separated(
      itemBuilder: (context, index) {
        var article = articles[index]; //load this from api;
        return BuildArticleItem(
          image: article.urlToImage ?? '',
          title: (article.title != null && article.title!.length > 80)
              ? "${article.title!.substring(0, 80)}..."
              : article.title ?? '',
          description:
              (article.description != null && article.description!.length > 50)
                  ? "${article.description!.substring(0, 35)}..."
                  : article.description ?? '',
          date: formatDate(article.publishedAt),
        );
      },
      separatorBuilder: (context, index) => SizedBox(
            height: 10,
          ),
      itemCount: articles.length);
}
