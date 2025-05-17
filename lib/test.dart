// import 'package:flutter/material.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
//
// class ProgressScreen extends StatelessWidget {
//   static const routeName = '/test';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: ListView(
//           padding: EdgeInsets.only(bottom: 20),
//           children: [
//             SizedBox(height: 24),
//             Center(
//               child: Column(
//                 children: [
//                   Text(
//                     'Grafik',
//                     style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     'Penurunan Hari ini',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   SizedBox(height: 32),
//
//                   // الوزن
//                   CircularPercentIndicator(
//                     radius: 100,
//                     lineWidth: 15.0,
//                     percent: 0.75,
//                     center: Text(
//                       "75%",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     progressColor: Colors.blue,
//                     backgroundColor: Colors.grey.shade300,
//                     circularStrokeCap: CircularStrokeCap.round,
//                     footer: Padding(
//                       padding: const EdgeInsets.only(top: 16.0),
//                       child:
//                           Text("Berat Badan", style: TextStyle(fontSize: 16)),
//                     ),
//                   ),
//                   SizedBox(height: 32),
//
//                   // العناصر الغذائية
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Wrap(
//                       alignment: WrapAlignment.center,
//                       spacing: 20,
//                       runSpacing: 20,
//                       children: [
//                         _buildNutrientCircle("Protein", 0.87),
//                         _buildNutrientCircle("Karbohidrat", 0.42),
//                         _buildNutrientCircle("Gula", 0.22),
//                         _buildNutrientCircle("Air", 0.55),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 32),
//
//                   // الزر
//                   ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       backgroundColor: Colors.blue,
//                     ),
//                     child: Text(
//                       'Catat Berat Badan',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNutrientCircle(String label, double percent) {
//     return CircularPercentIndicator(
//       radius: 60,
//       lineWidth: 8.0,
//       percent: percent,
//       center: Text(
//         "${(percent * 100).toInt()}%",
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       progressColor: Colors.blue,
//       backgroundColor: Colors.grey.shade200,
//       circularStrokeCap: CircularStrokeCap.round,
//       footer: Padding(
//         padding: const EdgeInsets.only(top: 8.0),
//         child: Text(label, style: TextStyle(fontSize: 14)),
//       ),
//     );
//   }
// }
