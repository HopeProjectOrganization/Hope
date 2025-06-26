import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/healthy_diet/healthy_recipe_service.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/healthy_recipes.dart';
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

  List<RecipeModel> allMeals = [];
  bool isLoadingAll = true;
  String searchText = '';
  int selectedTabIndex = 0;

  final List<Map<String, String>> allCategories = [
    {
      "name": "Beef",
      "image": "https://www.themealdb.com/images/category/beef.png"
    },
    {
      "name": "Chicken",
      "image": "https://www.themealdb.com/images/category/chicken.png"
    },
    {
      "name": "Dessert",
      "image": "https://www.themealdb.com/images/category/dessert.png"
    },
    {
      "name": "Lamb",
      "image": "https://www.themealdb.com/images/category/lamb.png"
    },
    {
      "name": "Miscellaneous",
      "image": "https://www.themealdb.com/images/category/miscellaneous.png"
    },
    {
      "name": "Pasta",
      "image": "https://www.themealdb.com/images/category/pasta.png"
    },
    {
      "name": "Pork",
      "image": "https://www.themealdb.com/images/category/pork.png"
    },
    {
      "name": "Seafood",
      "image": "https://www.themealdb.com/images/category/seafood.png"
    },
    {
      "name": "Side",
      "image": "https://www.themealdb.com/images/category/side.png"
    },
    {
      "name": "Starter",
      "image": "https://www.themealdb.com/images/category/starter.png"
    },
    {
      "name": "Vegan",
      "image": "https://www.themealdb.com/images/category/vegan.png"
    },
    {
      "name": "Vegetarian",
      "image": "https://www.themealdb.com/images/category/vegetarian.png"
    },
    {
      "name": "Breakfast",
      "image": "https://www.themealdb.com/images/category/breakfast.png"
    },
    {
      "name": "Goat",
      "image": "https://www.themealdb.com/images/category/goat.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchAllMeals();
  }

  Future<void> fetchAllMeals() async {
    try {
      final data = await RecipeService.getAllRecipes();
      setState(() {
        allMeals = data;
        isLoadingAll = false;
      });
    } catch (e) {
      setState(() => isLoadingAll = false);
      print("Error fetching recipes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    final filteredMeals = allMeals.where((recipe) {
      final title = recipe.name?.toLowerCase() ?? '';
      return title.contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.recipes),
        iconTheme: IconThemeData(color: AppColors.Teal), // ← لون الأيقونة
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTab(appLocalizations.all, 0,
                    MediaQuery.of(context).size.width * .94),
                SizedBox(
                  width: 16,
                ),
                buildTab(
                    "Categories", 1, MediaQuery.of(context).size.width * .94),
              ],
            ),
          ),
          const SizedBox(height: 8),
          selectedTabIndex == 0
              ? buildAllMeals(filteredMeals)
              : buildCategoriesView(),
        ],
      ),
    );
  }

  Widget buildAllMeals(List<RecipeModel> meals) {
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
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final item = meals[index];
                return buildMealCard(
                  item.name ?? '',
                  item.area ?? '',
                  item.imageUrl ?? '',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RecipeDetailScreen(mealId: item.recipeId!),
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

  Widget buildCategoriesView() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final category = allCategories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MealsByCategoryScreen(category: category['name']!),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.Teal.withOpacity(0.2),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.Teal.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    category['image']!,
                    height: MediaQuery.of(context).size.height * .13,
                    width: MediaQuery.of(context).size.width * .3,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    category['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTab(String text, int index, double width) {
    final isSelected = selectedTabIndex == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = index),
      child: Container(
        width: width / 2,
        // نصف الشاشة
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lavender : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.lavender : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: !isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.Teal : Colors.grey.shade600,
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
          boxShadow: const [
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
                height: MediaQuery.of(context).size.height * .3,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: MediaQuery.of(context).size.height * .3,
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
