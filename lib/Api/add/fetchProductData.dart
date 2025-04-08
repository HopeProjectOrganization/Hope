// import 'dart:convert';
// import 'package:hope/Api/add/add_service.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
//
// class ProductImporter {
//   static Future<void> fetchAndAddProducts(BuildContext context) async {
//     final url =
//         'https://world.openfoodfacts.org/cgi/search.pl?search_simple=1&action=process&json=1&page_size=50'; // يمكنك تغيير page_size للحصول على عدد أكبر
//
//     try {
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         List<dynamic> products = json.decode(response.body)['products'];
//
//         // قائمة الوعود (Futures) لإضافة المنتجات
//         List<Future<void>> addProductFutures = [];
//
//         for (var product in products) {
//           String productName = product['product_name'] ?? 'Unknown product';
//           String barcode = product['code'] ?? 'Unknown barcode';
//           String ingredientsText =
//               product['ingredients_text'] ?? 'No ingredients available';
//
//           // إضافة العملية إلى القائمة بدلاً من انتظارها
//           addProductFutures.add(
//             AddService.addProduct(
//                 context, productName, barcode, ingredientsText),
//           );
//         }
//
//         await Future.wait(addProductFutures);
//
//         print('All products added successfully.');
//       } else {
//         print(
//             'Failed to fetch products from OpenFoodFacts. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error occurred during fetching products: $e');
//     }
//   }
// }
