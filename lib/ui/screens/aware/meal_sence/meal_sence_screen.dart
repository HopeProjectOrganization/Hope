import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/user/user_meals.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/ui/screens/aware/meal_sence/category_card.dart';
import 'package:hope/ui/screens/aware/meal_sence/date_helper.dart';
import 'package:hope/ui/screens/aware/meal_sence/progress_card.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealSenceScreen extends StatefulWidget {
  static const routeName = '/mealSence';
  final List<Meal> selectedMeals;
  final String title;

  const MealSenceScreen(
      {Key? key, required this.selectedMeals, required this.title})
      : super(key: key);

  @override
  State<MealSenceScreen> createState() => _MealSenceScreenState();
}

class _MealSenceScreenState extends State<MealSenceScreen> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  DateTime selectedDate = DateTime.now();
  List<Meal> allMealsForToday = [];

  @override
  void initState() {
    super.initState();
    fetchAllMealsForToday();
  }

  Future<void> fetchAllMealsForToday() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId");
      if (userId == null) return;

      final today = DateTime.now();
      final dateString = today.toIso8601String().split('T')[0];

      final breakfast = await UserMealService.fetchUserMeals(
          userId: userId, category: 'Breakfast', date: dateString);
      final lunch = await UserMealService.fetchUserMeals(
          userId: userId, category: 'Lunch', date: dateString);
      final dinner = await UserMealService.fetchUserMeals(
          userId: userId, category: 'Dinner', date: dateString);

      setState(() {
        allMealsForToday = [...breakfast, ...lunch, ...dinner];
      });
    } catch (e) {
      print("❌ Error loading today's meals: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context)!;
    themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDark();

    return CustomScaffold(
      backgroundColor: isDarkMode ? AppColors.dark : const Color(0xFFF9FAFC),
      title: appLocalizations.mealSense,
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: MyCalendarWidget(),
              ),

              // ⬇️ هنا بنرسل كل الوجبات اللي اتحمّلت من كل الفئات
              ProgressCard(meals: allMealsForToday),

              CategoryCard(
                title: appLocalizations.breakfast,
                category: 'Breakfast',
                kcalColor: Colors.green,
                meals: allMealsForToday,
                onMealsChanged: (updatedMeals) {
                  setState(() {
                    allMealsForToday = updatedMeals;
                  });
                },
              ),
              CategoryCard(
                title: appLocalizations.lunch,
                category: 'Lunch',
                kcalColor: Colors.orange,
                meals: allMealsForToday,
                onMealsChanged: (updatedMeals) {
                  setState(() {
                    allMealsForToday = updatedMeals;
                  });
                },
              ),
              CategoryCard(
                title: appLocalizations.dinner,
                category: 'Dinner',
                kcalColor: Colors.blue,
                meals: allMealsForToday,
                onMealsChanged: (updatedMeals) {
                  setState(() {
                    allMealsForToday = updatedMeals;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
