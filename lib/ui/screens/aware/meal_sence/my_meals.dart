import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Api/profile/profile_service.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/main.dart';
import 'package:hope/model/get_profile.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/ui/screens/aware/meal_sence/meal_sence_screen.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isLoading = true;
  Data? userProfile; // لتخزين بيانات  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    _selectedMeals = List.from(widget.selectedMeals);
    loadTokenAndProfile();
  }

  Future<void> loadTokenAndProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('auth_token');

    if (storedToken != null) {
      setState(() {
        token = storedToken;
      });
      await fetchUserProfile(storedToken);
    } else {
      setState(() {
        isLoading = false;
        token = null;
        userProfile = null;
      });
    }
  }

  Future<bool> sendMealsToBackend({
    required int userId,
    required String token,
    required String category,
    required List<String> mealIds,
    required String dateTime,
  }) async {
    final url =
        Uri.parse('http://${MyApp.IP}/api/user-meals'); // عدل الرابط حسب API

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': userId,
          'category': category,
          'mealIds': mealIds,
          'dateTime': dateTime,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to send meals: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending meals: $e');
      return false;
    }
  }

  Future<void> fetchUserProfile(String token) async {
    GetUserProfile fetchUserProfile = GetUserProfile();
    Data? profileData = await fetchUserProfile.fetchUserProfile(token);

    if (mounted) {
      setState(() {
        if (profileData != null) {
          userProfile = profileData;
          isLoading = false;
        } else {
          userProfile = null;
          isLoading = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProfile == null) {
      return Center(child: Text('Failed to load user profile.'));
    }

    final userId = userProfile!.id ?? 0;
    final dateTime = DateTime.now().toIso8601String(); // الوقت الحالي بصيغة ISO
    final category = _title.toLowerCase(); // breakfast, lunch, dinner
    final mealIds = _selectedMeals.map((meal) => meal.id.toString()).toList();

    return CustomScaffold(
      title: "My Meals for",
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.purple),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Icon
                Row(
                  children: [
                    ImageIcon(AssetImage(AppIcons.meal),
                        color: AppColors.purple),
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
                          "Total Calories : ${_selectedMeals.isEmpty ? 0 : _selectedMeals.fold(0.0, (total, meal) => total + meal.calories).toInt()}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Meals Title
                const Text("Meals",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                _selectedMeals.isEmpty
                    ? const Center(
                        child: Text(
                          "No meals yet.",
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
                                        meal.imageUrl,
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
                                          Text(meal.categoryName,
                                              style: const TextStyle(
                                                  color: Colors.grey)),
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
                                const Text("Details",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                _buildDetailRow(
                                    "Calories", meal.calories.toString()),
                                _buildDetailRow(
                                    "Protein", meal.protein.toString()),
                                _buildDetailRow("Fat", meal.fat.toString()),
                                _buildDetailRow("Carbs", meal.carbs.toString()),
                                const SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                      ),

                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    color: AppColors.purple,
                    onClick: () async {
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
                      if (userProfile != null && token != null) {
                        final success = await sendMealsToBackend(
                            userId: userId,
                            token: token!,
                            category: category,
                            mealIds: mealIds,
                            dateTime: dateTime);

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Meals added successfully')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to add meals to server')),
                          );
                        }
                      }
                    },
                    title: "Add to ${_title}",
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
