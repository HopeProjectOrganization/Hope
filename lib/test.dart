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
          child: ArticleScreen(

          ),
        ),
      ),
    );
  }
}

class ArticleScreen extends StatelessWidget {
  final String imageUrl =
      'https://images.unsplash.com/photo-1557804506-669a67965ba0'; // صورة الخبر
  final String title =
      'دواء جديد يثبت فعاليته في علاج أنواع نادرة من السرطان';
  final String date = '10 أبريل 2025';
  final String content = '''
توصلت دراسة حديثة إلى أن دواءً جديداً أظهر فعالية كبيرة في علاج أنواع نادرة من السرطان لدى مجموعة من المرضى المشاركين في التجربة السريرية.

وأشار الباحثون إلى أن الدواء استهدف الطفرات الجينية المرتبطة بنمو الأورام، وساهم في تقليص حجم الورم بنسبة تجاوزت 60% في بعض الحالات.

كما أوصت الدراسة بالمزيد من التجارب للتحقق من الآثار الجانبية طويلة المدى والتأكد من فعالية الدواء في مراحل مختلفة من المرض.

وتُعد هذه النتائج خطوة مهمة نحو تطوير علاجات أكثر دقة وتخصصًا لمرضى السرطان حول العالم.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تفاصيل الخبر"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المقال
            Image.network(imageUrl, width: double.infinity, height: 250, fit: BoxFit.cover),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  // التاريخ
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  // نص الخبر
                  Text(
                    content,
                    style: TextStyle(fontSize: 16, height: 1.6),
                    textAlign: TextAlign.justify,
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
