import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/theme/app_colors.dart';

class MealSenceScreen extends StatefulWidget {
  static const routeName = '/test';

  @override
  State<MealSenceScreen> createState() => _MealSenceScreenState();
}

class _MealSenceScreenState extends State<MealSenceScreen> {
  final List<String> weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  DateTime selectedDate = DateTime.now();

  List<DateTime> getWeekDates() {
    DateTime today = DateTime.now();
    int currentWeekday = today.weekday; // Monday = 1
    DateTime monday = today.subtract(Duration(days: currentWeekday - 1));
    return List.generate(5, (index) => monday.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Text('Meal Sence', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Days Row
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: getWeekDates().map((date) {
                String dayAbbr = weekDays[date.weekday - 1];
                bool isSelected = date.day == selectedDate.day &&
                    date.month == selectedDate.month &&
                    date.year == selectedDate.year;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: _buildDay(
                      dayAbbr, date.day.toString().padLeft(2, '0'), isSelected),
                );
              }).toList(),
            ),
          ),

          // Meal Cards (ممكن لاحقاً نربطها باليوم المختار)
          _buildMealCard(
            title: 'Breakfast',
            kcal: '472KCAL',
            kcalColor: Colors.orange,
            foodName: 'Pancakes',
            foodKcal: '472KCAL',
            imagePath: AppAssets.helpful,
          ),
          _buildMealCard(
            title: 'Lunch',
            kcal: '423KCAL',
            kcalColor: Colors.green,
            foodName: 'Green Salad',
            foodKcal: '423KCAL',
            imagePath: AppAssets.helpful,
          ),
          _buildMealCard(
            title: 'Dinner',
            kcal: '450KCAL',
            kcalColor: Colors.yellow,
            foodName: 'Green Salad',
            foodKcal: '423KCAL',
            imagePath: AppAssets.helpful,
          ),
        ],
      ),
    );
  }

  Widget _buildDay(String day, String date, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.lavender : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard({
    required String title,
    required String kcal,
    required Color kcalColor,
    required String foodName,
    required String foodKcal,
    required String imagePath,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
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
          // Title and button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(kcal, style: TextStyle(color: kcalColor)),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Food info
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(imagePath,
                    width: 40, height: 40, fit: BoxFit.cover),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(foodName, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(foodKcal, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
