import 'package:flutter/material.dart';
import 'package:hope/Api/scan/scan_service.dart';
import 'package:hope/ui/shared_widgets/custom_recently_cards.dart';

class RecentlyScan extends StatefulWidget {
  @override
  _RecentlyScanState createState() => _RecentlyScanState();
}

class _RecentlyScanState extends State<RecentlyScan> {
  List<dynamic> recentlyScannedProducts = [];
  final ScanService scanService = ScanService();

  @override
  void initState() {
    super.initState();
    _loadRecentlyScannedProducts();
  }

  Future<void> _loadRecentlyScannedProducts() async {
    try {
      List<dynamic>? products = await scanService.getScannedProducts();

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
        });
      } else {
        print('No recently scanned products found.');
      }
    } catch (e) {
      print("Error loading scanned products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (recentlyScannedProducts.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          "Recently Scanned",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height * .23,
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
              return SizedBox.shrink();
            }
          },
        ),
      )
    ]);
  }
}
