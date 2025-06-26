import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/healthy_diet/healthy_recipe_service.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/healthy_recipes.dart';
import 'package:hope/ui/screens/aware/healthy_diet/recipes/recipe_details.dart';
import 'package:provider/provider.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String category;

  const MealsByCategoryScreen({super.key, required this.category});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  List<RecipeModel> meals = [];
  bool isLoading = true;
  String searchText = '';
  TextEditingController searchController = TextEditingController();

  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  @override
  void initState() {
    super.initState();
    fetchMealsByCategory();
  }

  Future<void> fetchMealsByCategory() async {
    try {
      final allRecipes = await RecipeService.getAllRecipes();
      final filtered = allRecipes
          .where((recipe) =>
              recipe.category.toLowerCase() == widget.category.toLowerCase())
          .toList();

      setState(() {
        meals = filtered;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading meals: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    final filteredMeals = meals.where((meal) {
      final name = meal.name.toLowerCase();
      return name.contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${appLocalizations.category} ${widget.category}',
          style: TextStyle(color: AppColors.white, fontSize: 26),
        ),
        backgroundColor: AppColors.Teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => setState(() => searchText = value),
                    decoration: InputDecoration(
                      hintText: appLocalizations.search,
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredMeals.isEmpty
                      ? const Center(child: Text('No results found.'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .7,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: filteredMeals.length,
                          itemBuilder: (context, index) {
                            final meal = filteredMeals[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RecipeDetailScreen(
                                        mealId: meal.recipeId),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                      child: Image.network(
                                        meal.imageUrl,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          height: 150,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.broken_image,
                                              size: 40),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            meal.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Click for details',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
