import 'package:flutter/material.dart';
import 'package:hope/Api/add/add_service.dart';
import 'package:hope/ui/shared_widgets/custom_recently_cards.dart';

class RecentlyAddedScreen extends StatefulWidget {
  @override
  _RecentlyAddedScreenState createState() => _RecentlyAddedScreenState();
}

class _RecentlyAddedScreenState extends State<RecentlyAddedScreen> {
  List<dynamic> recentlyAddedProducts = [];
  final AddService _addService = AddService();

  @override
  void initState() {
    super.initState();
    _loadRecentlyAddedProducts();
  }

  Future<void> _loadRecentlyAddedProducts() async {
    try {
      List<dynamic>? products = await _addService.getAddedProducts();

      if (products != null) {
        setState(() {
          recentlyAddedProducts = products.reversed.take(5).toList();
        });
      } else {
        print("No recently added products found.");
      }
    } catch (e) {
      print("Error loading recently added products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (recentlyAddedProducts.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Recently Added",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .26,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentlyAddedProducts.length,
            itemBuilder: (context, index) {
              final product = recentlyAddedProducts[index];

              if (product is Map<String, dynamic>) {
                return CustomRecentlyCard(
                  product: product,
                  barcode: product['barcode'],
                  highRiskIngredients: product['highRiskIngredients'] ?? [],
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
