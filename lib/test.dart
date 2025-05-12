// import 'package:flutter/material.dart';
//
// class NutrientTablePage extends StatefulWidget {
//   @override
//   _NutrientTablePageState createState() => _NutrientTablePageState();
// }
//
// class _NutrientTablePageState extends State<NutrientTablePage> {
//   Map<String, String> nutrientData = {
//     'Energy': '200 kcal',
//     'Fat': '10 g',
//     'Protein': '5 g',
//     'Carbohydrate': '30 g',
//     'Calcium': '100 mg',
//     'Phosphorus': '50 mg',
//     'Vitamin A': '500 IU',
//     'Vitamin B2': '1 mg',
//     'Vitamin B12': '2 µg',
//     'Vitamin D': '100 IU',
//     'Vitamin E': '15 mg',
//   };
//
//   final Map<String, TextEditingController> controllers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     nutrientData.forEach((key, value) {
//       controllers[key] = TextEditingController(text: value);
//     });
//   }
//
//   @override
//   void dispose() {
//     controllers.values.forEach((controller) => controller.dispose());
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('جدول النسب الغذائية'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: DataTable(
//             columns: const [
//               DataColumn(label: Text('المكون')),
//               DataColumn(label: Text('النسبة')),
//             ],
//             rows: nutrientData.keys.map((key) {
//               return DataRow(
//                 cells: [
//                   DataCell(Text(key)),
//                   DataCell(
//                     TextField(
//                       controller: controllers[key],
//                       decoration: const InputDecoration(
//                         border: InputBorder.none,
//                         isDense: true,
//                       ),
//                       onChanged: (newValue) {
//                         setState(() {
//                           nutrientData[key] = newValue;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: NutrientTablePage(),
//   ));
// }
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// void main() {
//   runApp(ChatApp());
// }
//
// class ChatApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Ollama Chat AI',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: ChatScreen(),
//     );
//   }
// }
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, String>> _messages = []; // {'role': 'user/ai', 'text': '...'}
//
//   Future<String> sendPromptToLocalAPI(String prompt) async {
//     final response = await http.post(
//       Uri.parse('http://192.168.8.94:8080/api/chat'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'role': 'user',
//         'content': prompt,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       return response.body; // هنا بنرجّع النص مباشرة من السيرفر بدون jsonDecode
//     } else {
//       throw Exception('فشل الاتصال بالخادم المحلي');
//     }
//   }
//
//
//
//   void _sendMessage() async {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;
//
//     setState(() {
//       _messages.add({'role': 'user', 'text': text});
//       _controller.clear();
//     });
//
//     try {
//       final response = await sendPromptToLocalAPI(text);
//       setState(() {
//         _messages.add({'role': 'ai', 'text': response.trim()});
//       });
//     } catch (e) {
//       setState(() {
//         _messages.add({'role': 'ai', 'text': 'حدث خطأ: ${e.toString()}'});
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Ollama Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.all(8),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 final isUser = message['role'] == 'user';
//                 return Align(
//                   alignment:
//                   isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     padding: EdgeInsets.all(12),
//                     margin: EdgeInsets.symmetric(vertical: 4),
//                     decoration: BoxDecoration(
//                       color: isUser ? Colors.blue[100] : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(message['text'] ?? ''),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Divider(height: 1),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     onSubmitted: (_) => _sendMessage(),
//                     decoration: InputDecoration(
//                       hintText: 'اكتب سؤالك...',
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:hope/ui/screens/testt/Addmeal.dart';
import 'package:hope/ui/screens/testt/reportFile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'جدول الوجبات',
      home: MainScreen(),
      routes: {
        '/report': (_) => ReportScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, Map<String, dynamic>> weeklyMeals = {};

  void handleMealAdded(String day, String meal, Map<String, dynamic> data) {
    setState(() {
      weeklyMeals['$day - $meal'] = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("جدول الوجبات الأسبوعي")),
      body: ListView(
        children: [
          ...weeklyMeals.entries.map((entry) {
            return ListTile(
              title: Text(entry.key),
              subtitle: Text(
                  "سعرات: ${entry.value['calories']!.toStringAsFixed(1)} ك.س"),
            );
          }),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddMealScreen(onMealAdded: handleMealAdded),
                  ));
            },
            child: const Text("إضافة وجبة جديدة"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/report', arguments: weeklyMeals);
            },
            child: const Text("عرض التقرير الغذائي"),
          ),
        ],
      ),
    );
  }
}
