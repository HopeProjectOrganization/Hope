import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/Api/recipes/fetch_recipe.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';

class FilterScreen extends StatefulWidget {
  static const routeName = '/filterScreen';

  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<Category> categories = [];
  Set<String> selectedCategories = {};
  bool isLoading = true;
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;
  String? error;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() async {
    try {
      final fetchedCategories = await getCategories();
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
        error = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'فشل تحميل الفئات. حاول مرة أخرى.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    if (error != null) return Center(child: Text(error!));
    final isDarkMode = themeProvider.isDark();

    return CustomScaffold(
      title: appLocalizations.select,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected =
                      selectedCategories.contains(category.category);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedCategories.remove(category.category);
                        } else {
                          selectedCategories.add(category.category);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.purple.withOpacity(0.4)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.purple
                              : Colors.grey.withOpacity(0.4),
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (category.thumbnail.isNotEmpty)
                            Image.network(
                              category.thumbnail,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            )
                          else
                            const Icon(Icons.category,
                                size: 40, color: Colors.grey),
                          Text(
                            category.category,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Icon(Icons.check_circle,
                                  color: AppColors.purple),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            CustomButton(
              title: appLocalizations.done,
              onClick: () {
                Navigator.pop(context, selectedCategories.toList());
              },
              color: AppColors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
