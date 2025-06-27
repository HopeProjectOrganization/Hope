// meal_favorites.dart
import 'package:flutter/material.dart';
import 'package:hope/Api/healthy_diet/healthy_recipe_service.dart';
import 'package:hope/Api/healthy_diet/vegan_service.dart';
import 'package:hope/Api/recipes/recipe_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/favorite.dart';
import 'package:hope/ui/screens/aware/healthy_diet/recipes/recipe_details.dart';
import 'package:hope/ui/screens/aware/healthy_diet/vegan/vegan_details.dart';
import 'package:hope/ui/screens/aware/meal_sence/recipe_details.dart';

class MealFavorites extends StatelessWidget {
  final List<FavoriteMeal> favorites;
  final VoidCallback onRefresh;

  const MealFavorites({
    required this.favorites,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<FavoriteMeal>> categorizedMeals = {
      'MEALSENSE': [],
      'HEALTHY_DIET': [],
      'VEGAN': [],
    };

    for (var fav in favorites) {
      final categoryKey = fav.category.trim().toUpperCase();

      if (fav.type == 'meal' && categorizedMeals.containsKey(categoryKey)) {
        categorizedMeals[categoryKey]!.add(fav);

        print("fav.category: '${fav.category}' (${fav.category.runtimeType})");
      }
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: categorizedMeals.entries.expand<Widget>((entry) {
        final category = entry.key;
        final List<FavoriteMeal> meals = entry.value;

        if (meals.isEmpty) return [];

        return [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.Teal,
              ),
            ),
          ),
          ...meals.map<Widget>((fav) {
            Future<dynamic> future;

            switch (fav.category) {
              case 'MEALSENSE':
                future = MealApiService().fetchMealById(fav.mealId);
                break;
              case 'HEALTHY_DIET':
                future = RecipeService.getRecipeById(fav.mealId);
                break;
              case 'VEGAN':
                print('Calling getByVeganId with id: ${fav.mealId}');
                future = VeganRecipeService.getById(int.parse(fav.mealId));
                break;
              default:
                return const SizedBox.shrink();
            }

            return FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('No data available');
                }

                final data = snapshot.data!;

                String image = '';
                String title = '';

                if (category == 'MEALSENSE') {
                  image = data.image;
                  title = data.name;
                } else if (category == 'HEALTHY_DIET') {
                  image = data.imageUrl ?? '';
                  title = data.name ?? '';
                } else if (category == 'VEGAN') {
                  image = data.image ?? '';
                  title = data.title ?? '';
                }

                return GestureDetector(
                  onTap: () async {
                    Widget detailsPage;

                    switch (fav.category) {
                      case 'MEALSENSE':
                        Navigator.pushNamed(context, RecipeDetails.routeName,
                            arguments: fav.mealId);
                        break;
                      case 'HEALTHY_DIET':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailScreen(mealId: fav.mealId)),
                        ).then((_) => onRefresh());
                        break;
                      case 'VEGAN':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecipeDetailsScreen(
                                  id: int.parse(fav.mealId))),
                        ).then((_) => onRefresh());
                        break;
                      default:
                        return; // ما تعملش نافيجيشن لو النوع مش معروف
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text("Category: ${fav.category}",
                                  style: const TextStyle(color: Colors.grey)),
                              Text("Type: ${fav.type}",
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
          const SizedBox(height: 20),
        ];
      }).toList(),
    );
  }
}
