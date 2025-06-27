import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Admin/aware/mealsense/add_meal.dart';
import 'package:hope/Admin/aware/mealsense/admin_meal_details.dart';
import 'package:hope/Api/recipes/recipe_service.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/meal_dm.dart'; // يحتوي Recipe
import 'package:provider/provider.dart';

class AdminMeals extends StatefulWidget {
  static const routeName = '/AdminMeals';

  const AdminMeals({Key? key}) : super(key: key);

  @override
  State<AdminMeals> createState() => _AdminMealsState();
}

class _AdminMealsState extends State<AdminMeals> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  bool _isLoading = false;
  Map<String, bool> selectedMeals = {};
  int selectedMealsCount = 0;
  List<Meal> selectedMealList = [];

  TextEditingController searchController = TextEditingController();
  List<Meal> allMeals = [];
  List<String> selectedCategories = [];
  List<Meal> displayedMeals = [];

  Timer? _debounce;

  final MealApiService api = MealApiService();

  @override
  void initState() {
    super.initState();
    _fetchMeals();
  }

  void _fetchMeals() async {
    setState(() => _isLoading = true);
    try {
      final meals = await api.fetchMeals();

      meals.sort((a, b) => a.name.compareTo(b.name));

      setState(() {
        allMeals = meals;
        displayedMeals = meals;
        _isLoading = false;
      });
    } catch (error) {
      print("❌ Error loading meals: $error");
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _deleteRecipe(String mealId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text("Are you sure you want to delete this recipe?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await MealApiService().deleteMeal(mealId);
        return true; // ✅ تم الحذف بنجاح
      } catch (e) {
        print("❌ Error deleting meal: $e");
        return false;
      }
    }
    return false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is List<String>) {
      selectedCategories = args;
      applyFilters();
    }
  }

  void applyFilters() {
    final query = searchController.text.trim().toLowerCase();
    List<Meal> temp = List.from(allMeals);

    if (selectedCategories.isNotEmpty) {
      temp = temp
          .where((r) => selectedCategories.any((tag) => r.tags.contains(tag)))
          .toList();
    }
    if (query.isNotEmpty) {
      temp = temp.where((r) => r.name.toLowerCase().contains(query)).toList();
    }

    setState(() {
      displayedMeals = temp;
    });
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), applyFilters);
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.mealSense),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.Teal),
          // ✅ لون الأيقونة
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.Teal,
        onPressed: () async {
          await Navigator.pushNamed(context, AddMeal.routeName);
          _fetchMeals(); // ريفريش بعد الإضافة
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: Color(0xFFF8F8FF),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextField(
                            controller: searchController,
                            onChanged: onSearchChanged,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search_outlined),
                              hintText: appLocalizations.search,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: displayedMeals.isEmpty
                        ? Center(child: Text(appLocalizations.noMealsFound))
                        : ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: displayedMeals.length,
                            itemBuilder: (context, index) {
                              final meal = displayedMeals[index];
                              final sel = selectedMeals[meal.id] ?? false;

                              return InkWell(
                                onTap: () async {
                                  final updatedMeal = await Navigator.pushNamed(
                                    context,
                                    AdminMealDetails.routeName,
                                    arguments: meal,
                                  ) as Meal?;

                                  if (updatedMeal != null) {
                                    setState(() {
                                      // تحديث العنصر داخل allMeals
                                      final index = allMeals.indexWhere(
                                          (m) => m.id == updatedMeal.id);
                                      if (index != -1) {
                                        allMeals[index] = updatedMeal;
                                      }

                                      // تحديث القائمة المعروضة
                                      applyFilters();
                                    });
                                  }
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
                                            offset: Offset(0, 4))
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              Expanded(
                                                  child: Text(
                                                      meal.name.length > 20
                                                          ? meal.name.substring(
                                                                  0, 20) +
                                                              '...'
                                                          : meal.name,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red,
                                                    size: 25),
                                                onPressed: () async {
                                                  await _deleteRecipe(meal.id);
                                                  setState(() {
                                                    allMeals.removeWhere(
                                                        (m) => m.id == meal.id);
                                                    displayedMeals.removeWhere(
                                                        (m) => m.id == meal.id);
                                                    selectedMeals
                                                        .remove(meal.id);
                                                    selectedMealList
                                                        .removeWhere((m) =>
                                                            m.id == meal.id);
                                                    selectedMealsCount =
                                                        selectedMealList.length;
                                                  });
                                                },
                                              )
                                            ]),
                                            SizedBox(height: 12),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: meal.image.isNotEmpty
                                                  ? Image.network(
                                                      meal.image,
                                                      height: 180,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (c, e, s) =>
                                                          Container(
                                                        height: 180,
                                                        color: Colors.grey[300],
                                                        child: Icon(
                                                            Icons.broken_image,
                                                            size: 40),
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 180,
                                                      color: Colors.grey[200],
                                                      child: Center(
                                                          child: Icon(
                                                              Icons.fastfood,
                                                              size: 40,
                                                              color:
                                                                  Colors.grey)),
                                                    ),
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  _buildNutritionIcon(
                                                      appLocalizations.calories,
                                                      meal.nutrients.calories
                                                              .toStringAsFixed(
                                                                  1) +
                                                          "kcal",
                                                      AppIcons.calories),
                                                  _buildNutritionIcon(
                                                      appLocalizations.protein,
                                                      meal.nutrients.protein
                                                              .toStringAsFixed(
                                                                  1) +
                                                          "g",
                                                      AppIcons.proteins),
                                                  _buildNutritionIcon(
                                                      appLocalizations.fat,
                                                      meal.nutrients.fat
                                                              .toStringAsFixed(
                                                                  1) +
                                                          "g",
                                                      AppIcons.fats),
                                                  _buildNutritionIcon(
                                                      appLocalizations.carbs,
                                                      meal.nutrients.netCarbs
                                                              .toStringAsFixed(
                                                                  1) +
                                                          "g",
                                                      AppIcons.carbs),
                                                ])
                                          ]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildNutritionIcon(String title, String value, String iconPath) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
                color: AppColors.dark,
                iconPath,
                fit: BoxFit.fitHeight,
                width: 30,
                height: 30),
          ),
        ),
        SizedBox(height: 6),
        Text(title),
        Text(value, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
