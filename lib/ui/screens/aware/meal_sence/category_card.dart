import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/recipes/recipe_service.dart';
import 'package:hope/Api/user/user_meals.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/ui/screens/aware/meal_sence/meals.dart';
import 'package:hope/ui/screens/aware/meal_sence/recipe_details.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final String category;
  final Color kcalColor;
  final List<Meal> meals;
  final void Function(List<Meal>)? onMealsChanged;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.category,
    required this.kcalColor,
    required this.meals,
    this.onMealsChanged,
  }) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  bool _isLoading = false;
  List<Meal> loadedMeals = [];

  @override
  void initState() {
    super.initState();
    _fetchMealsFromBackend();
  }

  Future<void> _fetchMealsFromBackend() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now();

      final mealsFromBackend =
          await UserMealService.fetchMealsByCategoryAndDate(
        category: widget.category,
        date: today,
      );

      setState(() {
        loadedMeals = mealsFromBackend;
      });
    } catch (e) {
      print('❌ Error fetching meals: $e');
    }

    setState(() => _isLoading = false);
  }

  List<Meal> get _filteredMeals {
    return loadedMeals
        .where((meal) => meal.tags.contains(widget.category))
        .toList();
  }

  Map<String, double> _calculateNutrition() {
    double totalCalories = 0, totalFat = 0, totalProtein = 0, totalCarbs = 0;

    for (final meal in _filteredMeals) {
      totalCalories += meal.nutrients.calories;
      totalFat += meal.nutrients.fat;
      totalProtein += meal.nutrients.protein;
      totalCarbs += meal.nutrients.netCarbs;
    }

    return {
      'calories': totalCalories,
      'fat': totalFat,
      'protein': totalProtein,
      'carbs': totalCarbs,
    };
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    final nutrition = _calculateNutrition();
    final isDark = themeProvider.isDark();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.lavender.withOpacity(0.8) : AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title,
                  style: Theme.of(context).textTheme.labelMedium),
              Text("${nutrition['calories']?.toStringAsFixed(0) ?? '0'} kcal",
                  style: TextStyle(color: widget.kcalColor)),
              InkWell(
                onTap: () async {
                  final result = await Navigator.pushReplacementNamed(
                      context, Meals.routeName,
                      arguments: {'title': widget.title});
                  if (result != null && result is Meal) {
                    final updatedTags = Set<String>.from(result.tags)
                      ..add(widget.category);
                    final updatedMeal =
                        result.copyWith(tags: updatedTags.toList());

                    await MealApiService().saveMeal(updatedMeal);

                    final prefs = await SharedPreferences.getInstance();
                    final userId = prefs.getInt("userId") ?? 1;

                    await UserMealService.submitUserMeals(
                      userId: userId,
                      category: widget.category,
                      mealIds: [updatedMeal.id],
                    );

                    setState(() {
                      loadedMeals.add(updatedMeal);
                      widget.onMealsChanged?.call(loadedMeals);
                    });
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: AppColors.yellow, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.add, color: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredMeals.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredMeals.length,
                      itemBuilder: (context, index) {
                        final meal = _filteredMeals[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RecipeDetails.routeName,
                                  arguments: meal.id);
                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(meal.image,
                                      width: 60, height: 60, fit: BoxFit.cover),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(meal.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("${meal.nutrients.calories} kcal",
                                          style: const TextStyle(
                                              color: AppColors.gray)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await MealApiService().deleteMeal(meal.id);
                                    setState(() {
                                      loadedMeals
                                          .removeWhere((m) => m.id == meal.id);
                                      widget.onMealsChanged?.call(loadedMeals);
                                    });
                                  },
                                  child: const Icon(Icons.close,
                                      color: AppColors.gray),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        appLocalizations.noMealsYet,
                        style: const TextStyle(
                            color: AppColors.gray, fontSize: 16),
                      ),
                    ),
        ],
      ),
    );
  }
}
