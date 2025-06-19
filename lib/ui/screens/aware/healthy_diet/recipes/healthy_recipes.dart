import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/healthy_diet/healthy_recipe.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/aware/healthy_diet/recipes/recipe_by_category.dart';
import 'package:hope/ui/screens/aware/healthy_diet/recipes/recipe_details.dart';
import 'package:provider/provider.dart';

class Recipes extends StatefulWidget {
  static const routeName = '/RECIPES';

  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  List<dynamic> allMeals = [];
  List<dynamic> categories = [];
  bool isLoadingAll = true;
  bool isLoadingCategories = true;
  String searchText = '';
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.wait([
      fetchAllMeals(),
      fetchCategories(),
    ]);
  }

  Future<void> fetchAllMeals() async {
    final data = await MealService.getAllMeals(context);
    setState(() {
      allMeals = data;
      isLoadingAll = false;
    });
  }

  Future<void> fetchCategories() async {
    final data = await MealService.getCategories(context);
    setState(() {
      categories = data;
      isLoadingCategories = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    final filteredMeals = allMeals.where((item) {
      final title = item['strMeal']?.toString().toLowerCase() ?? '';
      return title.contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.recipes)),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                buildTab(appLocalizations.all, 0),
                const SizedBox(width: 8),
                buildTab(appLocalizations.byCategory, 1),
              ],
            ),
          ),
          if (selectedTabIndex == 0)
            isLoadingAll
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : buildAllMeals(filteredMeals),
          if (selectedTabIndex == 1)
            isLoadingCategories
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : buildCategoryMeals(),
        ],
      ),
    );
  }

  Widget buildAllMeals(List<dynamic> filteredMeals) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() => searchText = value),
              decoration: InputDecoration(
                hintText: appLocalizations.search,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredMeals.length,
              itemBuilder: (context, index) {
                final item = filteredMeals[index];
                return buildMealCard(
                  item['strMeal'],
                  item['strArea'] ?? '',
                  item['strMealThumb'],
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RecipeDetailScreen(mealId: item['idMeal']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryMeals() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MealsByCategoryScreen(category: category['strCategory']),
                ),
              );
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    category['strCategoryThumb'],
                    height: 110,
                    width: 110,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 40),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['strCategory'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTab(String text, int index) {
    final isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lavender : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.purple : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget buildMealCard(
      String title, String area, String imageUrl, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                imageUrl,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  if (area.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('Area: $area',
                          style: const TextStyle(color: Colors.grey)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
