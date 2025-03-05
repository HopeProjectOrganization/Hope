import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/ui/shared_widgets/custom_recently_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentlyScan extends StatefulWidget {
  @override
  _RecentlyScanState createState() => _RecentlyScanState();
}

class _RecentlyScanState extends State<RecentlyScan> {
  List<dynamic> recentlyScannedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadRecentlyScannedProducts();
  }

  Future<void> _loadRecentlyScannedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    String? productsString = prefs.getString('recently_scanned_products');

    if (productsString != null) {
      try {
        List<dynamic> products = json.decode(productsString);

        if (products is List) {
          Map<String, dynamic> uniqueProductsMap = {};

          for (var product in products) {
            if (product is Map<String, dynamic> &&
                product.containsKey('barcode')) {
              uniqueProductsMap[product['barcode']] = product;
            }
          }

          setState(() {
            recentlyScannedProducts =
                uniqueProductsMap.values.toList().reversed.take(5).toList();
          });
        }
      } catch (e) {
        print("Error decoding products: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (recentlyScannedProducts.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      height: MediaQuery.of(context).size.height * .23,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentlyScannedProducts.length,
        itemBuilder: (context, index) {
          final product = recentlyScannedProducts[index];

          if (product is Map<String, dynamic>) {
            return CustomRecentlyCard(
              product: product,
              barcode: product['barcode'] ?? '',
              highRiskIngredients: product['highRiskIngredients'] ?? [],
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
