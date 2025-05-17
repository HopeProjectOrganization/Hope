import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/ui/screens/aware/meal_sence/meals.dart';

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

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    meals = widget.selectedMeals;
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDay() {
    int daysCount = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    int selectedIndex = selectedDate.day - 1;
    double itemWidth = 60 + 8; // عرض العنصر مع البادينج (تعديل حسب تصميمك)
    double screenWidth = MediaQuery.of(context).size.width;
    double targetScrollOffset =
        (itemWidth * selectedIndex) - (screenWidth / 2) + (itemWidth / 2);

    if (targetScrollOffset < 0) targetScrollOffset = 0;

    double maxScrollExtent = itemWidth * daysCount - screenWidth;
    if (targetScrollOffset > maxScrollExtent)
      targetScrollOffset = maxScrollExtent;

    _scrollController.animateTo(
      targetScrollOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<DateTime> getWeekDates() {
    DateTime today = DateTime.now();
    int currentWeekday = today.weekday; // Monday = 1
    DateTime monday = today.subtract(Duration(days: currentWeekday - 1));
    return List.generate(5, (index) => monday.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text('Meal Sence', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              // Days Row
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
                child: _buildDaysOfMonth(
                    selectedDate.year, selectedDate.month, selectedDate.day),
              ),

              _buildMealCard(title: 'Breakfast', kcalColor: Colors.green),
              _buildMealCard(title: 'Lunch', kcalColor: Colors.orange),
              _buildMealCard(title: 'Dinner', kcalColor: Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard({
    required String title,
    required Color kcalColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.purple,
                ),
              ),
              InkWell(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    Meals.routeName,
                    arguments: {'title': title},
                  );
                  if (result != null && result is Meal) {
                    setState(() {
                      meals.add(result);
                    });
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.purple,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          (!meals.isEmpty && title == _title)
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                    style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          // Remove (X) icon
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.selectedMeals.removeAt(index);
                              });
                            },
                            child: Icon(Icons.close, color: AppColors.gray),
                          ),
                        ],
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

  Widget _buildDay(String day, String date, bool isSelected,
      {bool isToday = false}) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.lavender : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border:
            isToday ? Border.all(color: AppColors.lavender, width: 2) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: isSelected ? AppColors.purple : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              color: isSelected ? AppColors.purple : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfMonth(int year, int month, int selectedDay) {
    int daysCount = DateTime(year, month + 1, 0).day;
    DateTime today = DateTime.now();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daysCount,
        itemBuilder: (context, index) {
          int day = index + 1;
          DateTime date = DateTime(year, month, day);
          String dayName = _getWeekdayName(date.weekday);
          String dayDate = day.toString().padLeft(2, '0');

          bool isSelected = day == selectedDay;
          bool isToday = date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = date;
                });
              },
              child: _buildDay(dayName, dayDate, isSelected, isToday: isToday),
            ),
          );
        },
      ),
    );
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "Mon";
      case DateTime.tuesday:
        return "Tue";
      case DateTime.wednesday:
        return "Wed";
      case DateTime.thursday:
        return "Thu";
      case DateTime.friday:
        return "Fri";
      case DateTime.saturday:
        return "Sat";
      case DateTime.sunday:
        return "Sun";
      default:
        return "";
    }
  }
}
