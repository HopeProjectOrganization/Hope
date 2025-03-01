import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddService {
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> addProduct(BuildContext context,
      String productName,
      String barcode,
      String ingredientsText) async {
    final url = Uri.parse("http://192.168.1.76:9090/products/add");

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

    final ingredientsList = extractIngredients(ingredientsText);

    final body = {
      "productName": productName,
      "barcode": barcode,
      "ingredients": ingredientsList,
    };

    try {
      showLoading(context);
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        print("Product added successfully!");
        showMessage(context, "Product added successfully!", title: "Success");
      } else {
        print("Error adding product: ${response.statusCode}");
        showMessage(context, "Error adding product: ${response.statusCode}",
            title: "Error");
      }
    } catch (e) {
      print("Error: $e");
      showMessage(context, "Error: $e", title: "Exception");
    } finally {
      // 👇 إخفاء الـ Loading بعد انتهاء العملية
      hideLoading(context);
    }
  }

  List<Map<String, dynamic>> extractIngredients(String text) {
    final ingredients = <Map<String, dynamic>>[];
    final lines = text.split('\n');

    for (var line in lines) {
      final match = RegExp(r'(\w+)\s*(\d+\.?\d*)?%?').firstMatch(line);
      if (match != null) {
        final ingredient = {
          "ingredientName": match.group(1),
          if (match.group(2) != null) "percentage": match.group(2),
        };
        ingredients.add(ingredient);
      }
    }
    return ingredients;
  }
}
