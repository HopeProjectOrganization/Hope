// //   import 'dart:convert';
// //   import 'package:flutter/material.dart';
// // import 'package:hope/core/assets/app_assets.dart';
// //   import 'package:hope/core/theme/app_colors.dart';
// //   import 'package:http/http.dart' as http;
// //
// //   void main() {
// //     runApp(const ExerciseApp());
// //   }
// //
// //   class ExerciseApp extends StatelessWidget {
// //     const ExerciseApp({super.key});
// //
// //     @override
// //     Widget build(BuildContext context) {
// //       return MaterialApp(
// //         title: 'Exercise App',
// //         debugShowCheckedModeBanner: false,
// //         home:  BodyPartScreen(),
// //       );
// //     }
// //   }
// //
// //   // ========== Data Models ==========
// //
// //   class Exercise {
// //     final String id;
// //     final String name;
// //     final String gifUrl;
// //     final String bodyPart;
// //     final String target;
// //     final String equipment;
// //     final List<String> secondaryMuscles;
// //     final List<String> instructions;
// //
// //     Exercise({
// //       required this.id,
// //       required this.name,
// //       required this.gifUrl,
// //       required this.bodyPart,
// //       required this.target,
// //       required this.equipment,
// //       required this.secondaryMuscles,
// //       required this.instructions,
// //     });
// //
// //     factory Exercise.fromJson(Map<String, dynamic> json) {
// //       return Exercise(
// //         id: json['id'],
// //         name: json['name'],
// //         gifUrl: json['gifUrl'],
// //         bodyPart: json['bodyPart'],
// //         target: json['target'],
// //         equipment: json['equipment'],
// //         secondaryMuscles: List<String>.from(json['secondaryMuscles'] ?? []),
// //         instructions: List<String>.from(json['instructions'] ?? []),
// //       );
// //     }
// //   }
// //
// //   // ========== Body Parts Screen ==========
// //
// //   class BodyPartScreen extends StatelessWidget {
// //      BodyPartScreen({super.key});
// //
// //     final Map<String, String> bodyPartImages = {
// //       "back": AppAssets.ex1,
// //       "cardio": AppAssets.ex2,
// //       "chest": AppAssets.ex3,
// //       "lower arms": AppAssets.ex4,
// //       "lower legs": AppAssets.ex1,
// //       "neck": AppAssets.ex1,
// //       "shoulders": AppAssets.ex1,
// //       "upper arms": AppAssets.ex1,
// //       "upper legs": AppAssets.ex1,
// //       "waist": AppAssets.ex1,
// //     };
// //
// //     final List<String> bodyParts = [
// //       "back",
// //       "cardio",
// //       "chest",
// //       "lower arms",
// //       "lower legs",
// //       "neck",
// //       "shoulders",
// //       "upper arms",
// //       "upper legs",
// //       "waist",
// //     ];
// //
// //     @override
// //     Widget build(BuildContext context) {
// //       return Scaffold(
// //         backgroundColor: AppColors.white,
// //         appBar: AppBar(title: const Text("Choose your train")),
// //         body: ListView.builder(
// //           itemCount: bodyParts.length,
// //           itemBuilder: (context, index) {
// //             return Container(
// //               margin: const EdgeInsets.all(16),
// //               padding: const EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: Color(0xffe7e1f6),
// //                 borderRadius: BorderRadius.circular(20),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black12,
// //                     blurRadius: 10,
// //                     offset: Offset(0, 5),
// //                   ),
// //                 ],
// //               ),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           bodyParts[index].toUpperCase(),
// //                           style: const TextStyle(
// //                             fontSize: 18,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.black87,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 24),
// //                         InkWell(
// //                           onTap: () {
// //                             Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (_) => ExerciseListScreen(bodyPart: bodyParts[index]),
// //                               ),
// //                             );
// //                           },
// //                           child: Container(
// //                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                             decoration: BoxDecoration(
// //                               color: AppColors.white,
// //                               borderRadius: BorderRadius.circular(30),
// //                             ),
// //                             child: Row(
// //                               mainAxisSize: MainAxisSize.min,
// //                               children: const [
// //                                 Text(
// //                                   "View more",
// //                                   style: TextStyle(
// //                                     color: AppColors.purple,
// //                                     fontWeight: FontWeight.w500,
// //                                   ),
// //                                 ),
// //                                 SizedBox(width: 6),
// //                                 Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.purple),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(width: 16),
// //                   ClipRRect(
// //                     borderRadius: BorderRadius.circular(12),
// //                     child: Image.asset(
// //                       bodyPartImages[bodyParts[index]] ?? "",
// //                       width: 90,
// //                       height: 90,
// //                       fit: BoxFit.cover,
// //                       errorBuilder: (_, __, ___) => Container(
// //                         width: 80,
// //                         height: 80,
// //                         color: Colors.grey[200],
// //                         child: const Icon(Icons.image, size: 40, color: Colors.grey),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //         ),
// //       );
// //     }
// //   }
// //
// //   // ========== Exercise List Screen ==========
// //
// //   class ExerciseListScreen extends StatefulWidget {
// //     final String bodyPart;
// //     const ExerciseListScreen({super.key, required this.bodyPart});
// //
// //     @override
// //     State<ExerciseListScreen> createState() => _ExerciseListScreenState();
// //   }
// //
// //   class _ExerciseListScreenState extends State<ExerciseListScreen> {
// //     late Future<List<Exercise>> futureExercises;
// //
// //     @override
// //     void initState() {
// //       super.initState();
// //       futureExercises = fetchExercisesByBodyPart(widget.bodyPart);
// //     }
// //
// //     Future<List<Exercise>> fetchExercisesByBodyPart(String bodyPart) async {
// //       final String url = 'https://exercisedb.p.rapidapi.com/exercises/bodyPart/$bodyPart?limit=20';
// //       const Map<String, String> headers = {
// //         'x-rapidapi-key': 'cee3c198b5msh06fb61b0d1e747fp11e9cfjsn1b083226fe05',
// //         'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
// //       };
// //
// //       final response = await http.get(Uri.parse(url), headers: headers);
// //       if (response.statusCode == 200) {
// //         List data = jsonDecode(response.body);
// //         return data.map((e) => Exercise.fromJson(e)).toList();
// //       } else {
// //         throw Exception('Failed to load exercises');
// //       }
// //     }
// //
// //     @override
// //     Widget build(BuildContext context) {
// //       return Scaffold(
// //         backgroundColor: AppColors.white,
// //         appBar: AppBar(title: Text("${widget.bodyPart.toUpperCase()} Exercises")),
// //         body: FutureBuilder<List<Exercise>>(
// //           future: futureExercises,
// //           builder: (context, snapshot) {
// //             if (snapshot.connectionState == ConnectionState.waiting) {
// //               return const Center(child: CircularProgressIndicator());
// //             } else if (snapshot.hasError) {
// //               return Center(child: Text("Error: ${snapshot.error}"));
// //             }
// //
// //             final exercises = snapshot.data!;
// //             return ListView.builder(
// //               itemCount: exercises.length,
// //               itemBuilder: (context, index) {
// //                 final exercise = exercises[index];
// //                 return Container(
// //                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(20),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black.withOpacity(0.05),
// //                         blurRadius: 10,
// //                         offset: const Offset(0, 5),
// //                       ),
// //                     ],
// //                   ),
// //                   child: InkWell(
// //                     borderRadius: BorderRadius.circular(20),
// //                     onTap: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (_) => ExerciseDetailScreen(exercise: exercise),
// //                         ),
// //                       );
// //                     },
// //                     child: Row(
// //                       children: [
// //                         // صورة التمرين
// //                         ClipRRect(
// //                           borderRadius: const BorderRadius.only(
// //                             topLeft: Radius.circular(20),
// //                             bottomLeft: Radius.circular(20),
// //                           ),
// //                           child: Image.network(
// //                             exercise.gifUrl,
// //                             width: 100,
// //                             height: 100,
// //                             fit: BoxFit.cover,
// //                             errorBuilder: (_, __, ___) => const Icon(Icons.image),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 16),
// //                         // معلومات التمرين
// //                         Expanded(
// //                           child: Padding(
// //                             padding: const EdgeInsets.symmetric(vertical: 16.0),
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Text(
// //                                   exercise.name,
// //                                   style: const TextStyle(
// //                                     fontSize: 16,
// //                                     fontWeight: FontWeight.bold,
// //                                     color: Colors.black87,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                         // السهم
// //                         const Padding(
// //                           padding: EdgeInsets.only(right: 16.0),
// //                           child: Icon(
// //                             Icons.arrow_forward_ios_rounded,
// //                             size: 18,
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //
// //               },
// //             );
// //           },
// //         ),
// //       );
// //     }
// //   }
// //
// //   // ========== Exercise Detail Screen ==========
// //
// //   class ExerciseDetailScreen extends StatelessWidget {
// //     final Exercise exercise;
// //     const ExerciseDetailScreen({super.key, required this.exercise});
// //
// //     @override
// //     Widget build(BuildContext context) {
// //       return Scaffold(
// //         backgroundColor: AppColors.white,
// //         appBar: AppBar(),
// //         body: SafeArea(
// //           child: SingleChildScrollView(
// //             child: Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 16),
// //               child: Column(
// //                 children: [
// //                   const SizedBox(height: 16),
// //                   // Header & Media
// //                   Stack(
// //                     children: [
// //                       ClipRRect(
// //                         borderRadius: BorderRadius.circular(24),
// //                         child: Image.network(
// //                           exercise.gifUrl,
// //                           height: 220,
// //                           width: double.infinity,
// //                           fit: BoxFit.cover,
// //                           errorBuilder: (_, __, ___) => const SizedBox(
// //                             height: 220,
// //                             child: Icon(Icons.image_not_supported, size: 80),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 20),
// //                   // Title & Info
// //                   Align(
// //                     alignment: Alignment.centerLeft,
// //                     child: Text(
// //                       exercise.name,
// //                       style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   Align(
// //                     alignment: Alignment.centerLeft,
// //                     child: Text(
// //                       "Muscles : ",
// //                       style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold ,color: AppColors.dark),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Align(
// //                     alignment: Alignment.centerLeft,
// //                     child: Text(
// //                       exercise.secondaryMuscles.join(', '),
// //                       style: const TextStyle(fontSize: 14, color: AppColors.gray),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   // Steps Section
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       const Text("How To Do It", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //                       Text("${exercise.instructions.length} Steps", style: const TextStyle(color: Colors.grey)),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 16),
// //                   ...exercise.instructions.asMap().entries.map((entry) {
// //                     final index = entry.key + 1;
// //                     final step = entry.value;
// //                     return Column(
// //                       children: [
// //                         Row(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Column(
// //                               children: [
// //                                 CircleAvatar(
// //                                   radius: 14,
// //                                   backgroundColor: AppColors.lavender,
// //                                   child: Text(
// //                                     index.toString().padLeft(2, '0'),
// //                                     style: const TextStyle(color: AppColors.purple, fontWeight: FontWeight.bold, fontSize: 12),
// //                                   ),
// //                                 ),
// //                                 if (index != exercise.instructions.length)
// //                                   Container(
// //                                     width: 2,
// //                                     height: 50,
// //                                     color: Colors.purple.shade100,
// //                                   ),
// //                               ],
// //                             ),
// //                             const SizedBox(width: 12),
// //                             Expanded(
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text(
// //                                     _getStepTitle(index),
// //                                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                                   ),
// //                                   const SizedBox(height: 4),
// //                                   Text(
// //                                     step,
// //                                     style: const TextStyle(color: Colors.black87, height: 1.4),
// //                                   ),
// //                                   const SizedBox(height: 20),
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     );
// //                   }),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       );
// //     }
// //
// //     String _getStepTitle(int index) {
// //       switch (index) {
// //         default:
// //           return "Step $index";
// //       }
// //     }
// //   }
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:hope/core/theme/app_colors.dart';
// import 'package:http/http.dart' as http;
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Vegan Recipes',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Arial',
//         colorScheme: ColorScheme.fromSeed(seedColor: AppColors.purple),
//         useMaterial3: true,
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }
//
// class VeganRecipe {
//   final String id, title, difficulty, image;
//
//   VeganRecipe({
//     required this.id,
//     required this.title,
//     required this.difficulty,
//     required this.image,
//   });
//
//   factory VeganRecipe.fromJson(Map<String, dynamic> json) {
//     return VeganRecipe(
//       id: json['id'].toString(),
//       title: json['title'] ?? '',
//       difficulty: json['difficulty'] ?? '',
//       image: json['image'] ?? '',
//     );
//   }
// }
//
// class VeganRecipeDetail {
//   final String id, title, difficulty, portion, time, description, image;
//   final List<String> ingredients;
//   final List<String> steps;
//
//   VeganRecipeDetail({
//     required this.id,
//     required this.title,
//     required this.difficulty,
//     required this.portion,
//     required this.time,
//     required this.description,
//     required this.image,
//     required this.ingredients,
//     required this.steps,
//   });
//
//   factory VeganRecipeDetail.fromJson(Map<String, dynamic> json) {
//     // خطوات التحضير (method) في شكل Map أو List من الـ Steps، نحتاج نأخذ النص فقط
//     List<String> steps = [];
//     if (json['method'] != null) {
//       if (json['method'] is List) {
//         // كل عنصر في method هو Map مع مفتاح مثل "Step 1"
//         steps = (json['method'] as List).map((stepMap) {
//           if (stepMap is Map) {
//             // ناخد قيمة أول مفتاح في الخريطة (Step 1, Step 2, ...)
//             return stepMap.values.first.toString();
//           }
//           return '';
//         }).toList();
//       }
//     }
//
//     return VeganRecipeDetail(
//       id: json['id'].toString(),
//       title: json['title'] ?? '',
//       difficulty: json['difficulty'] ?? '',
//       portion: json['portion'] ?? '',
//       time: json['time'] ?? '',
//       description: json['description'] ?? '',
//       image: json['image'] ?? '',
//       ingredients: json['ingredients'] != null
//           ? List<String>.from(json['ingredients'])
//           : [],
//       steps: steps,
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final apiKey = 'cee3c198b5msh06fb61b0d1e747fp11e9cfjsn1b083226fe05';
//   List<VeganRecipe> recipes = [];
//   bool loading = true;
//   String error = '';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRecipes();
//   }
//
//   Future<void> fetchRecipes() async {
//     final url = Uri.parse('https://the-vegan-recipes-db.p.rapidapi.com/');
//     try {
//       final res = await http.get(url, headers: {
//         'x-rapidapi-key': apiKey,
//         'x-rapidapi-host': 'the-vegan-recipes-db.p.rapidapi.com',
//       });
//
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         setState(() {
//           recipes = (data as List).map((e) => VeganRecipe.fromJson(e)).toList();
//           loading = false;
//         });
//       } else {
//         setState(() {
//           error = 'Failed to load recipes';
//           loading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//         loading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F5F7),
//       appBar: AppBar(
//         title: const Text('🌿 Vegan Recipes'),
//         backgroundColor: AppColors.purple,
//         // موف غامق
//         foregroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 5,
//         shadowColor: AppColors.lavender.withOpacity(0.6),
//       ),
//       body: loading
//           ? const Center(
//               child: CircularProgressIndicator(color: AppColors.purple))
//           : error.isNotEmpty
//               ? Center(
//                   child: Text(
//                     error,
//                     style: const TextStyle(
//                         color: AppColors.purple, fontWeight: FontWeight.w600),
//                   ),
//                 )
//               : ListView.builder(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   itemCount: recipes.length,
//                   itemBuilder: (_, index) {
//                     final recipe = recipes[index];
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => RecipeDetailsScreen(id: recipe.id),
//                           ),
//                         );
//                       },
//                       child: buildRecipeCard(recipe),
//                     );
//                   },
//                 ),
//     );
//   }
//
//   Widget buildRecipeCard(VeganRecipe recipe) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.lavender.withOpacity(0.25),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.star_border,
//                       color: AppColors.purple, size: 22),
//                   const SizedBox(height: 8),
//                   Text(
//                     recipe.title,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: AppColors.dark,
//                       letterSpacing: 0.4,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: AppColors.lavender.withOpacity(0.4),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       recipe.difficulty.toUpperCase(),
//                       style: const TextStyle(
//                         color: AppColors.purple,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 14,
//                         letterSpacing: 0.8,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           ClipPath(
//             clipper: HalfCircleClipper(),
//             child: Image.network(
//               recipe.image,
//               width: 170,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class RecipeDetailsScreen extends StatefulWidget {
//   final String id;
//
//   const RecipeDetailsScreen({super.key, required this.id});
//
//   @override
//   State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
// }
//
// class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
//   final apiKey = 'cee3c198b5msh06fb61b0d1e747fp11e9cfjsn1b083226fe05';
//   late Future<VeganRecipeDetail> recipeDetailFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     recipeDetailFuture = fetchRecipeDetail();
//   }
//
//   Future<VeganRecipeDetail> fetchRecipeDetail() async {
//     final url =
//         Uri.parse('https://the-vegan-recipes-db.p.rapidapi.com/${widget.id}');
//     final res = await http.get(url, headers: {
//       'x-rapidapi-key': apiKey,
//       'x-rapidapi-host': 'the-vegan-recipes-db.p.rapidapi.com',
//     });
//
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       return VeganRecipeDetail.fromJson(data);
//     } else {
//       throw Exception('Failed to load recipe details');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F5F7),
//       appBar: AppBar(
//         backgroundColor: AppColors.purple,
//         // لون الموف الغامق
//         title: const Text('Recipe Details'),
//         centerTitle: true,
//         elevation: 4,
//         shadowColor: AppColors.lavender.withOpacity(0.5),
//       ),
//       body: FutureBuilder<VeganRecipeDetail>(
//         future: recipeDetailFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return const Center(child: Text('No details found.'));
//           }
//
//           final recipe = snapshot.data!;
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(40),
//                     bottomRight: Radius.circular(40),
//                   ),
//                   child: Image.network(
//                     recipe.image,
//                     width: double.infinity,
//                     height: 260,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         recipe.title,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 28,
//                           color: AppColors.dark,
//                           letterSpacing: 0.6,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Wrap(
//                         spacing: 12,
//                         runSpacing: 8,
//                         children: [
//                           Chip(
//                             label: Text(recipe.difficulty,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w600)),
//                             backgroundColor:
//                                 AppColors.lavender.withOpacity(0.4),
//                             avatar: const Icon(Icons.fitness_center,
//                                 size: 20, color: AppColors.purple),
//                           ),
//                           Chip(
//                             label: Text(recipe.portion,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w600)),
//                             backgroundColor:
//                                 AppColors.lavender.withOpacity(0.4),
//                             avatar: const Icon(Icons.people,
//                                 size: 20, color: AppColors.purple),
//                           ),
//                           Chip(
//                             label: Text(recipe.time,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w600)),
//                             backgroundColor:
//                                 AppColors.lavender.withOpacity(0.4),
//                             avatar: const Icon(Icons.timer,
//                                 size: 20, color: AppColors.purple),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 20),
//                       Text(
//                         recipe.description,
//                         style: const TextStyle(
//                           fontSize: 17,
//                           height: 1.4,
//                           color: AppColors.dark,
//                         ),
//                       ),
//
//                       const SizedBox(height: 30),
//
//                       // Ingredients Section
//                       Container(
//                         decoration: BoxDecoration(
//                           color: AppColors.lavender.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Icons.restaurant_menu,
//                                     color: AppColors.purple),
//                                 const SizedBox(width: 8),
//                                 const Text(
//                                   'Ingredients',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 22,
//                                     color: AppColors.purple,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             ...recipe.ingredients.map(
//                               (ingredient) => Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 6),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Icon(Icons.circle,
//                                         size: 8,
//                                         color:
//                                             AppColors.purple.withOpacity(0.7)),
//                                     const SizedBox(width: 10),
//                                     Expanded(
//                                       child: Text(
//                                         ingredient,
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           height: 1.4,
//                                           color: AppColors.dark,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 30),
//
//                       // Preparation Steps Section
//                       Container(
//                         decoration: BoxDecoration(
//                           color: AppColors.lavender.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Icons.format_list_numbered,
//                                     color: AppColors.purple),
//                                 const SizedBox(width: 8),
//                                 const Text(
//                                   'Preparation Steps',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 22,
//                                     color: AppColors.purple,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             ...recipe.steps.asMap().entries.map(
//                                   (entry) => Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 10),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         CircleAvatar(
//                                           radius: 12,
//                                           backgroundColor: AppColors.purple,
//                                           child: Text(
//                                             '${entry.key + 1}',
//                                             style: const TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Expanded(
//                                           child: Text(
//                                             entry.value,
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               height: 1.4,
//                                               color: AppColors.dark,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class HalfCircleClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//
//     // نبدأ من أعلى اليمين
//     path.moveTo(size.width, 0);
//
//     // نرسم خط أفقي إلى أعلى اليسار
//     path.lineTo(size.height, 0);
//
//     // نرسم نصف دائرة إلى الأسفل على اليسار
//     path.arcToPoint(
//       Offset(size.height / 2, size.height),
//       radius: Radius.circular(size.height / 2),
//       clockwise: false,
//     );
//
//     // نرسم خط أفقي إلى أسفل اليمين
//     path.lineTo(size.width, size.height);
//
//     // نغلق المسار
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }
