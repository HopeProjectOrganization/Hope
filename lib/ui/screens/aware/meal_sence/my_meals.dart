import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/user/user_meals.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/ui/screens/aware/meal_sence/meal_sence_screen.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';

class MyMealsScreen extends StatefulWidget {
  static const routeName = '/my';

  final List<Meal> selectedMeals;

  final String title;

  const MyMealsScreen(
      {Key? key, required this.selectedMeals, required this.title})
      : super(key: key);

  @override
  _MyMealsScreenState createState() => _MyMealsScreenState();
}

class _MyMealsScreenState extends State<MyMealsScreen> {
  late List<Meal> _selectedMeals;
  late String _title = widget.title;
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  @override
  void initState() {
    super.initState();
    _selectedMeals = List.from(widget.selectedMeals);
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    return CustomScaffold(
      title: appLocalizations.myMealsFor,
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.Teal),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Icon
                Row(
                  children: [
                    ImageIcon(AssetImage(AppIcons.meal), color: AppColors.Teal),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _title,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${appLocalizations.totalCalories} ${_selectedMeals.isEmpty ? 0 : _selectedMeals.fold(0.0, (total, meal) => total + meal.nutrients.calories).toInt()}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Meals Title
                Text(appLocalizations.meals,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                _selectedMeals.isEmpty
                    ? Center(
                        child: Text(
                          appLocalizations.noMealsYet,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _selectedMeals.length,
                          itemBuilder: (context, index) {
                            final meal = _selectedMeals[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        meal.image,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(meal.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          // Text(meal.categoryName,
                                          //     style: const TextStyle(
                                          //         color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedMeals.removeAt(index);
                                        });
                                      },
                                      child: const Icon(Icons.close,
                                          color: AppColors.gray),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(appLocalizations.details,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                _buildDetailRow(appLocalizations.calories,
                                    meal.nutrients.calories.toString()),
                                _buildDetailRow(appLocalizations.protein,
                                    meal.nutrients.protein.toString()),
                                _buildDetailRow(appLocalizations.fat,
                                    meal.nutrients.fat.toString()),
                                _buildDetailRow(appLocalizations.carbs,
                                    meal.nutrients.netCarbs.toString()),
                                const SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                      ),

                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    color: AppColors.Teal,
                    onClick: () async {
                      try {
                        final mealIds = _selectedMeals
                            .map((meal) => meal.id.toString())
                            .toList();
                        await submitUserMeals(
                          userId: 19,
                          category: _title,
                          mealIds: mealIds,
                        );
                        print(
                            '✅ Meals sent to backend: $mealIds for category $_title');
                      } catch (e) {
                        print('❌ Error submitting meals: $e');
                      }

                      final result = await Navigator.pushNamed(
                          context, MealSenceScreen.routeName, arguments: {
                        'selectedMeals': _selectedMeals,
                        'title': _title
                      });

                      if (result != null && result is Meal) {
                        setState(() {
                          _selectedMeals.add(result);
                        });
                      }

                    },
                    title: "${appLocalizations.addTo} ${_title}",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: isTotal ? Colors.black : Colors.grey)),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? Colors.green : Colors.black,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
