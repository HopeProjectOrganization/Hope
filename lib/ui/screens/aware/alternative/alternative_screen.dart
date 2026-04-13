import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/l10n/app_localizations.dart';
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
    final appLocalizations = AppLocalizations.of(context)!;
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
      showErrorDialog(appLocalizations.failedToFetchAlternatives);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String generatePrompt(String productName, AppLocalizations locale) {
    return "${locale.suggestAlternativesFor} $productName";
  }

  Future<String> getAlternative(String productName) async {
    final appLocalizations = AppLocalizations.of(context)!;
    final prompt = generatePrompt(productName, appLocalizations);
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
      throw Exception("JSON decode error: $e");
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.note),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.ok)),
        ],
      ),
    );
  }

  Widget buildManualSearchTab(AppLocalizations locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.Teal.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: locale.search,
              prefixIcon: const Icon(Icons.search, color: AppColors.yellow),
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
            icon: const Icon(Icons.search, color: AppColors.yellow),
            label: Text(locale.searchForAlternative),
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
          buildAlternativesView(locale),
      ],
    );
  }

  Widget buildAlternativesView(AppLocalizations locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: '${locale.topAlternativesTo} ',
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
            return buildAltCard(alt, locale);
          },
        ),
      ],
    );
  }

  Widget buildAltCard(Map<String, String> alt, AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: Theme.of(context).cardColor,
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
              Text(locale.whyBetter,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 4),
              Text(cleanText(alt['reason'] ?? ''),
                  style: const TextStyle(fontSize: 14)),
              if ((alt['nutritionInfo'] ?? '').isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(locale.nutritionInfo,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
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
    final appLocalizations = AppLocalizations.of(context)!;
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
      showErrorDialog(appLocalizations.failedToLoadHistory);
    } finally {
      setState(() => _recentLoaded = true);
    }
  }

  Widget buildHistoryTab(AppLocalizations locale) {
    if (!_recentLoaded) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.yellow));
    }
    if (_productAlternatives.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/lottie/empty.json', height: 200),
            const SizedBox(height: 20),
            Text(locale.noScannedProducts,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.Teal)),
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
                text: '${locale.topAlternativesTo} ',
                children: [
                  TextSpan(
                      text: product['name'] ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.yellow)),
                ],
              ),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.Teal),
            ),
            const SizedBox(height: 16),
            ...alternatives
                .map<Widget>((alt) =>
                    buildAltCard(Map<String, String>.from(alt), locale))
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
        .replaceAll(RegExp(r'\\baccording to\\b.*?\\.'), '')
        .replaceAll(RegExp(r'\\bOverall,?\\s*'), '')
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
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(appLocalizations.alternative),
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors.Teal, width: 1),
              ),
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
                tabs: [
                  Tab(text: appLocalizations.search),
                  Tab(text: appLocalizations.history),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: buildManualSearchTab(appLocalizations),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: buildHistoryTab(appLocalizations),
          ),
        ],
      ),
    );
  }
}
