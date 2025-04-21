import 'package:flutter/material.dart';

class NutrientTablePage extends StatefulWidget {
  @override
  _NutrientTablePageState createState() => _NutrientTablePageState();
}

class _NutrientTablePageState extends State<NutrientTablePage> {
  Map<String, String> nutrientData = {
    'Energy': '200 kcal',
    'Fat': '10 g',
    'Protein': '5 g',
    'Carbohydrate': '30 g',
    'Calcium': '100 mg',
    'Phosphorus': '50 mg',
    'Vitamin A': '500 IU',
    'Vitamin B2': '1 mg',
    'Vitamin B12': '2 µg',
    'Vitamin D': '100 IU',
    'Vitamin E': '15 mg',
  };

  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    nutrientData.forEach((key, value) {
      controllers[key] = TextEditingController(text: value);
    });
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('جدول النسب الغذائية'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('المكون')),
              DataColumn(label: Text('النسبة')),
            ],
            rows: nutrientData.keys.map((key) {
              return DataRow(
                cells: [
                  DataCell(Text(key)),
                  DataCell(
                    TextField(
                      controller: controllers[key],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          nutrientData[key] = newValue;
                        });
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NutrientTablePage(),
  ));
}
