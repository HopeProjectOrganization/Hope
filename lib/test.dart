// import 'package:flutter/material.dart';
// import 'package:hope/core/theme/app_colors.dart';
//
// // void main() {
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'News App',
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(fontFamily: 'Roboto', primarySwatch: Colors.green),
// //       home: const SimilarArticle(),
// //     );
// //   }
// // }
// //
// // class NewsArticleScreen extends StatelessWidget {
// //   const NewsArticleScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.white,
// //       appBar: AppBar(
// //         backgroundColor: AppColors.white,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back, color: AppColors.dark),
// //           onPressed: () {
// //             // إضافة عملية العودة هنا (مثل Navigator.pop)
// //             Navigator.pop(context);
// //           },
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.favorite_outline_sharp, color: AppColors.dark),
// //             onPressed: () {
// //             },
// //           ),
// //         ],
// //       ),
// //       body: ListView(
// //         padding: const EdgeInsets.all(16),
// //         children: const [
// //           Text(
// //             'Wednesday, April 10, 2025',
// //             style: TextStyle(color: AppColors.gray),
// //           ),
// //           SizedBox(height: 16),
// //           NewsCard(
// //             title: 'New Cancer Treatment Breakthrough Announced',
// //             imageUrl: 'https://via.placeholder.com/300x200',
// //             author: 'Dr. Sarah Ali',
// //             date: 'April 10, 2025',
// //           ),
// //           SizedBox(height: 24),
// //           Text(
// //             "Today's Posts",
// //             style: TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.dark,
// //             ),
// //           ),
// //           SizedBox(height: 12),
// //          ]),
// //       floatingActionButton: FloatingActionButton(
// //         backgroundColor: AppColors.purple,
// //         onPressed: () {},
// //         child: const Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }
// //
// class NewsCard extends StatelessWidget {
//   final String title, imageUrl, author, date;
//
//   const NewsCard({
//     required this.title,
//     required this.imageUrl,
//     required this.author,
//     required this.date,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: AppColors.lavender,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: Image.network(
//               imageUrl,
//               height: 200,
//               width: double.infinity,
//               fit: BoxFit.cover,  // Ensures image covers the area properly
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Center(child: CircularProgressIndicator());
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return Center(
//                   child: Icon(Icons.image_not_supported, size: 100, color: AppColors.gray),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.dark,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 12,
//                       backgroundColor: AppColors.purple,
//                       child: Icon(Icons.person, size: 14, color: AppColors.white),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       author,
//                       style: const TextStyle(color: AppColors.gray),
//                     ),
//                     const Spacer(),
//                     Text(
//                       date,
//                       style: const TextStyle(color: AppColors.gray),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
//
