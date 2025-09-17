import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hope/Api/history/history_service.dart';
import 'package:hope/main.dart';
import 'package:hope/ui/screens/home/home.dart';
import 'package:hope/ui/screens/home/tabs/add_tab/add_tab.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/result.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddService {
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static String cleanValue(String value) {
    return value
        .replaceAll(RegExp(r'^I\s*'), '')
        .replaceAll('mog', 'mg')
        .trim();
  }

  static Future<void> addProduct(
      BuildContext context,
      String productName,
      String barcode,
      String ingredientsText, // ← هذا ممكن نستخدمه لو مش Food
      String productType,
      [String? nutrientText]) async {
    final url = Uri.parse("${MyApp.IP}/products/add");

    String? token = await getToken();
    if (token == null) {
      showMessage(context, "Not found!", title: "Error");
      print("Token not found!");
      return;
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    // ✅ نجهّز الـ body مبدئيًا
    final Map<String, dynamic> body = {
      "productName": productName,
      "barcode": barcode,
      "productType": productType,
    };

    if (productType.toUpperCase() == "FOOD" && nutrientText != null) {
      final rawNutrients = parseTextToNutrientMap(nutrientText);
      final cleanedNutrients = rawNutrients.map(
        (key, value) => MapEntry(key, cleanValue(value)),
      );

      print("✅ Nutrient Map to send: $cleanedNutrients");

      // ✅ نرسل العناصر الغذائية داخل حقل ingredients
      final ingredientsList = cleanedNutrients.entries.map((entry) {
        return {
          "ingredientName": entry.key,
          "percentage": entry.value,
        };
      }).toList();

      body["ingredients"] = ingredientsList;
      body["nutrients"] =
          cleanedNutrients; // ← optional if your backend uses it too
    } else {
      // لو مش طعام (مثلاً: Beauty)، استخرج المكونات بالطريقة العادية
      final ingredientsList = extractIngredients(ingredientsText, productType);
      body["ingredients"] = ingredientsList;
    }

    print("📦 Body to send: ${jsonEncode(body)}");

    try {
      showLoading(context);
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );
      hideLoading(context);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final scanResult = await fetchScanResult(barcode);
        await HistoryApiService.addToHistory(barcode, "ADDED");

        showMessage(
          context,
          "Product added successfully!",
          title: "Success",
          posButtonTitle: "Go to result",
          posButtonClick: () {
            Navigator.pushNamed(
              context,
              ResultScreen.routeName,
              arguments: {
                'message': "Product successfully added!",
                'product': {
                  'productName': productName,
                  'barcode': barcode,
                },
                'highRiskIngredients': scanResult?['highRiskIngredients'] ?? [],
              },
            );
          },
          negativeButtonTitle: "OK",
          negativeButtonClick: () {
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        );
      } else {
        showMessage(
          context,
          "Error adding product: ${response.statusCode}",
          title: "Error",
        );
      }
    } catch (e) {
      hideLoading(context);
      print("Error: $e");
      showMessage(context, "Error: $e", title: "Exception");
    }
  }

  static List<Map<String, String>> extractIngredients(
      String text, String productType) {
    final List<Map<String, String>> ingredients = [];

    final items = text.split(RegExp(r'[,-]'));

    for (var item in items) {
      final trimmed = item.trim();
      if (trimmed.isEmpty) continue;

      final parts = trimmed.split(':');
      final ingredientName = parts[0].trim();

      final map = <String, String>{
        "ingredientName": ingredientName,
      };

      if (parts.length > 1) {
        final percentage = parts[1].trim();
        if (percentage.isNotEmpty) {
          map["percentage"] = percentage;
        }
      }

      ingredients.add(map);
    }

    return ingredients;
  }

  // static Map<String, String> parseTextToNutrientMap(String input) {
  //   final lines = input
  //       .split('\n')
  //       .map((e) => e.trim())
  //       .where((e) => e.isNotEmpty)
  //       .toList();
  //
  //   final result = <String, String>{};
  //   final mid = (lines.length / 2).floor();
  //   final keys = lines.sublist(0, mid);
  //   final values = lines.sublist(mid);
  //
  //   for (int i = 0; i < keys.length && i < values.length; i++) {
  //     result[keys[i]] = values[i];
  //   }
  //
  //   return result;
  // }

  static Future<Map<String, dynamic>?> fetchScanResult(String barcode) async {
    try {
      var url = Uri.parse("${MyApp.IP}/api/scan/$barcode");
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

  Future<List<dynamic>?> getAddedProducts() async {
    final url = Uri.parse("${MyApp.IP}/history/added");

    String? token = await getToken();
    if (token == null) {
      print("Token not found!");
      return null;
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print(
            'Failed to fetch added products. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching added products: $e');
      return null;
    }
  }

  static Future<void> addProductAfterScan(
    BuildContext context,
    String productName,
      String barcode,
      String ingredientsText,
    String productType,
  ) async {
    final url = Uri.parse("${MyApp.IP}/products/add");

    String? token = await getToken();
    if (token == null) {
      showMessage(context, "Not found!", title: "Error");
      print("Token not found!");
      return;
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final ingredientsList = extractIngredients(ingredientsText, productType);

    final body = {
      "productName": productName,
      "barcode": barcode,
      "ingredients": ingredientsList,
      "productType": productType,
    };

    if (productType.toUpperCase() == "FOOD") {
      final rawNutrients = parseTextToNutrientMap(ingredientsText);
      final cleanedNutrients = rawNutrients.map(
        (key, value) => MapEntry(key, cleanValue(value)),
      );
      body["nutrients"] = cleanedNutrients;
    }

    try {
      showLoading(context);
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );
      hideLoading(context);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        final scanResult = await fetchScanResult(barcode);

        await HistoryApiService.addToHistory(barcode, "ADDED");

        showMessage(
          context,
          "Product added successfully!",
          title: "Success",
          posButtonTitle: "Go to result",
          posButtonClick: () {
            Navigator.pushNamed(
              context,
              ResultScreen.routeName,
              arguments: {
                'message': "Product successfully added!",
                'product': {
                  'productName': productName,
                  'barcode': barcode,
                },
                'highRiskIngredients': scanResult?['highRiskIngredients'] ?? [],
              },
            );
          },
          negativeButtonTitle: "OK",
          negativeButtonClick: () {
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        );
      } else {
        showMessage(
          context,
          "Error adding product: ${response.statusCode}",
          title: "Error",
        );
      }
    } catch (e) {
      hideLoading(context);
      print("Error: $e");
      showMessage(context, "Error: $e", title: "Exception");
    }
  }

}
