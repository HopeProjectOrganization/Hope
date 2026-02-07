// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OpenAI Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//       ),
//       home: const OpenAIScreen(),
//     );
//   }
// }
//
// class OpenAIScreen extends StatefulWidget {
//   const OpenAIScreen({super.key});
//
//   @override
//   State<OpenAIScreen> createState() => _OpenAIScreenState();
// }
//
// class _OpenAIScreenState extends State<OpenAIScreen> {
//   final TextEditingController _controller = TextEditingController();
//   String _response = "";
//   bool _loading = false;
//   bool _isWaiting = false;
//   // static const String _apiKey = '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'; // حط هنا مفتاحك
//   static const String _apiKey = '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';
//
//   Future<void> sendToOpenAI(String prompt) async {
//     if (_isWaiting) return; // تمنع إرسال طلب آخر أثناء انتظار الرد
//
//     setState(() {
//       _loading = true;
//       _isWaiting = true;
//       _response = "";
//     });
//
//     try {
//       final url = Uri.parse('http://openrouter.ai/api/v1/chat/completions');
//
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $_apiKey',
//         },
//         body: jsonEncode({
//           'model': 'deepseek/deepseek-r1-0528-qwen3-8b:free',
//           'messages': [
//             {'role': 'user', 'content': prompt}
//           ],
//           'max_tokens': 150,
//           'temperature': 0.7,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         final message = data['choices'][0]['message'];
//         String content = message['content'];
//
//         // إذا content فاضي، جرب تجيب من reasoning
//         if (content == null || content.isEmpty) {
//           content = message['reasoning'] ?? "No response content.";
//         }
//
//         setState(() {
//           _response = content;
//         });
//
//         print("content is " + _response);
//       }
//       else if (response.statusCode == 429) {
//         setState(() {
//           _response = "Error 429: Too Many Requests. Please wait and try again later.";
//         });
//       }else {
//     final errorData = jsonDecode(response.body);
//     setState(() {
//     _response = "Error ${response.statusCode}: ${response.reasonPhrase}\n${errorData.toString()}";
//     });
//     }
//
//     } catch (e) {
//       setState(() {
//         _response = "An error occurred: $e";
//       });
//     } finally {
//       setState(() {
//         _loading = false;
//         _isWaiting = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('OpenAI Integration'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Enter product name or barcode',
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _loading
//                   ? null
//                   : () {
//                 final text = _controller.text.trim();
//                 if (text.isNotEmpty) {
//                   // هنا ممكن تخصص البرومبت لو حابب
//                   final prompt = "Suggest healthier alternatives for this product by usin open food fact : $text";
//                   sendToOpenAI(prompt);
//                 }
//               },
//               child: _loading
//                   ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//               )
//                   : const Text('Get Healthier Alternatives'),
//             ),
//             const SizedBox(height: 30),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Text(
//                   _response,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//  static cons
//String _apiKey = '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';
// import 'package:hope/Api/scan/scan_service.dart';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:simple_barcode_scanner/enum.dart';
// import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';
//
// void main() {
//   runApp(const ProductAlternativeApp());
// }
//
// class ProductAlternativeApp extends StatelessWidget {
//   const ProductAlternativeApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Product Alternatives',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         scaffoldBackgroundColor: const Color(0xFFF2F4F5),
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const ProductAlternativeScreen(),
//     );
//   }
// }
//
// class ProductAlternativeScreen extends StatefulWidget {
//   const ProductAlternativeScreen({super.key});
//
//   @override
//   State<ProductAlternativeScreen> createState() =>
//       _ProductAlternativeScreenState();
// }
//
// class _ProductAlternativeScreenState extends State<ProductAlternativeScreen> {
//   final TextEditingController _controller = TextEditingController();
//   bool _loading = false;
//   String _productName = "";
//   List<String> _alternatives = [];
//   List<Map<String, dynamic>> _productAlternatives = [];
//   String _note = "";
//
//   @override
//   void initState() {
//     super.initState();
//     loadRecentAlternatives();
//   }
//
//   static const String _apiKey =
//       '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';
//
//   Future<String?> fetchProductNameFromBarcode(String barcode) async {
//     for (final baseUrl in [
//       "https://world.openfoodfacts.org/api/v2/product/$barcode.json",
//       "https://world.openbeautyfacts.org/api/v2/product/$barcode.json"
//     ]) {
//       final response = await http.get(Uri.parse(baseUrl));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == 1 && data['product']['product_name'] != null) {
//           return data['product']['product_name'].toString();
//         }
//       }
//     }
//     return null;
//   }
//
//   Future<void> handleSearch(String input) async {
//     setState(() {
//       _loading = true;
//       _productName = "";
//       _alternatives = [];
//       _note = "";
//     });
//     try {
//       final response = await getAlternative(input);
//       setState(() {
//         _productName = input;
//         _alternatives = parseAlternatives(response);
//         _note = extractNote(response);
//       });
//     } catch (e) {
//       showErrorDialog("Error: $e");
//     }
//     setState(() => _loading = false);
//   }
//
//   Future<void> scanBarcodeAndSearch() async {
//     final barcode = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel',
//         true, ScanMode.BARCODE, 500, "BACK", ScanFormat.ONLY_BARCODE);
//
//     if (barcode == '-1') return;
//
//     setState(() {
//       _loading = true;
//       _alternatives = [];
//       _productName = "";
//       _note = "";
//     });
//
//     final name = await fetchProductNameFromBarcode(barcode);
//
//     if (name != null && name.isNotEmpty) {
//       await handleSearch(name);
//     } else {
//       showErrorDialog("Product not found. Try entering the name manually.");
//       setState(() => _loading = false);
//     }
//   }
//
//   Future<void> loadRecentAlternatives() async {
//     setState(() {
//       _loading = true;
//       _productAlternatives.clear();
//     });
//
//     try {
//       final products = await ScanService().getScannedProducts();
//
//       // نحافظ على uniqueness
//       final Map<String, dynamic> uniqueProductsMap = {};
//       for (var product in products ?? []) {
//         if (product is Map<String, dynamic> && product.containsKey('barcode')) {
//           uniqueProductsMap[product['barcode']] = product;
//         }
//       }
//
//       final recent =
//           uniqueProductsMap.values.toList().reversed.take(5).toList();
//
//       for (var product in recent) {
//         final name = product['productName'] ?? '';
//         if (name.isEmpty) continue;
//
//         final alt = await getAlternative(name);
//         final parsed = parseAlternatives(alt);
//
//         _productAlternatives.add({
//           'name': name,
//           'alternatives': parsed,
//         });
//
//         // عشان نعرض واحدة واحدة
//         setState(() {});
//       }
//     } catch (e) {
//       showErrorDialog("Error: $e");
//     }
//
//     setState(() {
//       _loading = false;
//     });
//   }
//
//   Future<String> getAlternative(String productName) async {
//     final url = Uri.parse('http://openrouter.ai/api/v1/chat/completions');
//     final response = await http.post(url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $_apiKey',
//         },
//         body: jsonEncode({
//           'model': 'meta-llama/llama-4-maverick:free',
//           'messages': [
//             {
//               'role': 'user',
//               'content':
//                   "Suggest healthier Egyptian product , with same category Product ,  beauty/food product alternatives to: $productName. List them clearly as a bullet list without intro. Also include a short reason or note after the list prefixed with 'Note:'."
//             }
//           ],
//           'max_tokens': 200,
//           'temperature': 0.7,
//         }));
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['choices'][0]['message']['content'].toString().trim();
//     } else {
//       throw 'Error ${response.statusCode}';
//     }
//   }
//
//   List<String> parseAlternatives(String text) {
//     final lines = text.split(RegExp(r'\n|\r'));
//     return lines
//         .where((line) =>
//             line.trim().isNotEmpty && !line.toLowerCase().startsWith("note:"))
//         .map((line) => line.replaceAll(RegExp(r'^[-*\d.\s]+'), ''))
//         .toList();
//   }
//
//   String extractNote(String text) {
//     final noteMatch = RegExp(r'(?i)note[:\s]*(.*)').firstMatch(text);
//     return noteMatch != null ? noteMatch.group(1)!.trim() : "";
//   }
//
//   void showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Notice"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("OK"),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget buildAlternativesView() {
//     if (_productName.isEmpty || _alternatives.isEmpty) return const SizedBox();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           _productName,
//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         ..._alternatives.map((alt) => Card(
//               margin: const EdgeInsets.symmetric(vertical: 6),
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding: const EdgeInsets.all(14),
//                 child: Text(alt, style: const TextStyle(fontSize: 15)),
//               ),
//             )),
//         if (_note.isNotEmpty)
//           Card(
//             color: Colors.yellow[100],
//             margin: const EdgeInsets.only(top: 16),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(14),
//               child: Text("\u{1F4DD} $_note",
//                   style: const TextStyle(fontSize: 15)),
//             ),
//           ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product Alternatives'),
//         centerTitle: true,
//         backgroundColor: Colors.green.shade700,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 hintText: 'Enter or scan product name',
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.qr_code_scanner),
//                   onPressed: _loading ? null : scanBarcodeAndSearch,
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               onSubmitted: (text) =>
//                   _loading ? null : handleSearch(text.trim()),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.search),
//               label: const Text('Find Alternatives'),
//               onPressed: _loading
//                   ? null
//                   : () {
//                       final text = _controller.text.trim();
//                       if (text.isNotEmpty) handleSearch(text);
//                     },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green.shade700,
//                 foregroundColor: Colors.white,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             if (_loading) const CircularProgressIndicator(color: Colors.green),
//             if (!_loading) buildAlternativesView(),
//           ],
//         ),
//       ),
//     );
//   }
// }
