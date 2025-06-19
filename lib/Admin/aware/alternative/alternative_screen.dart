import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/shared_widgets/custome_tab.dart';
import 'package:http/http.dart' as http;

class SuggestedReplacementsScreen extends StatefulWidget {
  static const routeName = '/adminAlternative';

  @override
  State<SuggestedReplacementsScreen> createState() =>
      _SuggestedReplacementsScreenState();
}

class _SuggestedReplacementsScreenState
    extends State<SuggestedReplacementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> categories = [
    'dairies',
    'snacks',
    'breakfast-cereals',
    'beverages',
    'biscuits',
    'sweetened-beverages',
    'plant-based-foods',
    'sweets',
    'ice-creams',
    'cheeses',
    'meals',
  ];

  Map<String, List<Map<String, dynamic>>> allReplacements = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    fetchCategoryData(categories[0]); // حمّل أول تبويب بس
  }

  Future<void> fetchCategoryData(String category) async {
    if (allReplacements.containsKey(category))
      return; // لو اتحمّلت قبل كده، متحمّلهاش تاني

    setState(() {
      isLoading = true;
    });

    final pairs = await fetchReplacementsForCategory(category);
    setState(() {
      allReplacements[category] = pairs;
      isLoading = false;
    });
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    final currentCategory = categories[_tabController.index];
    fetchCategoryData(currentCategory);
  }

  Future<void> fetchAllCategories() async {
    setState(() {
      isLoading = true;
    });

    for (String category in categories) {
      final pairs = await fetchReplacementsForCategory(category);
      allReplacements[category] = pairs;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> fetchReplacementsForCategory(
      String category) async {
    final encodedQuery = Uri.encodeComponent(category);
    final url =
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$encodedQuery&search_simple=1&action=process&json=1&page_size=100';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        List products = data['products'] ?? [];

        products = products
            .where((p) =>
                p['product_name'] != null &&
                p['nutriments'] != null &&
                p['categories_tags'] != null &&
                (p['categories_tags'] as List).isNotEmpty)
            .toList();

        List<Map<String, dynamic>> finalPairs = [];

        bool isSimilarName(String a, String b) {
          final wordsA = a.toLowerCase().split(' ');
          final lowerB = b.toLowerCase();
          return wordsA.any((word) => lowerB.contains(word));
        }

        for (var product in products) {
          final nutrients = product['nutriments'];
          final fat = nutrients['fat_100g'] ?? 0.0;
          final sugar = nutrients['sugars_100g'] ?? 0.0;

          if (fat > 10 || sugar > 10) {
            final List sameCategory = products.where((p) {
              final n = p['nutriments'];
              final f = n['fat_100g'] ?? 0.0;
              final s = n['sugars_100g'] ?? 0.0;

              return p != product &&
                  (p['categories_tags'] as List)
                      .contains((product['categories_tags'] as List).first) &&
                  f < fat &&
                  s < sugar;
            }).toList();

            if (sameCategory.isNotEmpty) {
              // حاول تلاقي بديل مشابه في الاسم
              final similarNameAlternatives = sameCategory
                  .where((alt) => isSimilarName(
                      product['product_name'], alt['product_name'] ?? ''))
                  .toList();

              final selectedAlternative = similarNameAlternatives.isNotEmpty
                  ? similarNameAlternatives.first
                  : sameCategory.first;

              finalPairs
                  .add({'unhealthy': product, 'healthy': selectedAlternative});
            }
          }
        }

        return finalPairs.take(10).toList();
      } catch (e) {
        print("❌ JSON parse error: $e");
      }
    } else {
      print("❗ Request failed with status: ${response.statusCode}");
    }
    return [];
  }

  Widget buildNutritionComparison(Map<String, dynamic> product) {
    final nutrients = product['nutriments'] ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (nutrients['energy_100g'] != null)
          Text("Energy: ${nutrients['energy_100g']} kJ"),
        if (nutrients['fat_100g'] != null)
          Text("Fat: ${nutrients['fat_100g']} g"),
        if (nutrients['sugars_100g'] != null)
          Text("Sugars: ${nutrients['sugars_100g']} g"),
        if (nutrients['proteins_100g'] != null)
          Text("Protein: ${nutrients['proteins_100g']} g"),
      ],
    );
  }

  Widget buildReplacementRow(Map<String, dynamic> pair) {
    final unhealthy = pair['unhealthy'];
    final healthy = pair['healthy'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [AppColors.lavender.withOpacity(0.3), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text(
            //   "مقارنة المنتج غير الصحي بالبديل الصحي",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black87,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            // const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Unhealthy Product
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "❌ ${unhealthy['product_name']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.red[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (unhealthy['image_small_url'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              unhealthy['image_small_url'],
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      buildNutritionComparison(unhealthy),
                    ],
                  ),
                ),
                // Divider
                Container(
                  width: 1.5,
                  height: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.grey[300],
                ),
                // Healthy Product
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "✅ ${healthy['product_name']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.green[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (healthy['image_small_url'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              healthy['image_small_url'],
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      buildNutritionComparison(healthy),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildTabs() {
    return categories.map((cat) => CustomeTab(text: cat)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        backgroundColor: AppColors.purple,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        title: const Text("Healthy Alternatives",
            style: TextStyle(color: AppColors.white)),
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
          labelPadding: const EdgeInsets.symmetric(horizontal: 7),
          padding: const EdgeInsets.symmetric(vertical: 10),
          tabs: buildTabs(),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: categories.map((cat) {
                final replacements = allReplacements[cat];
                if (replacements == null) {
                  return const Center(child: CircularProgressIndicator());
                } else if (replacements.isEmpty) {
                  return const Center(child: Text("No alternatives available"));
                }
                return ListView(
                  padding: const EdgeInsets.all(8),
                  children: replacements.map(buildReplacementRow).toList(),
                );
              }).toList(),
            ),
    );
  }
}
