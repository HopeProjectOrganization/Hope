import 'package:flutter/material.dart';
import 'package:hope/model/meal_dm.dart'; // تأكد من import الموديل
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressScreen extends StatelessWidget {
  static const routeName = '/test';

  final Meal meal;

  const ProgressScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    // نحسب القيم الغذائية كنسبة مئوية من إجمالي المغذيات
    final totalMacros =
        (meal.fat ?? 0) + (meal.protein ?? 0) + (meal.carbs ?? 0);
    double fatPercent = totalMacros == 0 ? 0 : (meal.fat ?? 0) / totalMacros;
    double proteinPercent =
        totalMacros == 0 ? 0 : (meal.protein ?? 0) / totalMacros;
    double carbPercent = totalMacros == 0 ? 0 : (meal.carbs ?? 0) / totalMacros;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  const Text('Progress',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const Text('تفاصيل الوجبة الحالية',
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 32),

                  // السعرات الحرارية (كمؤشر دائري رئيسي)
                  CircularPercentIndicator(
                    radius: 100,
                    lineWidth: 15.0,
                    percent: (meal.calories ?? 0) / 2000 > 1
                        ? 1
                        : (meal.calories ?? 0) / 2000,
                    center: Text(
                      "${meal.calories?.toInt() ?? 0} cal",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    progressColor: Colors.orange,
                    backgroundColor: Colors.grey.shade300,
                    circularStrokeCap: CircularStrokeCap.round,
                    footer: const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text("السعرات الحرارية",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // العناصر الغذائية (دائرة صغيرة لكل عنصر)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildNutrientCircle(
                            "بروتين", proteinPercent, Colors.blue),
                        _buildNutrientCircle(
                            "كربوهيدرات", carbPercent, Colors.purple),
                        _buildNutrientCircle("دهون", fatPercent, Colors.amber),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('رجوع',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientCircle(String label, double percent, Color color) {
    return CircularPercentIndicator(
      radius: 60,
      lineWidth: 8.0,
      percent: percent.clamp(0.0, 1.0),
      center: Text(
        "${(percent * 100).toInt()}%",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      progressColor: color,
      backgroundColor: Colors.grey.shade200,
      circularStrokeCap: CircularStrokeCap.round,
      footer: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
