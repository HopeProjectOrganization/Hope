import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Api/scan/scan_service.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/main.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/result.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class BarcodeScannerService {
  final BuildContext context;
  final ScanService _scanService = ScanService();

  BarcodeScannerService(this.context);

  // ✅ استخدمنا IP من main.dart
  static Future<Map<String, dynamic>?> fetchScanResult(String barcode) async {
    try {
      var url = Uri.parse("https://${MyApp.IP}/api/scan/$barcode");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {'message': 'Failed to fetch scan result'};
      }
    } catch (e) {
      return {'message': 'Error occurred during fetching scan result: $e'};
    }
  }

  Future<void> scanBarcode(Function(String) onResult) async {
    final appLocalizations = AppLocalizations.of(context)!;

    // ✅ افتح الكاميرا وامسح الباركود
    final barcode = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(),
      ),
    );

    if (!context.mounted) return;

    if (barcode == null || barcode == "-1") {
      onResult(appLocalizations.scanCancelledOrFailed);
      return;
    }

    showLoading(context);

    final result = await fetchScanResult(barcode);

    hideLoading(context);

    if (result != null &&
        result.containsKey('product') &&
        result['product'] != null) {
      final product = result['product'];
      final productName =
          product['productName'] ?? appLocalizations.unknownProduct;
      final barcodeValue =
          product['barcode'] ?? appLocalizations.unknownBarcode;
      final highRiskIngredients = result['highRiskIngredients'] ?? [];

      await saveRecentlyScannedProduct({
        'productName': productName,
        'barcode': barcodeValue,
        'highRiskIngredients': highRiskIngredients,
      });

      Navigator.pushNamed(
        context,
        ResultScreen.routeName,
        arguments: {
          'message': appLocalizations.productAddedSuccessfully,
          'product': product,
          'highRiskIngredients': highRiskIngredients,
        },
      );
    } else {
      // ✅ تحقق من أن المنتج غير موجود بالفعل
      final message = result?['message'] ?? 'productNotFound';

      showMessage(
        context,
        message,
        type: MessageType.warning, // أو error لو حابة
      );

      onResult(message);
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
        debugPrint("Error decoding products: $e");
      }
    }

    recentlyScannedProducts.add(product);

    if (recentlyScannedProducts.length > 5) {
      recentlyScannedProducts =
          recentlyScannedProducts.sublist(recentlyScannedProducts.length - 5);
    }

    await prefs.setString(
      'recently_scanned_products',
      json.encode(recentlyScannedProducts),
    );
  }
}
