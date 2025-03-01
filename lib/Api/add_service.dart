import 'package:http/http.dart' as http;
import 'dart:convert';
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

  Future<void> addProduct(
      String productName, String barcode, String ingredientsText) async {
    final url = Uri.parse("http://192.168.1.4:8080/products/add");

    String? token = await getToken();

    if (token == null) {
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
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        print("Product added successfully!");
      } else {
        print("Error adding product: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
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
