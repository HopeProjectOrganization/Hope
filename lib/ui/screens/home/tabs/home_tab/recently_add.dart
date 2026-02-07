import 'package:flutter/material.dart';
import 'package:hope/Api/add/add_service.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/ui/shared_widgets/custom_recently_cards.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';

class RecentlyAddedScreen extends StatefulWidget {
  const RecentlyAddedScreen({super.key});

  @override
  _RecentlyAddedScreenState createState() => _RecentlyAddedScreenState();
}

class _RecentlyAddedScreenState extends State<RecentlyAddedScreen> {
  List<dynamic> recentlyAddedProducts = [];
  final AddService _addService = AddService();
  bool isLoading = true;
  late AppLocalizations appLocalizations;

  @override
  void initState() {
    super.initState();
    _loadRecentlyAddedProducts();
  }

  Future<void> _loadRecentlyAddedProducts() async {
    try {
      List<dynamic>? products = await _addService.getAddedProducts();

      if (!mounted) return;

      if (products != null) {
        setState(() {
          recentlyAddedProducts = products.reversed.take(5).toList();
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
          appLocalizations.failedToLoadRecentlyAdded,
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

    if (recentlyAddedProducts.isEmpty) {
      return const SizedBox.shrink(); // لا تعرض شيئاً
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            appLocalizations.recentlyAdded,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.26,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentlyAddedProducts.length,
            itemBuilder: (context, index) {
              final product = recentlyAddedProducts[index];

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
        ),
      ],
    );
  }
}
