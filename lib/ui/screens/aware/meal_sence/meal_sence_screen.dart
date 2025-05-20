import 'package:flutter/material.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/ui/screens/aware/meal_sence/category_card.dart';
import 'package:hope/ui/screens/aware/meal_sence/date_helper.dart';
import 'package:hope/ui/screens/aware/meal_sence/progress_card.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';

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
  DateTime selectedDate = DateTime.now();
  List<Meal> meals = [];
  late String _title = widget.title;
  final double targetCalories = 2000;
  final double targetFat = 70; // بالجرام مثلاً
  final double targetProtein = 50; // بالجرام
  final double targetCarbs = 300; // بالجرام

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    meals = List.from(widget.selectedMeals); // نسخة قابلة للتعديل
    _scrollController = ScrollController();
    selectedDate = DateTime.now(); // تأكيد أن اليوم هو المختار

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay(); // تمرير إلى المنتصف
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Map<String, double> _calculateNutritionForMealType(String mealType) {
    double totalCalories = 0;
    double totalFat = 0;
    double totalProtein = 0;
    double totalCarbs = 0;

    for (final meal in meals) {
      if (_title == mealType) {
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

  void _scrollToSelectedDay() {
    int daysCount =
        DateHelper.getDaysInMonth(selectedDate.year, selectedDate.month);
    int selectedIndex = selectedDate.day - 1;
    double itemWidth = 60 + 8; // item + padding
    double screenWidth = MediaQuery.of(context).size.width;

    double offset = DateHelper.calculateScrollOffset(
      selectedIndex: selectedIndex,
      totalDays: daysCount,
      itemWidth: itemWidth,
      screenWidth: screenWidth,
    );

    _scrollController.jumpTo(offset);
  }

  List<DateTime> getWeekDates() {
    DateTime today = DateTime.now();
    int currentWeekday = today.weekday; // Monday = 1
    DateTime monday = today.subtract(Duration(days: currentWeekday - 1));
    return List.generate(5, (index) => monday.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDark();
    return CustomScaffold(
      backgroundColor: isDarkMode ? AppColors.dark : Color(0xFFF9FAFC),
      title: "Meal Sence",
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  child: MyCalendarWidget()),
              ProgressCard(
                meals: meals,
              ),
              CategoryCard(
                  title: 'Breakfast',
                  category: _title,
                  kcalColor: Colors.green,
                  meals: meals,
                  onMealsChanged: (updatedMeals) {
                    setState(() {
                      meals = updatedMeals;
                    });
                  }),
              CategoryCard(
                  title: 'Lunch',
                  category: _title,
                  kcalColor: Colors.orange,
                  meals: meals,
                  onMealsChanged: (updatedMeals) {
                    setState(() {
                      meals = updatedMeals;
                    });
                  }),
              CategoryCard(
                  title: 'Dinner',
                  category: _title,
                  kcalColor: Colors.blue,
                  meals: meals,
                  onMealsChanged: (updatedMeals) {
                    setState(() {
                      meals = updatedMeals;
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }

}
