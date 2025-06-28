import 'package:flutter/material.dart';
import 'package:hope/Admin/add/admin_form.dart';
import 'package:hope/Api/add/admin_add_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/product_ingredient.dart';
import 'package:hope/ui/screens/home/tabs/add_tab/add_tab.dart';

class IngredientEntry {
  final int id; // لازم علشان نعرف نعدل المكون ده بالذات
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
  final int productId; // ✅ ده ID المنتج مش المكون
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
        // ✅ استخدمي ID المنتج الحقيقي
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
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Products")),
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
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Product Name")),
                  DataColumn(label: Text("Barcode")),
                  DataColumn(label: Text("Type")),
                  DataColumn(label: Text("Ingredients")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: groupedProducts.map((product) {
                  return DataRow(cells: [
                    DataCell(Text(product.productName)),
                    DataCell(Text(product.barcode)),
                    DataCell(Text(product.productType)),
                    DataCell(Text(product.ingredients
                        .map((e) =>
                            "${e.ingredientName} (${e.percentage ?? 'N/A'})")
                        .join(", "))),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.teal),
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
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: const Text("Delete this product?"),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text("Cancel")),
                                  TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text("Delete")),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await ProductService().deleteProductIngredient(
                                  product.productId); // ✅ ID المنتج

                              refresh();
                            }
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
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
