import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddMealScreen extends StatefulWidget {
  final Function onMealAdded;

  const AddMealScreen({required this.onMealAdded, super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final List<String> days = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة'
  ];
  final List<String> meals = ['فطار', 'غداء', 'عشاء'];

  String? selectedDay;
  String? selectedMeal;
  List<Map<String, TextEditingController>> ingredients = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    addIngredientField(); // أول مكون تلقائيًا
  }

  void addIngredientField() {
    setState(() {
      ingredients.add({
        'name': TextEditingController(),
        'quantity': TextEditingController(),
      });
    });
  }

  Future<Map<String, double>?> fetchNutrition(String name) async {
    final url =
        'http://world.openfoodfacts.org/cgi/search.pl?search_terms=$name&search_simple=1&action=process&json=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['products'] != null && data['products'].length > 0) {
        final nutriments = data['products'][0]['nutriments'];
        return {
          'calories': nutriments['energy-kcal']?.toDouble() ?? 0.0,
          'fat': nutriments['fat']?.toDouble() ?? 0.0,
          'sugar': nutriments['sugars']?.toDouble() ?? 0.0,
          'protein': nutriments['proteins']?.toDouble() ?? 0.0,
        };
      }
    }
    return null;
  }

  Future<void> addMealAndAnalyze() async {
    if (selectedDay == null || selectedMeal == null) return;

    setState(() => isLoading = true);

    double totalCal = 0, totalFat = 0, totalSugar = 0, totalProtein = 0;

    for (var ingredient in ingredients) {
      final name = ingredient['name']!.text.trim();
      final quantity =
          double.tryParse(ingredient['quantity']!.text.trim()) ?? 1;

      final result = await fetchNutrition(name);
      if (result != null) {
        totalCal += result['calories']! * quantity;
        totalFat += result['fat']! * quantity;
        totalSugar += result['sugar']! * quantity;
        totalProtein += result['protein']! * quantity;
      }
    }

    // نرسل البيانات للشاشة الرئيسية
    widget.onMealAdded(
      selectedDay!,
      selectedMeal!,
      {
        'calories': totalCal,
        'fat': totalFat,
        'sugar': totalSugar,
        'protein': totalProtein,
        'ingredients': ingredients
            .map((e) => {
                  'name': e['name']!.text,
                  'quantity': e['quantity']!.text,
                })
            .toList(),
      },
    );

    setState(() => isLoading = false);

    // نعرض الرسالة بعد النجاح
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تمت الإضافة بنجاح"),
        content: const Text("هل ترغب بالانتقال إلى صفحة التقرير؟"),
        actions: [
          TextButton(
            child: const Text("لا"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("نعم"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/report');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة وجبة")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedDay,
              items: days
                  .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                  .toList(),
              onChanged: (value) => setState(() => selectedDay = value),
              decoration: const InputDecoration(labelText: "اختر اليوم"),
            ),
            DropdownButtonFormField<String>(
              value: selectedMeal,
              items: meals
                  .map((meal) =>
                      DropdownMenuItem(value: meal, child: Text(meal)))
                  .toList(),
              onChanged: (value) => setState(() => selectedMeal = value),
              decoration: const InputDecoration(labelText: "نوع الوجبة"),
            ),
            const SizedBox(height: 10),
            const Text("المكونات:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...ingredients.map((e) => Row(
                  children: [
                    Expanded(
                        child: TextField(
                            controller: e['name'],
                            decoration:
                                const InputDecoration(labelText: 'المكون'))),
                    const SizedBox(width: 10),
                    SizedBox(
                        width: 80,
                        child: TextField(
                            controller: e['quantity'],
                            decoration:
                                const InputDecoration(labelText: 'الكمية'),
                            keyboardType: TextInputType.number)),
                  ],
                )),
            TextButton.icon(
              onPressed: addIngredientField,
              icon: const Icon(Icons.add),
              label: const Text("إضافة مكون"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading ? null : addMealAndAnalyze,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("إضافة وتحليل"),
            )
          ],
        ),
      ),
    );
  }
}
