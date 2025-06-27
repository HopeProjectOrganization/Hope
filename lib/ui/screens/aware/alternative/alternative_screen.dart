// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:hope/core/theme/app_colors.dart';
// import 'package:hope/ui/shared_widgets/custome_tab.dart';
// import 'package:http/http.dart' as http;
//
// class SuggestedReplacementsScreen extends StatefulWidget {
//   static const routeName = '/alternative';
//
//   @override
//   State<SuggestedReplacementsScreen> createState() =>
//       _SuggestedReplacementsScreenState();
// }
//
// class _SuggestedReplacementsScreenState
//     extends State<SuggestedReplacementsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   final List<String> categories = [
//     'dairies',
//     'snacks',
//     'breakfast-cereals',
//     'beverages',
//     'biscuits',
//     'sweetened-beverages',
//     'plant-based-foods',
//     'sweets',
//     'ice-creams',
//     'cheeses',
//     'meals',
//   ];
//
//   Map<String, List<Map<String, dynamic>>> allReplacements = {};
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: categories.length, vsync: this);
//     _tabController.addListener(_handleTabChange);
//     fetchCategoryData(categories[0]); // حمّل أول تبويب بس
//   }
//
//   Future<void> fetchCategoryData(String category) async {
//     if (allReplacements.containsKey(category))
//       return; // لو اتحمّلت قبل كده، متحمّلهاش تاني
//
//     setState(() {
//       isLoading = true;
//     });
//
//     final pairs = await fetchReplacementsForCategory(category);
//     setState(() {
//       allReplacements[category] = pairs;
//       isLoading = false;
//     });
//   }
//
//   void _handleTabChange() {
//     if (_tabController.indexIsChanging) return;
//
//     final currentCategory = categories[_tabController.index];
//     fetchCategoryData(currentCategory);
//   }
//
//   Future<void> fetchAllCategories() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     for (String category in categories) {
//       final pairs = await fetchReplacementsForCategory(category);
//       allReplacements[category] = pairs;
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   Future<List<Map<String, dynamic>>> fetchReplacementsForCategory(
//       String category) async {
//     final encodedQuery = Uri.encodeComponent(category);
//     final url =
//         'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$encodedQuery&search_simple=1&action=process&json=1&page_size=100';
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       try {
//         final data = jsonDecode(response.body);
//         List products = data['products'] ?? [];
//
//         products = products
//             .where((p) =>
//                 p['product_name'] != null &&
//                 p['nutriments'] != null &&
//                 p['categories_tags'] != null &&
//                 (p['categories_tags'] as List).isNotEmpty)
//             .toList();
//
//         List<Map<String, dynamic>> finalPairs = [];
//
//         bool isSimilarName(String a, String b) {
//           final wordsA = a.toLowerCase().split(' ');
//           final lowerB = b.toLowerCase();
//           return wordsA.any((word) => lowerB.contains(word));
//         }
//
//         for (var product in products) {
//           final nutrients = product['nutriments'];
//           final fat = nutrients['fat_100g'] ?? 0.0;
//           final sugar = nutrients['sugars_100g'] ?? 0.0;
//
//           if (fat > 10 || sugar > 10) {
//             final List sameCategory = products.where((p) {
//               final n = p['nutriments'];
//               final f = n['fat_100g'] ?? 0.0;
//               final s = n['sugars_100g'] ?? 0.0;
//
//               return p != product &&
//                   (p['categories_tags'] as List)
//                       .contains((product['categories_tags'] as List).first) &&
//                   f < fat &&
//                   s < sugar;
//             }).toList();
//
//             if (sameCategory.isNotEmpty) {
//               // حاول تلاقي بديل مشابه في الاسم
//               final similarNameAlternatives = sameCategory
//                   .where((alt) => isSimilarName(
//                       product['product_name'], alt['product_name'] ?? ''))
//                   .toList();
//
//               final selectedAlternative = similarNameAlternatives.isNotEmpty
//                   ? similarNameAlternatives.first
//                   : sameCategory.first;
//
//               finalPairs
//                   .add({'unhealthy': product, 'healthy': selectedAlternative});
//             }
//           }
//         }
//
//         return finalPairs.take(10).toList();
//       } catch (e) {
//         print("❌ JSON parse error: $e");
//       }
//     } else {
//       print("❗ Request failed with status: ${response.statusCode}");
//     }
//     return [];
//   }
//
//   Widget buildNutritionComparison(Map<String, dynamic> product) {
//     final nutrients = product['nutriments'] ?? {};
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (nutrients['energy_100g'] != null)
//           Text("Energy: ${nutrients['energy_100g']} kJ"),
//         if (nutrients['fat_100g'] != null)
//           Text("Fat: ${nutrients['fat_100g']} g"),
//         if (nutrients['sugars_100g'] != null)
//           Text("Sugars: ${nutrients['sugars_100g']} g"),
//         if (nutrients['proteins_100g'] != null)
//           Text("Protein: ${nutrients['proteins_100g']} g"),
//       ],
//     );
//   }
//
//   Widget buildReplacementRow(Map<String, dynamic> pair) {
//     final unhealthy = pair['unhealthy'];
//     final healthy = pair['healthy'];
//
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 6,
//       shadowColor: Colors.grey.withOpacity(0.3),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           gradient: LinearGradient(
//             colors: [AppColors.lavender.withOpacity(0.3), Colors.white],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Text(
//             //   "مقارنة المنتج غير الصحي بالبديل الصحي",
//             //   style: TextStyle(
//             //     fontSize: 16,
//             //     fontWeight: FontWeight.bold,
//             //     color: Colors.black87,
//             //   ),
//             //   textAlign: TextAlign.center,
//             // ),
//             // const SizedBox(height: 16),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Unhealthy Product
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "❌ ${unhealthy['product_name']}",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                           color: Colors.red[800],
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       if (unhealthy['image_small_url'] != null)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 6),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.network(
//                               unhealthy['image_small_url'],
//                               height: 80,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       buildNutritionComparison(unhealthy),
//                     ],
//                   ),
//                 ),
//                 // Divider
//                 Container(
//                   width: 1.5,
//                   height: 150,
//                   margin: const EdgeInsets.symmetric(horizontal: 10),
//                   color: Colors.grey[300],
//                 ),
//                 // Healthy Product
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "✅ ${healthy['product_name']}",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                           color: Colors.green[800],
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       if (healthy['image_small_url'] != null)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 6),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.network(
//                               healthy['image_small_url'],
//                               height: 80,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       buildNutritionComparison(healthy),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<Widget> buildTabs() {
//     return categories.map((cat) => CustomeTab(text: cat)).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_outlined),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         toolbarHeight: MediaQuery.of(context).size.height * 0.1,
//         backgroundColor: AppColors.purple,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(20),
//             bottomRight: Radius.circular(20),
//           ),
//         ),
//         centerTitle: true,
//         title: Text("Healthy Alternatives",
//             style: TextStyle(color: AppColors.white)),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorSize: TabBarIndicatorSize.label,
//           isScrollable: true,
//           labelPadding: const EdgeInsets.symmetric(horizontal: 7),
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           tabs: buildTabs(),
//         ),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : TabBarView(
//               controller: _tabController,
//               children: categories.map((cat) {
//                 final replacements = allReplacements[cat];
//                 if (replacements == null) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (replacements.isEmpty) {
//                   return Center(child: Text("No alternatives available"));
//                 }
//                 return ListView(
//                   padding: EdgeInsets.all(8),
//                   children: replacements.map(buildReplacementRow).toList(),
//                 );
//               }).toList(),
//             ),
//     );
//   }
// }
//  static const String _apiKey = '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';
// final barcode = await FlutterBarcodeScanner.scanBarcode(
//         '#ff6666', 'Cancel', true, ScanMode.BARCODE,500,'BACK' , ScanFormat.ONLY_BARCODE);
// دمج Flutter UI مع API داخلي لجلب بدائل صحية من GPT

// بعد التعديل الكامل على الكود، قمنا بربطه ب ChatApiService واستخدام JSON في الرد

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Api/chat/chatApi.dart';
import 'package:hope/Api/scan/scan_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';

class SuggestedReplacementsScreen extends StatelessWidget {
  const SuggestedReplacementsScreen({super.key});
  static const routeName = '/alternative';

  @override
  Widget build(BuildContext context) {
    return const ProductAlternativeScreen();
  }
}

class ProductAlternativeScreen extends StatefulWidget {
  const ProductAlternativeScreen({super.key});

  @override
  State<ProductAlternativeScreen> createState() =>
      _ProductAlternativeScreenState();
}

class _ProductAlternativeScreenState extends State<ProductAlternativeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _controller = TextEditingController();

  bool _isLoading = false;
  bool _recentLoaded = false;

  String _productName = "";
  List<Map<String, String>> _alternatives = [];
  String _note = "";
  List<Map<String, dynamic>> _productAlternatives = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadRecentAlternatives();
  }

  Future<void> handleSearch(String input) async {
    setState(() {
      _isLoading = true;
      _productName = "";
      _alternatives = [];
      _note = "";
    });
    try {
      final response = await getAlternative(input);
      setState(() {
        _productName = input;
        _alternatives = parseAlternativesJson(response);
      });
    } catch (e) {
      showErrorDialog("فشل في جلب البدائل: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<String> getAlternative(String productName) async {
    const promptTemplate = '''
I have a product: "{productName}".
Suggest 3 to 5 healthier alternative products that are widely available, especially in Egypt.
The alternatives must:
- Be similar in purpose (e.g., snack for snack, cereal for cereal).
- Contain less sugar, saturated fat, or harmful additives.
- Be local Egyptian options if possible.
- Be affordable and easy to find in stores or online.
Return the result as a JSON array. Each item must include:
- name
- reason
- nutritionInfo (optional)
''';

    final prompt = promptTemplate.replaceAll('{productName}', productName);
    return await ChatApiService.sendPrompt(prompt);
  }

  List<Map<String, String>> parseAlternativesJson(String jsonText) {
    try {
      final List<dynamic> data = jsonDecode(jsonText);
      return data
          .map<Map<String, String>>((item) => {
                'name': item['name'] ?? '',
                'reason': item['reason'] ?? '',
                'nutritionInfo': item['nutritionInfo'] ?? '',
              })
          .toList();
    } catch (e) {
      throw Exception("فشل في تحليل JSON: $e");
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Note"),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Okay")),
        ],
      ),
    );
  }

  Widget buildManualSearchTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.Teal,
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.yellow,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: _isLoading ? null : scanBarcodeAndSearch,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onSubmitted: (text) =>
                _isLoading ? null : handleSearch(text.trim()),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.search,
              color: AppColors.yellow,
            ),
            label: const Text('Search for Alternative'),
            onPressed: _isLoading
                ? null
                : () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) handleSearch(text);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.Teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 30),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_productName.isNotEmpty && _alternatives.isNotEmpty)
          buildAlternativesView(),
      ],
    );
  }

  Widget buildAlternativesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Alternative for $_productName",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ..._alternatives.map((alt) => Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified,
                            color: Colors.green, size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            alt['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            alt['reason'] ?? '',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    if ((alt['nutritionInfo'] ?? '').isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.local_fire_department,
                              color: AppColors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              alt['nutritionInfo'] ?? '',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.Teal),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
          ),
            )),
      ],
    );
  }

  Future<void> scanBarcodeAndSearch() async {
    final barcode = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel',
        true, ScanMode.BARCODE, 500, 'BACK', ScanFormat.ONLY_BARCODE);

    if (barcode == '-1') return;

    final name = await fetchProductNameFromBarcode(barcode);

    if (name != null && name.isNotEmpty) {
      _controller.text = name;
      await handleSearch(name);
    } else {
      showErrorDialog("Product doesnot exist , Try to enter name of product");
    }
  }

  Future<String?> fetchProductNameFromBarcode(String barcode) async {
    for (final url in [
      "https://world.openfoodfacts.org/api/v2/product/$barcode.json",
      "https://world.openbeautyfacts.org/api/v2/product/$barcode.json"
    ]) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          return data['product']['product_name']?.toString();
        }
      }
    }
    return null;
  }

  Future<void> loadRecentAlternatives() async {
    setState(() {
      _recentLoaded = false;
    });

    try {
      final products = await ScanService().getScannedProducts();
      final Map<String, dynamic> uniqueProducts = {};

      for (var product in products ?? []) {
        if (product is Map<String, dynamic> && product['barcode'] != null) {
          uniqueProducts[product['barcode']] = product;
        }
      }

      final recent = uniqueProducts.values.toList().reversed.take(5).toList();
      final List<Map<String, dynamic>> loadedAlternatives = [];

      for (var product in recent) {
        final name = product['productName'] ?? '';
        if (name.isEmpty) continue;

        final alt = await getAlternative(name);
        final parsed = parseAlternativesJson(alt);

        loadedAlternatives.add({
          'name': name,
          'alternatives': parsed,
        });
      }

      setState(() {
        _productAlternatives = loadedAlternatives;
      });
    } catch (e) {
      showErrorDialog("فشل في تحميل المنتجات الأخيرة: $e");
    } finally {
      setState(() {
        _recentLoaded = true;
      });
    }
  }

  Widget buildHistoryTab() {
    if (!_recentLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_productAlternatives.isEmpty) {
      return const Center(child: Text("There is no Product"));
    }
    return Column(
      children: _productAlternatives.map((product) {
        final List<dynamic> alternatives = product['alternatives'] ?? [];
        return ExpansionTile(
          backgroundColor: Colors.grey[50],
          collapsedBackgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(product['name'],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          children: alternatives
              .map((alt) => ListTile(
                  leading: const Icon(Icons.check_circle_outline,
                      color: Colors.green),
                  title: Text(alt['name'] ?? ''),
                  subtitle: Text(alt['reason'] ?? '')))
              .toList(),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        title: const Text('Alternative'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.Teal,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.Teal,
          tabs: const [
            Tab(text: 'Search'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
              padding: const EdgeInsets.all(20), child: buildManualSearchTab()),
          SingleChildScrollView(
              padding: const EdgeInsets.all(20), child: buildHistoryTab()),
        ],
      ),
    );
  }
}
