import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ScanService {
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Function to search for product in your local API
  Future<Map<String, dynamic>?> searchInLocalAPI(String barcode) async {
    var url = Uri.parse("http://192.168.8.222:8080/api/scan/$barcode");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // final addToHistory = AddToHistory();
      // await addToHistory.updateHistory(barcode, "SCANNED");

      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return {'message': 'Failed to fetch data from the server'};
    }
  }

  // Function to search for product in OpenFoodFacts API
  Future<Map<String, dynamic>?> searchInOpenFoodFacts(String barcode) async {
    var url = Uri.parse(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // إذا تم العثور على المنتج
      if (data['status'] == 1) {
        var productData = data['product'];

        // بعد الحصول على بيانات المنتج من OpenFoodFacts، أرسل الـ barcode إلى Local API
        await searchInLocalAPI(barcode);

        // إعادة البيانات من OpenFoodFacts بعد إرسالها إلى الـ Local API
        return productData;
      }
    }
    return null;
  }

  // Function to search for product in OpenBeautyFacts API
  Future<Map<String, dynamic>?> searchInOpenBeautyFacts(String barcode) async {
    var url = Uri.parse(
        'https://world.openbeautyfacts.org/api/v0/product/$barcode.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // التحقق من حالة الرد إذا كان المنتج موجودًا
      if (data['status'] == 1) {
        var productData = data['product'];

        // بعد الحصول على بيانات المنتج من OpenBeautyFacts، أرسل الـ barcode إلى Local API
        await searchInLocalAPI(barcode);

        // إعادة البيانات من OpenBeautyFacts بعد إرسالها إلى الـ Local API
        return productData;
      } else {
        print("Product not found in OpenBeautyFacts.");
        return null;
      }
    } else {
      print(
          'Failed to fetch from OpenBeautyFacts. Status code: ${response.statusCode}');
      return null;
    }
  }

  // Main function to handle scanning and searching in all databases
  Future<Map<String, dynamic>?> scanBarcode(BuildContext context) async {
    try {
      // مسح الباركود
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

      // البحث في Local API أولاً
      var localData = await searchInLocalAPI(barcode);
      if (localData != null) {
        return localData;
      }

      // البحث في OpenFoodFacts
      var foodData = await searchInOpenFoodFacts(barcode);
      if (foodData != null) {
        return foodData;
      }

      // البحث في OpenBeautyFacts
      var beautyData = await searchInOpenBeautyFacts(barcode);
      if (beautyData != null) {
        return beautyData;
      }

      return {'message': 'Product not found in any database'};
    } catch (e) {
      return {'message': 'Error occurred during scanning: $e'};
    }
  }

  // Function to retrieve scanned products history
  Future<List<dynamic>?> getScannedProducts() async {
    try {
      String? token = await getToken();
      if (token == null) {
        print("Token not found!");
        return null;
      }

      var url = Uri.parse("http://192.168.8.222:8080/history/scanned");

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print(
            'Failed to fetch scanned products. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching scanned products: $e');
      return null;
    }
  }
}
