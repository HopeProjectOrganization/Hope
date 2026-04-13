import 'package:flutter/material.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/Api/scan/scan_service.dart';
import 'package:hope/ui/shared_widgets/custom_recently_cards.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';

class RecentlyScan extends StatefulWidget {
  const RecentlyScan({super.key});

  @override
  _RecentlyScanState createState() => _RecentlyScanState();
}

class _RecentlyScanState extends State<RecentlyScan> {
  List<dynamic> recentlyScannedProducts = [];
  final ScanService scanService = ScanService();
  late AppLocalizations appLocalizations;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentlyScannedProducts();
  }

  Future<void> _loadRecentlyScannedProducts() async {
    try {
      List<dynamic>? products = await scanService.getScannedProducts();

      if (!mounted) return;

      if (products != null) {
        Map<String, dynamic> uniqueProductsMap = {};

        for (var product in products) {
          if (product is Map<String, dynamic> &&
              product.containsKey('barcode')) {
            uniqueProductsMap[product['barcode']] = product;
          }
        }

        setState(() {
          recentlyScannedProducts =
              uniqueProductsMap.values.toList().reversed.take(5).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          context,
          appLocalizations.failedToLoadRecentScan,
          type: MessageType.error,
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (recentlyScannedProducts.isEmpty) {
      return const SizedBox.shrink(); // لا تعرض شيئًا
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            appLocalizations.recentlyScanned,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .26,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentlyScannedProducts.length,
            itemBuilder: (context, index) {
              final product = recentlyScannedProducts[index];

              if (product is Map<String, dynamic>) {
                return CustomRecentlyCard(
                  product: product,
                  barcode: product['barcode'] ?? '',
                  highRiskIngredients: product['highRiskIngredients'] ?? [],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        )
      ],
    );
  }
}
