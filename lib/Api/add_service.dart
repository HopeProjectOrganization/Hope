import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hope/ui/screens/home/home.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/result.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/scan_tab.dart';
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
    final url = Uri.parse("http://192.168.1.109:9090/products/add");

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
      hideLoading(context);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final responseData = json.decode(response.body);

        if (responseData['id'] != null) {
          print("Product added successfully!");
        showMessage(
          context,
          "Product added successfully!",
          title: "Success",
          posButtonTitle: "Go to result",
          posButtonClick: () {
            Navigator.pushNamed(context, ScanTab.routeName);
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
    }else {
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

  List<Map<String, dynamic>> extractIngredients(String text) {
    final List<Map<String, dynamic>> ingredients = [];

    // final ingredientNames = text.split(RegExp(r'[,-]'));
    final ingredientNames = text.split(RegExp(r'[\s,;-]+'));
    for (var name in ingredientNames) {
      final ingredient = {
        "ingredientName": name.trim(),
      };
      ingredients.add(ingredient);
    }

    return ingredients;
  }
}
