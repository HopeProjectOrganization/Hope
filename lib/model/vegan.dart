// class VeganRecipe {
//   final int? id;
//   final String veganId;
//   final String title;
//   final String difficulty;
//   final String portion;
//   final String time;
//   final String description;
//   final String image;
//   final List<String> ingredients;
//   final List<StepModel> steps;
//
//   VeganRecipe({
//     this.id,
//     required this.veganId,
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
//   factory VeganRecipe.fromJson(Map<String, dynamic> json) {
//     return VeganRecipe(
//       id: json['id'],
//       veganId: json['veganId'] ?? '',
//       title: json['title'] ?? '',
//       difficulty: json['difficulty'] ?? '',
//       portion: json['portion'] ?? '',
//       time: json['time'] ?? '',
//       description: json['description'] ?? '',
//       image: json['image'] ?? '',
//       ingredients: List<String>.from(json['ingredients'] ?? []),
//       steps: List<StepModel>.from(
//         (json['method'] ?? []).map((e) => StepModel.fromJson(e)),
//       ),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'veganId': veganId,
//       'title': title,
//       'difficulty': difficulty,
//       'portion': portion,
//       'time': time,
//       'description': description,
//       'image': image,
//       'ingredients': ingredients,
//       'method': steps.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class StepModel {
//   final String stepTitle;
//   final String stepDescription;
//
//   StepModel({required this.stepTitle, required this.stepDescription});
//
//   factory StepModel.fromJson(Map<String, dynamic> json) {
//     return StepModel(
//       stepTitle: json['stepTitle'] ?? '',
//       stepDescription: json['stepDescription'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'stepTitle': stepTitle,
//       'stepDescription': stepDescription,
//     };
//   }
// }
