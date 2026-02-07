import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:provider/provider.dart';

class ProgressCard extends StatefulWidget {
  final List<Meal> meals;

  const ProgressCard({
    super.key,
    required this.meals,
  });

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  List<Meal> meals = [];
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;
  bool _isLoading = false;

  late double currentCalories;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.meals.isEmpty; // فقط لو فاضية نعرض اللودينج
  }

  @override
  void didUpdateWidget(covariant ProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.meals.isNotEmpty && _isLoading) {
      setState(() {
        meals = widget.meals;
        _isLoading = false;
      });
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          meals = widget.meals;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    double targetFat = 70;
    double targetProtein = 100;
    double targetCarbs = 250;
    final nutrition = _calculateNutritionForAllMeals();
    final totalCalories = nutrition['calories']!;
    final totalFat = nutrition['fat']!;
    final totalProtein = nutrition['protein']!;
    final totalCarbs = nutrition['carbs']!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.isDark() ? AppColors.white : AppColors.white,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appLocalizations.todayProgress,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset(
                    AppIcons.calories,
                    width: 24,
                    height: 24,
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    totalCalories.toStringAsFixed(0),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black),
                  ),
                  Text(
                    appLocalizations.calories,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildProgressCircle(appLocalizations.fat, totalFat,
                        targetFat, Colors.orange),
                    _buildProgressCircle(appLocalizations.protein, totalProtein,
                        targetProtein, Colors.blue),
                    _buildProgressCircle(appLocalizations.carbs, totalCarbs,
                        targetCarbs, Colors.purple),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Map<String, double> _calculateNutritionForAllMeals() {
    double totalCalories = 0;
    double totalFat = 0;
    double totalProtein = 0;
    double totalCarbs = 0;

    for (final meal in widget.meals) {
      totalCalories += meal.nutrients.calories;
      totalFat += meal.nutrients.fat;
      totalProtein += meal.nutrients.protein;
      totalCarbs += meal.nutrients.netCarbs;
    }

    return {
      'calories': totalCalories,
      'fat': totalFat,
      'protein': totalProtein,
      'carbs': totalCarbs,
    };
  }

  Widget _buildProgressCircle(
      String label, double value, double target, Color baseColor) {
    final progress = (target == 0) ? 0.0 : (value / target).clamp(0.0, 1.0);
    final color = _getProgressColor(value, target, baseColor);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(4),
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeWidth: 6,
              ),
            ),
            Text(
              "${(progress * 100).toStringAsFixed(0)}%",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
        Text("${value.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Color _getProgressColor(double value, double target, Color baseColor) {
    if (value > target) {
      return Colors.red;
    }
    return baseColor;
  }
}
