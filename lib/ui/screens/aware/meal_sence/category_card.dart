import 'package:flutter/material.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/ui/screens/aware/meal_sence/meals.dart';
import 'package:hope/ui/screens/aware/meal_sence/recipe_details.dart';
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
  Map<String, double> _calculateNutritionForMealType(String mealType) {
    double totalCalories = 0;
    double totalFat = 0;
    double totalProtein = 0;
    double totalCarbs = 0;

    for (final meal in widget.meals) {
      if (widget.category == mealType) {
        totalCalories += meal.calories;
        totalFat += meal.fat;
        totalProtein += meal.protein;
        totalCarbs += meal.carbs;
      }
    }

    double totalMacros = totalFat + totalProtein + totalCarbs;

    return {
      'calories': totalCalories,
      'fat': totalFat,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'macros': totalMacros,
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDark();
    final nutrition = _calculateNutritionForMealType(widget.title);
    final filteredMeals =
        widget.meals.where((meal) => widget.category == widget.title).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode ? AppColors.lavender.withOpacity(0.8) : AppColors.white,
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
          // Title and Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.purple,
                ),
              ),
              Text(
                "${nutrition['calories']?.toStringAsFixed(0) ?? '0'} kcal",
                style: TextStyle(color: widget.kcalColor),
              ),
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
                    color: AppColors.purple,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          filteredMeals.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredMeals.length,
                  itemBuilder: (context, index) {
                    final meal = filteredMeals[index];
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
                                meal.imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(meal.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text("${meal.calories}",
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.meals.remove(meal);
                                  widget.onMealsChanged?.call(widget.meals);
                                });
                              },
                              child: Icon(Icons.close, color: AppColors.gray),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text(
                    "No meals yet.",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
        ],
      ),
    );
  }
}
