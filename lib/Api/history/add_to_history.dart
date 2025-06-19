// import 'dart:convert';
//
// import 'package:hope/main.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AddToHistory {
//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }
//
//   Future<void> updateHistory(String barcode, String actionType) async {
//     final historyUrl = Uri.parse("http://${MyApp.IP}/history/add");
//
//     String? token = await getToken();
//     if (token == null) {
//       print("Token not found!");
//       return;
//     }
//
//     final headers = {
//       "Content-Type": "application/json",
//       "Authorization": "Bearer $token",
//     };
//
//     final body = {
//       "barcode": barcode,
//       "actionType": actionType,
//     };
//
//     try {
//       var historyResponse = await http.post(
//         historyUrl,
//         headers: headers,
//         body: json.encode(body),
//       );
//
//       if (historyResponse.statusCode == 200) {
//         print('History updated successfully!');
//       } else {
//         print(
//             'Failed to update history. Status code: ${historyResponse.statusCode}');
//       }
//     } catch (e) {
//       print("Error updating history: $e");
//     }
//   }
// }
