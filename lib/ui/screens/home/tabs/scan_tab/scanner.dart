import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final appLocalizations = AppLocalizations.of(context)!;

    showLoading(context);

    final result = await _scanService.scanBarcode(context);

    if (!context.mounted) return;

    hideLoading(context);

    if (result != null && result.containsKey('product')) {
      final productName =
          result['product']?['productName'] ?? appLocalizations.unknownProduct;
      final barcode =
          result['product']?['barcode'] ?? appLocalizations.unknownBarcode;
      final highRiskIngredients = result['highRiskIngredients'] ?? [];

      await saveRecentlyScannedProduct({
        'productName': productName,
        'barcode': barcode,
        'highRiskIngredients': highRiskIngredients,
      });

      Navigator.pushNamed(
        context,
        ResultScreen.routeName,
        arguments: {
          'message': appLocalizations.productAddedSuccessfully,
          'product': {
            'productName': productName,
            'barcode': barcode,
          },
          'highRiskIngredients': highRiskIngredients,
        },
      );
    } else {
      final message =
          result?['message'] ?? appLocalizations.scanCancelledOrFailed;

      showMessage(
        context,
        message,
      );

      onResult(appLocalizations.scanCancelledOrFailed);

      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
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
