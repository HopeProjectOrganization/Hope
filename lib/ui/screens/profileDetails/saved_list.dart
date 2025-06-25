import 'package:flutter/material.dart';
import 'package:hope/Api/healthy_diet/exercises_service.dart';
import 'package:hope/Api/recipes/recipe_service.dart';
import 'package:hope/Api/saved/favorite_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/exercises.dart';
import 'package:hope/model/favorite.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/ui/screens/aware/healthy_diet/exercises/exerciseDetailScreen.dart';
import 'package:hope/ui/screens/aware/meal_sence/recipe_details.dart';

class SavedListScreen extends StatefulWidget {
  static const String routeName = "savedlist";

  @override
  State<SavedListScreen> createState() => _SavedListScreenState();
}

class _SavedListScreenState extends State<SavedListScreen>
    with TickerProviderStateMixin {
  List<FavoriteMeal> favorites = [];
  bool isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadAll() async {
    setState(() => isLoading = true);
    try {
      favorites = await FavoriteApiService.getAllFavorites();
    } catch (e) {
      _showError("Failed to load favorites");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  List<FavoriteMeal> filterByType(String type) {
    return favorites.where((fav) => fav.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.Teal,
        title:
            const Text("Saved List", style: TextStyle(color: AppColors.white)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Posts'),
            Tab(text: 'Meals'),
            Tab(text: 'Exercises'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildFavoritesList(filterByType('post')),
                _buildFavoritesList(filterByType('meal')),
                _buildFavoritesList(filterByType('exercise')),
              ],
            ),
    );
  }

  Widget _buildFavoritesList(List<FavoriteMeal> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No favorites found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final fav = list[index];

        if (fav.type == 'meal' && fav.category == 'MEALSENSE') {
          return FutureBuilder<Meal>(
            future: MealApiService().fetchMealById(fav.mealId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: \${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('No meal data');
              }

              final meal = snapshot.data!;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetails(id: meal.id),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          meal.image,
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
                            Text(meal.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text("Category: \${fav.category}",
                                style: const TextStyle(color: Colors.grey)),
                            Text("Type: \${fav.type}",
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
        } else if (fav.type == 'exercise') {
          return FutureBuilder<Exercise>(
            future: ExerciseApiService().getExerciseById(int.parse(fav.mealId)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: \${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('No exercise data');
              }

              final exercise = snapshot.data!;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ExerciseDetailScreen(exercise: exercise),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          exercise.gifUrl,
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
                            Text(exercise.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text("Category: \${fav.category}",
                                style: const TextStyle(color: Colors.grey)),
                            Text("Type: \${fav.type}",
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
        }

        return const SizedBox.shrink();
      },
    );
  }
}
