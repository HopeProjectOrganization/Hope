import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args == null || args is! Map<String, Map<String, dynamic>>) {
      return Scaffold(
        appBar: AppBar(title: const Text("تقرير التحليل الغذائي")),
        body: const Center(child: Text("لا توجد بيانات متاحة لعرض التقرير.")),
      );
    }

    final Map<String, Map<String, dynamic>> meals = args;

    double totalCal = 0, totalFat = 0, totalSugar = 0, totalProtein = 0;

    meals.forEach((_, data) {
      totalCal += data['calories'] ?? 0;
      totalFat += data['fat'] ?? 0;
      totalSugar += data['sugar'] ?? 0;
      totalProtein += data['protein'] ?? 0;
    });

    return Scaffold(
      appBar: AppBar(title: const Text("تقرير التحليل الغذائي")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("إجمالي السعرات الحرارية: ${totalCal.toStringAsFixed(1)} ك.س"),
            Text("إجمالي الدهون: ${totalFat.toStringAsFixed(1)} جم"),
            Text("إجمالي السكريات: ${totalSugar.toStringAsFixed(1)} جم"),
            Text("إجمالي البروتين: ${totalProtein.toStringAsFixed(1)} جم"),
            const SizedBox(height: 20),
            const Text("تفصيل الوجبات:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: meals.entries.map((e) {
                  final val = e.value;
                  return ListTile(
                    title: Text(e.key),
                    subtitle: Text(
                      "سعرات: ${val['calories'].toStringAsFixed(1)}, "
                      "دهون: ${val['fat'].toStringAsFixed(1)}, "
                      "سكر: ${val['sugar'].toStringAsFixed(1)}, "
                      "بروتين: ${val['protein'].toStringAsFixed(1)}",
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
