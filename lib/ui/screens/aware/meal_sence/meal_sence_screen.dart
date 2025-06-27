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
  final DateTime Date;

  const MealSenceScreen(
      {Key? key,
      required this.selectedMeals,
      required this.title,
      required this.Date})
      : super(key: key);

  @override
  State<MealSenceScreen> createState() => _MealSenceScreenState();
}

class _MealSenceScreenState extends State<MealSenceScreen> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  late DateTime selectedDate;
  List<Meal> allMealsForToday = [];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.Date;

    fetchAllMealsForDate(selectedDate);
  }

  Future<void> fetchAllMealsForDate(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId");
      if (userId == null) return;

      final dateString = date.toIso8601String().split('T')[0];

      // 🔽 استرجاع كل UserMeal حسب الفئة
      final breakfastUserMeals = await UserMealService.fetchUserMealsAsUserMeal(
        userId: userId,
        category: 'Breakfast',
        date: dateString,
      );
      final lunchUserMeals = await UserMealService.fetchUserMealsAsUserMeal(
        userId: userId,
        category: 'Lunch',
        date: dateString,
      );
      final dinnerUserMeals = await UserMealService.fetchUserMealsAsUserMeal(
        userId: userId,
        category: 'Dinner',
        date: dateString,
      );

      // 🔽 استرجاع التفاصيل الفعلية للوجبات وربطها بالتاريخ
      final breakfastMeals =
          await UserMealService.fetchMealsFromUserMeals(breakfastUserMeals);
      final lunchMeals =
          await UserMealService.fetchMealsFromUserMeals(lunchUserMeals);
      final dinnerMeals =
          await UserMealService.fetchMealsFromUserMeals(dinnerUserMeals);

      if (mounted) {
        setState(() {
          selectedDate = date;
          allMealsForToday = [...breakfastMeals, ...lunchMeals, ...dinnerMeals];
        });
      }
    } catch (e) {
      print("❌ Error fetching meals: $e");
    }
  }

  List<Meal> _filterMealsByCategory(String category) {
    return allMealsForToday.where((meal) {
      if (meal.date == null) return false; // ✅ تأكد إن التاريخ موجود

      return meal.tags.contains(category) &&
          meal.date!.year == selectedDate.year &&
          meal.date!.month == selectedDate.month &&
          meal.date!.day == selectedDate.day;
    }).toList();
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
                child: MyCalendarWidget(
                  selectedDate: selectedDate,
                  onDateChanged: (newDate) {
                    fetchAllMealsForDate(newDate);
                  },
                ),
              ),
              // ⬇️ هنا بنرسل كل الوجبات اللي اتحمّلت من كل الفئات
              ProgressCard(meals: allMealsForToday),

              CategoryCard(
                title: appLocalizations.breakfast,
                category: 'Breakfast',
                kcalColor: Colors.green,
                meals: _filterMealsByCategory("Breakfast"),
                selectedDate: selectedDate,
                // ✅ هن
                onMealsChanged: (_) {
                  fetchAllMealsForDate(
                      selectedDate); // ✅ عيد تحميل الكل بعد الإضافة
                },
              ),
              CategoryCard(
                title: appLocalizations.lunch,
                category: 'Lunch',
                kcalColor: Colors.orange,
                meals: _filterMealsByCategory("Lunch"),
                selectedDate: selectedDate,
                // ✅ هنا
                onMealsChanged: (_) {
                  fetchAllMealsForDate(
                      selectedDate); // ✅ عيد تحميل الكل بعد الإضافة
                },
              ),
              CategoryCard(
                title: appLocalizations.dinner,
                category: 'Dinner',
                kcalColor: Colors.blue,
                meals: _filterMealsByCategory("Dinner"),
                selectedDate: selectedDate,
                // ✅ هنا
                onMealsChanged: (_) {
                  fetchAllMealsForDate(
                      selectedDate); // ✅ عيد تحميل الكل بعد الإضافة
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
