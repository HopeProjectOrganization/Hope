import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Api/add/add_service.dart';
import 'package:hope/Api/history/add_to_history.dart';
import 'package:hope/Api/scan/sharedData.dart';
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
    final url = Uri.parse("http://192.168.78.153:8080/api/scan/$barcode");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> searchInOpenFoodFacts(
      BuildContext context, String barcode) async {
    final url = Uri.parse(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 1) {
        final product = data['product'];

        final productName = product['product_name'] ?? 'Unknown';
        final ingredients = product['ingredients_text'] ?? '';

        await AddService.addProductAfterScan(
            context, productName, barcode, ingredients, "Food");

        await AddToHistory().updateHistory(barcode, 'SCANNED');

        return product;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> searchInOpenBeautyFacts(
      BuildContext context, String barcode) async {
    final url = Uri.parse(
        'https://world.openbeautyfacts.org/api/v0/product/$barcode.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 1) {
        final product = data['product'];

        final productName = product['product_name'] ??
            product['generic_name'] ??
            product['brands'] ??
            'Unknown';

        final ingredients = product['ingredients_text'] ?? '';

        await AddService.addProductAfterScan(
            context, productName, barcode, ingredients, "Beauty");

        // تحديث التاريخ بعد إضافة المنتج
        await AddToHistory().updateHistory(barcode, 'SCANNED');

        return product;
      }
    }
    return null;
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

      if (barcode == "-1") {
        return {'message': 'Scan canceled'};
      }

      String message = '';
      Map<String, dynamic>? product;

      /// 1. جرّب السيرفر المحلي أولًا
      final local = await searchInLocalAPI(barcode);
      if (local != null && local['productName'] != null) {
        message = 'Product found in Local API';
        product = {
          'productName': local['productName'],
          'barcode': local['barcode'] ?? barcode,
          'highRiskIngredients': local['highRiskIngredients'] ?? [],
        };
        await AddToHistory().updateHistory(barcode, 'SCANNED');
        ScanDataService().scannedProduct = product;
        ScanDataService().highRiskIngredients = product['highRiskIngredients'];
        return {
          'message': message,
          'product': product,
          'highRiskIngredients': product['highRiskIngredients'],
        };
      }

      /// 2. لو مش موجود، جرّب OpenFoodFacts
      final food = await searchInOpenFoodFacts(context, barcode);
      if (food != null && food['product_name'] != 'Unknown') {
        message = 'Product found in OpenFoodFacts';

        // ابعت البيانات للسيرفر (تم إرسالها داخل الدالة بالفعل)
        // ثم ارجع حللها تاني عن طريق السيرفر المحلي
        final analyzed = await searchInLocalAPI(barcode);

        product = {
          'productName': food['product_name'],
          'barcode': food['code'] ?? barcode,
          'highRiskIngredients': analyzed?['highRiskIngredients'] ?? [],
        };
        await AddToHistory().updateHistory(barcode, 'SCANNED');

        return {
          'message': message,
          'product': product,
          'highRiskIngredients': product['highRiskIngredients'],
        };
      }

      /// 3. لو مش موجود، جرّب OpenBeautyFacts
      final beauty = await searchInOpenBeautyFacts(context, barcode);
      if (beauty != null) {
        final productName = beauty['product_name'] ??
            beauty['generic_name'] ??
            beauty['brands'] ??
            'Unknown';

        if (productName != 'Unknown') {
          message = 'Product found in OpenBeautyFacts';

          // بعد الإرسال، ارجع حلل من السيرفر
          final analyzed = await searchInLocalAPI(barcode);

          product = {
            'productName': productName,
            'barcode': beauty['code'] ?? barcode,
            'highRiskIngredients': analyzed?['highRiskIngredients'] ?? [],
          };

          await AddToHistory().updateHistory(barcode, 'SCANNED');

          return {
            'message': message,
            'product': product,
            'highRiskIngredients': product['highRiskIngredients'],
          };
        }
      }

      return {'message': 'Product not found in any database'};
    } catch (e) {
      return {'message': 'Error during scan: $e'};
    }
  }

  Future<List<dynamic>?> getScannedProducts() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final url = Uri.parse("http://192.168.78.153:8080/history/scanned");
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
