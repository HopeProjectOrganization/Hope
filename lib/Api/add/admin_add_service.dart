import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/product_ingredient.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl = '${MyApp.IP}/products'; // replace

  Future<List<ProductWithIngredient>> fetchAllProductIngredients() async {
    final response = await http.get(Uri.parse('$baseUrl/all'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => ProductWithIngredient.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<void> addProduct(ProductWithIngredient p) async {
    final body = {
      'product': {
        'productName': p.productName,
        'barcode': p.barcode,
        'productType': p.productType
      },
      'ingredient': {
        'ingredientName': p.ingredientName,
        'percentage': p.percentage
      }
    };
    final res = await http.post(Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(body));
    if (res.statusCode != 200) {
      throw Exception("Failed to add product");
    }
  }

  Future<void> updateProductIngredient(int id, ProductWithIngredient p) async {
    final body = {
      'product': {
        'productName': p.productName,
        'barcode': p.barcode,
        'productType': p.productType
      },
      'ingredientName': p.ingredientName,
      'percentage': p.percentage
    };
    final res = await http.put(Uri.parse('$baseUrl/full-update/$id'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(body));
    if (res.statusCode != 200) {
      throw Exception("Failed to update");
    }
  }

  Future<void> deleteProductIngredient(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/delete/product/$id'));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Failed to delete");
    }
  }

  Future<void> addProductFromMap(Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/products/add");
    final response = await http.post(url, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      throw Exception("Failed to add product");
    }
  }

  Future<void> updateProductFromMap(int id, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/full-update/$id");
    final response = await http.put(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    print("🧾 Update response code: ${response.statusCode}");
    print("🧾 Response body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to update product");
    }

    if (response.statusCode != 200) {
      throw Exception("Failed to update product");
    }
  }
}
