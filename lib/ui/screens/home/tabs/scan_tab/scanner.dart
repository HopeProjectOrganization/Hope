import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Api/scan/scan_service.dart';
import 'package:hope/ui/screens/home/home.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/result.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarcodeScannerService {
  final BuildContext context;
  final ScanService _scanService = ScanService();

  BarcodeScannerService(this.context);

  Future<void> scanBarcode(Function(String) onResult) async {
    showLoading(context);

    var result = await _scanService.scanBarcode(context);

    print("📌 Result from API: $result"); // تأكد من أن البيانات صحيحة

    if (!context.mounted) return;

    hideLoading(context);

    if (result != null && result.containsKey('product')) {
      print("✅ Scanned data is not null, navigating...");

      final productName = result['product']?['productName'] ??
          "Unknown Product"; // التعامل مع null
      final barcode =
          result['product']?['barcode'] ?? "Unknown Barcode"; // التعامل مع null
      final highRiskIngredients =
          result['highRiskIngredients'] ?? []; // التأكد من عدم وجود null

      await saveRecentlyScannedProduct({
        'productName': productName,
        'barcode': barcode,
        'highRiskIngredients': result['highRiskIngredients'] ?? [],
      });

      Navigator.pushNamed(
        context,
        ResultScreen.routeName,
        arguments: {
          'message': "Product successfully added!",
          'product': {
            'productName': productName,
            'barcode': barcode,
          },
          'highRiskIngredients': highRiskIngredients,
        },
      );
    } else {
      final message = result?['message'] ?? "Scan was cancelled or failed";

      onResult("Error: No result from scanning");
      Navigator.pushReplacementNamed(
          context, HomeScreen.routeName); // يرجع للشاشة السابقة

      onResult(message); // اختياري لو حابب ترجع النتيجة لشيء خارجي
    }
  }

  Future<void> saveRecentlyScannedProduct(Map<String, dynamic> product) async {
    final prefs = await SharedPreferences.getInstance();

    String? productsString = prefs.getString('recently_scanned_products');

    List<dynamic> recentlyScannedProducts = [];

    if (productsString != null) {
      try {
        recentlyScannedProducts = json.decode(productsString);
      } catch (e) {
        print("Error decoding products: $e");
      }
    }

    recentlyScannedProducts.add(product);

    if (recentlyScannedProducts.length > 5) {
      recentlyScannedProducts =
          recentlyScannedProducts.sublist(recentlyScannedProducts.length - 5);
    }

    await prefs.setString(
        'recently_scanned_products', json.encode(recentlyScannedProducts));
  }
}
