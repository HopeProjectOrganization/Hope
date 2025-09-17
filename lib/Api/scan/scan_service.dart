// ✅ 1. scan_service.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Api/history/history_service.dart';
import 'package:hope/Api/scan/sharedData.dart';
import 'package:hope/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ScanService {
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>?> searchInLocalAPI(String barcode) async {
    final token = await getToken();
    if (token == null) return null;

    final url = Uri.parse("${MyApp.IP}/api/scan/$barcode");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('🔴 API error: ${response.statusCode}, body: ${response.body}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> scanBarcode(BuildContext context) async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff8E56FF",
        "Cancel",
        true,
        ScanMode.BARCODE,
        500,
        "back",
        ScanFormat.ONLY_BARCODE,
      );

      if (barcode == "-1") return {'message': 'Scan canceled'};

      final local = await searchInLocalAPI(barcode);

      if (local != null && local['product'] != null) {
        final product = local['product'];
        final highRiskIngredients = local['highRiskIngredients'] ?? [];

        final finalProduct = {
          'productName': product['productName'],
          'barcode': product['barcode'] ?? barcode,
          'highRiskIngredients': highRiskIngredients,
        };

        await HistoryApiService.addToHistory(barcode, 'SCANNED');
        ScanDataService().scannedProduct = finalProduct;
        ScanDataService().highRiskIngredients = highRiskIngredients;

        return {
          'message': local['message'] ?? "Product found",
          'product': finalProduct,
          'highRiskIngredients': highRiskIngredients,
        };
      }

      return {'message': 'Product not found'};
    } catch (e) {
      return {'message': 'Error during scan: $e'};
    }
  }

  Future<List<dynamic>?> getScannedProducts() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final url = Uri.parse("${MyApp.IP}/history/scanned");
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
    } catch (e) {
      print('Error fetching scanned products: $e');
    }
    return null;
  }
}