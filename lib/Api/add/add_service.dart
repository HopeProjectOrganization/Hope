import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hope/Api/history/add_to_history.dart';
import 'package:hope/Api/history/history_service.dart';
import 'package:hope/main.dart';
import 'package:hope/ui/screens/home/home.dart';
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

  static Future<void> addProduct(BuildContext context, String productName,
    String barcode,
    String ingredientsText,
    String productType,
  ) async {
    final url = Uri.parse("http://${MyApp.IP}/products/add");

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
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        print(responseData['highRiskIngredients']);

        final scanResult = await fetchScanResult(barcode);

        if (responseData['id'] != null) {
          print("Product added successfully!");

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
                  'highRiskIngredients':
                      scanResult?['highRiskIngredients'] ?? [],
                },
              );
            },
            negativeButtonTitle: "OK",
            negativeButtonClick: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          );
        } else {
          print("Error adding product: ${response.statusCode}");
          showMessage(context, "Error adding product: ${response.statusCode}",
              title: "Error");
        }
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

  static Future<void> addProductAfterScan(BuildContext context,
      String productName,
      String barcode,
      String ingredientsText,
      String productType) async {
    final url = Uri.parse("http://${MyApp.IP}/products/add");

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

        // Assuming highRiskIngredients is part of responseData after product addition
        final highRiskIngredients = responseData['highRiskIngredients'] ?? [];

        // Show result screen
        Navigator.pushNamed(
          context,
          ResultScreen.routeName,
          arguments: {
            'message': "Product added successfully!",
            'product': {
              'productName': productName,
              'barcode': barcode,
            },
            'highRiskIngredients': highRiskIngredients,
          },
        );
      } else {
        showMessage(context, "Error adding product: ${response.statusCode}",
            title: "Error");
      }
    } catch (e) {
      hideLoading(context);
      print("Error: $e");
      showMessage(context, "Error: $e", title: "Exception");
    }
  }

  static Future<Map<String, dynamic>?> fetchScanResult(String barcode) async {
    try {
      var url = Uri.parse("http://${MyApp.IP}/api/scan/$barcode");
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

  static String extractIngredients(String text, String productType) {
    //TextRecognitionService text = TextRecognitionService();
    // final List<Map<String, dynamic>> ingredients = [];
    //   final ingredientNames = text.split(RegExp(r'[,-]'));
    //   for (var name in ingredientNames) {
    //     final ingredient = {
    //       "ingredientName": name.trim(),
    //     };
    //     ingredients.add(ingredient);
    //  }
    // } if (productType == 'FOOD'){
    //
    // }
    return '';
  }

  Future<List<dynamic>?> getAddedProducts() async {
    final url = Uri.parse("http://${MyApp.IP}/history/added");

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
}