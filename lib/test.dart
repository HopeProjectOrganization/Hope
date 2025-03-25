import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_assets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Article Preview")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BuildArticleItem(
            title: "Understanding Cancer Treatment",
            date: "25/3/2025",
            author: "Dr. John Doe",
            image: "https://via.placeholder.com/300", // مثال لصورة
          ),
        ),
      ),
    );
  }
}

class BuildArticleItem extends StatelessWidget {
  const BuildArticleItem({
    super.key,
    required this.title,
    required this.author,
    required this.date,
    required this.image,
  });

  final String image;
  final String title;
  final String author;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
                    child: Image.asset(
                      AppAssets.result,
                    )
                    // CachedNetworkImage(
                    //   imageUrl: image,
                    //   height: 200,
                    //   width: double.infinity,
                    //   fit: BoxFit.cover,
                    //   errorWidget: (context, url, error) => Icon(
                    //     Icons.image_not_supported,
                    //     size: 100,
                    //     color: Colors.grey,
                    //   ),
                    //   placeholder: (context, url) => Center(
                    //     child: CircularProgressIndicator(),
                    //   ),
                    // ),
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
                          author,
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
