import 'package:flutter/material.dart';
import 'package:hope/Admin/add/add_high.dart';
import 'package:hope/Api/add/high_ingredients.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/high_risk_ingredents.dart';

class AdminHighRiskScreen extends StatefulWidget {
  const AdminHighRiskScreen({super.key});

  static const routeName = '/addHighIngredient';

  @override
  State<AdminHighRiskScreen> createState() => _AdminHighRiskScreenState();
}

class _AdminHighRiskScreenState extends State<AdminHighRiskScreen> {
  List<HighRiskIngredient> ingredients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadIngredients();
  }

  Future<void> loadIngredients() async {
    try {
      final fetched = await HighRiskIngredientService.getAll();
      setState(() {
        ingredients = fetched;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Failed to fetch: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteIngredient(int id) async {
    await HighRiskIngredientService.delete(id);
    await loadIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Risk Ingredients'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHighIngredientScreen()),
          ).then((value) {
            if (value == true) loadIngredients();
          });
        },
        child: const Icon(Icons.add, color: AppColors.yellow),
        backgroundColor: AppColors.Teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Table(
                      border: TableBorder.all(color: AppColors.Teal),
                      defaultColumnWidth: const IntrinsicColumnWidth(),
                      children: [
                        TableRow(
                          decoration:
                              const BoxDecoration(color: AppColors.yellow),
                          children: [
                            tableHeader("Name"),
                            tableHeader("Risk Level"),
                            tableHeader("Safe Limit"),
                            tableHeader("English Description"),
                            tableHeader("Arabic Description"),
                            tableHeader("Actions"),
                          ],
                        ),
                        ...ingredients.map((item) => TableRow(children: [
                              tableCell(item.ingredientName),
                              tableCell(item.riskLevel),
                              tableCell(item.safeLimit),
                              tableCell(item.englishDescription, maxLines: 3),
                              tableCell(item.arabicDescription, maxLines: 3),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: AppColors.Teal),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                AddHighIngredientScreen(
                                                    ingredient: item),
                                          ),
                                        ).then((value) {
                                          if (value == true) loadIngredients();
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          deleteIngredient(item.id!),
                                    ),
                                  ],
                                ),
                              )
                            ])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  static Widget tableHeader(String title) => Padding(
        padding: const EdgeInsets.all(12),
        child: Text(title,
            style: const TextStyle(
                color: AppColors.Teal, fontWeight: FontWeight.bold)),
      );

  static Widget tableCell(String text, {int maxLines = 2}) => Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: 150,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            textDirection:
                _isArabic(text) ? TextDirection.rtl : TextDirection.ltr,
            textAlign: _isArabic(text) ? TextAlign.right : TextAlign.left,
          ),
        ),
      );

  static bool _isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
