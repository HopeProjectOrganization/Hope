import 'dart:convert';

import 'package:hope/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoryApiService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // 1️⃣ إضافة منتج إلى الهيستوري
  static Future<void> addToHistory(String barcode, String actionType) async {
    final url = Uri.parse("https://${MyApp.IP}/history/add");

    String? token = await getToken();
    if (token == null) {
      print("Token not found!");
      return;
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = {
      "barcode": barcode,
      "actionType": actionType,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        print('History updated successfully!');
      } else {
        print('Failed to update history. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error updating history: $e");
    }
  }

  // 2️⃣ جلب المنتجات الممسوحة
  static Future<List<dynamic>> getScannedProducts() async {
    return await _fetchHistory("SCANNED");
  }

  // 3️⃣ جلب المنتجات المضافة
  static Future<List<dynamic>> getAddedProducts() async {
    return await _fetchHistory("ADDED");
  }

  // دالة خاصة مشتركة لجلب البيانات من الهيستوري
  static Future<List<dynamic>> _fetchHistory(String type) async {
    final url = Uri.parse("https://${MyApp.IP}/history/$type");

    String? token = await getToken();
    if (token == null) {
      print("Token not found!");
      return [];
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to fetch history. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print("Error fetching history: $e");
      return [];
    }
  }
}
