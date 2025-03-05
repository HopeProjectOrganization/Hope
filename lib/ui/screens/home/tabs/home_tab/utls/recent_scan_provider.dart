import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentScannedProductsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _recentlyScannedProducts = [];

  List<Map<String, dynamic>> get recentlyScannedProducts =>
      _recentlyScannedProducts;

  Future<void> addScannedProduct(String productName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? productsStringList =
        prefs.getStringList('recently_scanned_products');

    List<Map<String, dynamic>> products = productsStringList != null
        ? productsStringList
            .map((product) => jsonDecode(product) as Map<String, dynamic>)
            .toList()
        : [];

    products.add(
        {"productName": productName, "timestamp": DateTime.now().toString()});

    await prefs.setStringList('recently_scanned_products',
        products.map((product) => jsonEncode(product)).toList());

    _recentlyScannedProducts = products.reversed.take(5).toList();

    notifyListeners();
  }

  Future<void> refreshRecentScannedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? productsStringList =
        prefs.getStringList('recently_scanned_products');

    if (productsStringList != null) {
      _recentlyScannedProducts = productsStringList
          .map((product) => jsonDecode(product) as Map<String, dynamic>)
          .toList()
          .reversed
          .take(5)
          .toList();

      notifyListeners();
    }
  }
}
