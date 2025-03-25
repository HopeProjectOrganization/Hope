import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hope/Api/add/fetchProductData.dart';
import 'package:hope/Api/history/add_to_history.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ScanService {
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>?> scanBarcode(BuildContext context) async {
    // await ProductImporter.fetchAndAddProducts(context);
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

      var url = Uri.parse("http://192.168.1.191:8081/api/scan/$barcode");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final addToHistory = AddToHistory();
        await addToHistory.updateHistory(barcode, "SCANNED");

        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {'message': 'Failed to fetch data from the server'};
      }
    } catch (e) {
      return {'message': 'Error occurred during scanning: $e'};
    }
  }

  Future<List<dynamic>?> getScannedProducts() async {
    try {
      String? token = await getToken();
      if (token == null) {
        print("Token not found!");
        return null;
      }

      var url = Uri.parse("http://192.168.78.153:8080/history/scanned");

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // إضافة الـ token إلى الهيدر
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
