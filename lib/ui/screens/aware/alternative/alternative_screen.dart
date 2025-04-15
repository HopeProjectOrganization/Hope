import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/shared_widgets/custome_tab.dart';
import 'package:http/http.dart' as http;

class SuggestedReplacementsScreen extends StatefulWidget {
  static const routeName = '/alternative';

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

        for (var product in products) {
          final nutrients = product['nutriments'];
          final fat = nutrients['fat_100g'] ?? 0.0;
          final sugar = nutrients['sugars_100g'] ?? 0.0;

          // لو المنتج عالي في fat أو sugar
          if (fat > 10 || sugar > 10) {
            // دور على منتج تاني من نفس التصنيف fat و sugar فيه أقل
            final sameCategory = products.where((p) {
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
              final healthyAlternative = sameCategory.first;
              finalPairs
                  .add({'unhealthy': product, 'healthy': healthyAlternative});
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
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Unhealthy product
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("❌ ${unhealthy['product_name']}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      if (unhealthy['image_small_url'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Image.network(unhealthy['image_small_url'],
                              height: 80),
                        ),
                      buildNutritionComparison(unhealthy),
                    ],
                  ),
                ),
                Container(
                    width: 1,
                    color: Colors.grey[300],
                    margin: EdgeInsets.symmetric(horizontal: 10)),
                // Healthy product
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("✅ ${healthy['product_name']}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      if (healthy['image_small_url'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Image.network(healthy['image_small_url'],
                              height: 80),
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
        title: Text("Healthy Alternatives",
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
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: categories.map((cat) {
                final replacements = allReplacements[cat];
                if (replacements == null) {
                  return Center(child: CircularProgressIndicator());
                } else if (replacements.isEmpty) {
                  return Center(child: Text("No alternatives available"));
                }
                return ListView(
                  padding: EdgeInsets.all(8),
                  children: replacements.map(buildReplacementRow).toList(),
                );
              }).toList(),
            ),
    );
  }
}
