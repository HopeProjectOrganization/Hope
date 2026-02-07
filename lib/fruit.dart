import 'package:flutter/material.dart';
import 'package:hope/Api/recipes/recipe_service.dart';
import 'package:hope/Api/saved/favorite_service.dart';
import 'package:hope/model/favorite.dart';
import 'package:hope/model/meal_dm.dart';

Future<Map<String, List<Meal>>> loadFavoriteMealsGroupedByCategory() async {
  try {
    // Step 1: Get all favorite meals
    final List<FavoriteMeal> favorites =
        await FavoriteApiService.getAllFavorites();

    // Step 2: Prepare meal service and output map
    final MealApiService mealService = MealApiService();
    final Map<String, List<Meal>> categoryMap = {};

    // Step 3: Loop over favorites
    for (final favorite in favorites) {
      try {
        final meal = await mealService.fetchMealById(favorite.mealId);

        // Group meals by category
        if (!categoryMap.containsKey(favorite.category)) {
          categoryMap[favorite.category] = [];
        }
        categoryMap[favorite.category]!.add(meal);
      } catch (e) {
        print('❌ Failed to fetch meal ${favorite.mealId}: $e');
      }
    }

    return categoryMap;
  } catch (e) {
    print('❌ Failed to load favorite meals: $e');
    return {};
  }
}

class ExploreScreen extends StatefulWidget {
  static const routeName = '/explore';

  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<Meal>>? favoriteMealsByCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadFavorites(); // تحميل البيانات
  }

  Future<void> loadFavorites() async {
    final data = await loadFavoriteMealsGroupedByCategory();
    setState(() {
      favoriteMealsByCategory = data;
    });
  }

  Widget buildMealTab() {
    if (favoriteMealsByCategory == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (favoriteMealsByCategory!.isEmpty) {
      return const Center(child: Text('No favorite meals found.'));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: favoriteMealsByCategory!.entries.map((entry) {
        final category = entry.key;
        final meals = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(category,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: const Text("See All")),
                ],
              ),
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            meal.image ?? '',
                            height: 100,
                            width: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[300],
                              height: 100,
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          meal.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget buildDummyTab(Map<String, List<Map<String, String>>> data) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: data.entries.map((entry) {
        final title = entry.key;
        final items = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text("See all"))
                ],
              ),
            ),
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          item['image']!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 90,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['title']!,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  final posts = {
    'News': [
      {'title': 'News 1', 'image': 'http://via.placeholder.com/150'},
      {'title': 'News 2', 'image': 'http://via.placeholder.com/150'},
    ],
  };

  final exercises = {
    'Cardio': [
      {'title': 'Running', 'image': 'http://via.placeholder.com/150'},
      {'title': 'Jumping', 'image': 'http://via.placeholder.com/150'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Posts'),
            Tab(text: 'Meals'),
            Tab(text: 'Exercises'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildDummyTab(posts),
          buildMealTab(),
          buildDummyTab(exercises),
        ],
      ),
    );
  }
}
