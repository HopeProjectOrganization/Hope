import 'package:flutter/material.dart';
import 'package:hope/Api/recipes/fetch_recipe.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/ui/screens/aware/meal_sence/my_meals.dart';
import 'package:hope/ui/screens/aware/meal_sence/recipe_details.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';

class Meals extends StatefulWidget {
  static const routeName = '/mmmmeals';
  final String title;

  const Meals({Key? key, required this.title}) : super(key: key);

  @override
  State<Meals> createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  late Future<List<Meal>> mealsFuture;
  Map<int, bool> selectedMeals = {};
  int selectedMealsCount = 0;
  List<Meal> selectedMealList = [];
  late String _title = widget.title;

  TextEditingController searchController = TextEditingController();
  List<Meal> allMeals = [];
  List<Meal> displayedMeals = [];

  @override
  void initState() {
    super.initState();
    mealsFuture = fetchMeal();
    mealsFuture.then((meals) {
      setState(() {
        allMeals = meals;
        displayedMeals = meals;
      });
    });
  }

  void filterMeals(String query) {
    final filtered = allMeals.where((meal) {
      return meal.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      displayedMeals = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: ImageIcon(
                  AssetImage(AppIcons.meal),
                  color: AppColors.purple,
                  size: 45,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, MyMealsScreen.routeName,
                      arguments: {
                        'selectedMeals': selectedMealList,
                        'title': _title
                      });
                },
              ),
              if (selectedMealsCount > 0)
                Positioned(
                  right: 8,
                  top: 26,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Text(
                        '$selectedMealsCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
        title: "Meals",
        backgroundColor: Color(0xFFF8F8FF),
        body: SafeArea(
            child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by meal name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: filterMeals,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: mealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No meals found."));
                } else {
                  final meals = snapshot.data!;

                  return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: displayedMeals.length,
                      itemBuilder: (context, index) {
                        final meal = displayedMeals[index];
                        final isSelected = selectedMeals[meal.id] ?? false;

                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RecipeDetails.routeName,
                                arguments: meal.id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.grey.withOpacity(0.2),
                                    offset: Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          meal.name.length > 20
                                              ? meal.name.substring(0, 20) +
                                                  '...'
                                              : meal.name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          icon: Icon(
                                            isSelected
                                                ? Icons.check
                                                : Icons.add,
                                            color: AppColors.purple,
                                            size: 25,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              selectedMeals[meal.id] =
                                                  !isSelected;
                                              if (selectedMeals[meal.id]!) {
                                                selectedMealList
                                                    .add(meal); // إضافة الوجبة
                                                selectedMealsCount++;
                                              } else {
                                                selectedMealList.removeWhere(
                                                    (m) =>
                                                        m.id ==
                                                        meal.id); // حذف الوجبة
                                                selectedMealsCount--;
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: meal.imageUrl != null &&
                                              meal.imageUrl.isNotEmpty
                                          ? Image.network(meal.imageUrl,
                                              height: 180,
                                              width: double.infinity,
                                              fit: BoxFit.cover)
                                          : Container(
                                              height: 180,
                                              color: Colors.grey[200],
                                              child: Center(
                                                  child: Icon(Icons.fastfood,
                                                      size: 40,
                                                      color: Colors.grey)),
                                            ),
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildNutritionIcon(
                                            "Calories",
                                            meal.calories.toStringAsFixed(1) +
                                                "g"),
                                        _buildNutritionIcon(
                                            "Protein",
                                            meal.protein.toStringAsFixed(1) +
                                                "g"),
                                        _buildNutritionIcon("Fat",
                                            meal.fat.toStringAsFixed(1) + "g"),
                                        _buildNutritionIcon(
                                            "Carbs",
                                            meal.carbs.toStringAsFixed(1) +
                                                "g"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
        ])));
  }

  Widget _buildNutritionIcon(String title, String value) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: Icon(Icons.local_dining, color: Colors.deepPurple),
        ),
        SizedBox(height: 6),
        Text(title),
        Text(value, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
