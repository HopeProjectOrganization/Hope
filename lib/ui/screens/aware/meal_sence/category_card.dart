import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/recipes/fetch_recipe.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/main.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/ui/screens/aware/meal_sence/meals.dart';
import 'package:hope/ui/screens/aware/meal_sence/recipe_details.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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

  List<Meal> _mealsFromApi = [];
  bool _isLoading = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchMealsFromApi();
  }

  Future<void> fetchMealsFromApi() async {
    setState(() => _isLoading = true);

    try {
      final formattedDate = selectedDate.toIso8601String().split('T').first;
      final url = Uri.parse(
        'http://${MyApp.IP}/api/user-meals?userId=19&date=$formattedDate&category=${widget.category.toLowerCase()}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);

        if (jsonMap.containsKey('mealIds')) {
          final List<dynamic> mealIds = jsonMap['mealIds'];
          List<Meal> mealsList = [];

          for (var id in mealIds) {
            final meal = await fetchMealById(id);
            if (meal != null) mealsList.add(meal);
          }

          setState(() {
            _mealsFromApi = mealsList;
            _isLoading = false;
          });
        } else {
          setState(() {
            _mealsFromApi = [];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _mealsFromApi = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _mealsFromApi = [];
        _isLoading = false;
      });
    }
  }

  Map<String, double> _calculateNutrition() {
    double totalCalories = 0;
    double totalFat = 0;
    double totalProtein = 0;
    double totalCarbs = 0;

    for (final meal in widget.meals) {
      if (meal.tags.contains(widget.category.toLowerCase())) {
        totalCalories += meal.nutrients.calories;
        totalFat += meal.nutrients.fat;
        totalProtein += meal.nutrients.protein;
        totalCarbs += meal.nutrients.netCarbs;
      }
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
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title,
                  style: Theme.of(context).textTheme.labelMedium),
              Text("${nutrition['calories']?.toStringAsFixed(0) ?? '0'} kcal",
                  style: TextStyle(color: widget.kcalColor)),
              InkWell(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    Meals.routeName,
                    arguments: {'title': widget.title},
                  );
                  if (result != null && result is Meal) {
                    setState(() {
                      widget.meals.add(result);
                      widget.onMealsChanged?.call(widget.meals);
                    });
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.add, color: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Meal List or Loader or Empty
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _mealsFromApi.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _mealsFromApi.length,
                      itemBuilder: (context, index) {
                        final meal = _mealsFromApi[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RecipeDetails.routeName,
                                arguments: meal.id,
                              );
                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    meal.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
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
                                  onTap: () {
                                    setState(() {
                                      _mealsFromApi.remove(meal);
                                      widget.meals
                                          .removeWhere((m) => m.id == meal.id);
                                      widget.onMealsChanged?.call(widget.meals);
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
