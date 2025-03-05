import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentScannedProductsProvider extends ChangeNotifier {
  List<String> recentScannedProducts = [];

  Future<void> addScannedProduct(String barcode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> scannedProducts =
        prefs.getStringList("recent_scanned_products") ?? [];

    if (scannedProducts.contains(barcode)) {
      scannedProducts.remove(barcode);
    }
    scannedProducts.add(barcode);

    prefs.setStringList("recent_scanned_products", scannedProducts);
    refreshRecentScannedProducts();
  }

  Future<void> refreshRecentScannedProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    recentScannedProducts =
        (prefs.getStringList("recent_scanned_products") ?? [])
            .reversed
            .toList();
    notifyListeners();
  }

  Future<String?> getLastScannedProduct() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> scannedProducts =
        prefs.getStringList("recent_scanned_products") ?? [];
    return scannedProducts.isNotEmpty ? scannedProducts.last : null;
  }
}
