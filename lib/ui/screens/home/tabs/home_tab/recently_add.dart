import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/ui/shared_widgets/custom_recently_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentlyAddedScreen extends StatefulWidget {
  @override
  _RecentlyAddedScreenState createState() => _RecentlyAddedScreenState();
}

class _RecentlyAddedScreenState extends State<RecentlyAddedScreen> {
  List<dynamic> recentlyAddedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadRecentlyAddedProducts();
  }

  Future<void> _loadRecentlyAddedProducts() async {
    final prefs = await SharedPreferences.getInstance();

    String? productsString = prefs.getString('recently_added_products');

    if (productsString != null) {
      try {
        List<dynamic> products = json.decode(productsString);

        setState(() {
          recentlyAddedProducts = products.reversed.take(5).toList();
        });
      } catch (e) {
        print("Error decoding products: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (recentlyAddedProducts.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Recently Add",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .23,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentlyAddedProducts.length,
            itemBuilder: (context, index) {
              final product = recentlyAddedProducts[index];

              if (product is Map<String, dynamic>) {
                return CustomRecentlyCard(
                  product: product,
                  barcode: product['barcode'],
                  highRiskIngredients: product['highRiskIngredients'] ?? [],
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
