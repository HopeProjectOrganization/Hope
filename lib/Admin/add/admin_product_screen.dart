import 'package:flutter/material.dart';
import 'package:hope/Admin/add/admin_form.dart';
import 'package:hope/Api/add/admin_add_service.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/model/product_ingredient.dart';
import 'package:hope/ui/screens/home/tabs/add_tab/add_tab.dart';
import 'package:provider/provider.dart';

class IngredientEntry {
  final int id;
  final String ingredientName;
  final String percentage;

  IngredientEntry({
    required this.id,
    required this.ingredientName,
    required this.percentage,
  });

  Map<String, dynamic> toMap() => {
        'ingredientName': ingredientName,
        'percentage': percentage,
      };
}

class GroupedProduct {
  final int productId;
  final String productName;
  final String barcode;
  final String productType;
  final List<IngredientEntry> ingredients;

  GroupedProduct({
    required this.productId,
    required this.productName,
    required this.barcode,
    required this.productType,
    required this.ingredients,
  });
}

class AdminProductManagementScreen extends StatefulWidget {
  const AdminProductManagementScreen({super.key});
  static const routeName = '/adminAdd';

  @override
  State<AdminProductManagementScreen> createState() =>
      _AdminProductManagementScreenState();
}

class _AdminProductManagementScreenState
    extends State<AdminProductManagementScreen> {
  late Future<List<ProductWithIngredient>> productsFuture;
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() {
    productsFuture = ProductService().fetchAllProductIngredients();
  }

  void refresh() => setState(() => fetchProducts());

  List<GroupedProduct> groupProducts(List<ProductWithIngredient> data) {
    final Map<String, List<ProductWithIngredient>> grouped = {};

    for (var item in data) {
      final key = item.productName + item.barcode;
      grouped.putIfAbsent(key, () => []).add(item);
    }

    return grouped.entries.map((entry) {
      final items = entry.value;
      final first = items.first;

      return GroupedProduct(
        productId: first.productId,
        productName: first.productName,
        barcode: first.barcode,
        productType: first.productType,
        ingredients: items
            .map((e) => IngredientEntry(
                  id: e.id,
                  ingredientName: e.ingredientName,
                  percentage: e.percentage,
                ))
            .toList(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: FutureBuilder<List<ProductWithIngredient>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final groupedProducts = groupProducts(snapshot.data!);

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FixedColumnWidth(150),
                  1: FixedColumnWidth(100),
                  2: FixedColumnWidth(100),
                  3: FixedColumnWidth(250),
                  4: IntrinsicColumnWidth(),
                },
                children: [
                  // Header row
                  TableRow(
                    decoration: const BoxDecoration(color: AppColors.yellow),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(appLocalizations.productName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(appLocalizations.barcode,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(appLocalizations.productType,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(appLocalizations.ingredients,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(appLocalizations.actions,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  // Data rows
                  ...groupedProducts.map((product) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(product.productName),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(product.barcode),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(product.productType),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.ingredients
                                .map((e) =>
                                    "${e.ingredientName} (${e.percentage})")
                                .join(", "),
                            softWrap: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: AppColors.Teal),
                                onPressed: () async {
                                  final updated = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AdminAddEditProductScreen(
                                        groupedProduct: product,
                                      ),
                                    ),
                                  );
                                  if (updated == true) refresh();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: AppColors.red),
                                onPressed: () async {
                                  final confirm = await showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title:
                                          Text(appLocalizations.confirmDelete),
                                      content: Text(
                                          appLocalizations.deleteThisProduct),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: Text(appLocalizations.cancel),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          child: Text(appLocalizations.delete),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await ProductService()
                                        .deleteProductIngredient(
                                            product.productId);
                                    refresh();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.Teal,
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTab()),
          );
          if (added == true) refresh();
        },
        child: const Icon(Icons.add, color: AppColors.yellow),
      ),
    );
  }
}
