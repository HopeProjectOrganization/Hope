import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Api/chat/chatApi.dart';
import 'package:hope/Api/scan/scan_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:lottie/lottie.dart';

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
    final response = await ChatApiService.sendPrompt(prompt);

    if (response is String) return response;
    if (response is Map || response is List) return jsonEncode(response);
    throw Exception("Unexpected response type: ${response.runtimeType}");
  }

  List<Map<String, String>> parseAlternativesJson(String jsonText) {
    try {
      final dynamic data = jsonDecode(jsonText);

      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map<Map<String, String>>((item) => {
                  'name': item['name']?.toString() ?? '',
                  'reason': item['reason']?.toString() ?? '',
                  'nutritionInfo': item['nutritionInfo']?.toString() ?? '',
                })
            .toList();
      } else {
        throw Exception("Expected a JSON array but got: ${data.runtimeType}");
      }
    } catch (e) {
      throw Exception("❌ JSON decode error: $e");
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
                blurRadius: 2,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: AppColors.yellow),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            onSubmitted: (text) =>
                _isLoading ? null : handleSearch(text.trim()),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.search, color: AppColors.yellow),
            label: const Text('Search for Alternative'),
            onPressed: _isLoading
                ? null
                : () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) handleSearch(text);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.Teal,
              foregroundColor: AppColors.white,
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
        Text.rich(
          TextSpan(
            text: 'Top alternatives to ',
            children: [
              TextSpan(
                text: _productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.yellow,
                ),
              ),
            ],
          ),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.Teal,
          ),
        ),
        const SizedBox(height: 20),
        ListView.builder(
          itemCount: _alternatives.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final alt = _alternatives[index];
            return buildAltCard(alt);
          },
        ),
      ],
    );
  }

  Widget buildAltCard(Map<String, String> alt) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: AppColors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.Teal, width: 1.4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified, color: AppColors.yellow),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      alt['name'] ?? '',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Why it’s better:",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 4),
              Text(
                cleanText(alt['reason'] ?? ''),
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              if ((alt['nutritionInfo'] ?? '').isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text("Nutrition Info:",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: (alt['nutritionInfo']!)
                      .split(',')
                      .map((info) => Chip(
                            label: Text(info.trim()),
                            backgroundColor: AppColors.cloudi,
                            labelStyle: const TextStyle(
                                color: AppColors.dark,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ))
                      .toList(),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadRecentAlternatives() async {
    setState(() => _recentLoaded = false);

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

        try {
          final alt = await getAlternative(name);
          final parsed = parseAlternativesJson(alt);
          loadedAlternatives.add({'name': name, 'alternatives': parsed});
        } catch (_) {}
      }

      setState(() => _productAlternatives = loadedAlternatives);
    } catch (e) {
      showErrorDialog("فشل في تحميل المنتجات الأخيرة: $e");
    } finally {
      setState(() => _recentLoaded = true);
    }
  }

  Widget buildHistoryTab() {
    if (!_recentLoaded) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.yellow),
      );
    }

    if (_productAlternatives.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: Lottie.asset('assets/lottie/empty.json'),
            ),
            const SizedBox(height: 20),
            const Text(
              "No scanned products yet!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.Teal,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _productAlternatives.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final product = _productAlternatives[index];
        final List<dynamic> alternatives = product['alternatives'] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: 'Top alternatives to ',
                children: [
                  TextSpan(
                    text: product['name'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.yellow,
                    ),
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.Teal,
              ),
            ),
            const SizedBox(height: 16),
            ...alternatives
                .map<Widget>((alt) => buildAltCard(
                      Map<String, String>.from(alt),
                    ))
                .toList(),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  String cleanText(String text) {
    return text
        .replaceAll('This product', 'It')
        .replaceAll('this product', 'it')
        .replaceAll('is a good alternative because', 'is healthier because')
        .replaceAll(RegExp(r'\baccording to\b.*?\.'), '')
        .replaceAll(RegExp(r'\bOverall,?\s*'), '')
        .trim();
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.Teal,
                    indicator: BoxDecoration(
                      color: AppColors.Teal,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: 'Search'),
                      Tab(text: 'History'),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

