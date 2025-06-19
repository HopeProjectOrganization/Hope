// class Meal {
//   final int id;
//   final String name;
//   final String categoryName;
//   final String categoryThumbnail;
//   final int prepTimeInMinutes;
//   final int cookTimeInMinutes;
//   final String difficulty;
//   final int serving;
//   final List<String> ingredients;
//   final List<double> measurements;
//   final List<String> directions;
//   final double calories;
//   final double protein;
//   final double fat;
//   final double carbs;
//   final String imageUrl;
//
//   Meal({
//     required this.id,
//     required this.name,
//     required this.categoryName,
//     required this.categoryThumbnail,
//     required this.prepTimeInMinutes,
//     required this.cookTimeInMinutes,
//     required this.difficulty,
//     required this.serving,
//     required this.ingredients,
//     required this.measurements,
//     required this.directions,
//     required this.calories,
//     required this.protein,
//     required this.fat,
//     required this.carbs,
//     required this.imageUrl,
//   });
//
//   factory Meal.fromJson(Map<String, dynamic> json) {
//     List<String> ingredients = [];
//     List<double> measurements = [];
//     List<String> directions = [];
//
//     for (int i = 1; i <= 10; i++) {
//       final ingredient = json['ingredient_$i'];
//       final measurement = json['measurement_$i'];
//       final direction = json['directions_step_$i'];
//
//       if (ingredient != null) {
//         ingredients.add(ingredient);
//       }
//
//       if (measurement != null) {
//         measurements.add((measurement as num).toDouble());
//       }
//
//       if (direction != null) {
//         directions.add(direction);
//       }
//     }
//
//     return Meal(
//       id: json['id'] ?? 0,
//       name: json['recipe'] ?? 'No name',
//       categoryName: json['category']?['category'] ?? 'Unknown',
//       categoryThumbnail: json['category']?['thumbnail'] ?? '',
//       prepTimeInMinutes: json['prep_time_in_minutes'] ?? 0,
//       cookTimeInMinutes: json['cook_time_in_minutes'] ?? 0,
//       difficulty: json['difficulty'] ?? 'Unknown',
//       serving: json['serving'] ?? 1,
//       ingredients: ingredients,
//       measurements: measurements,
//       directions: directions,
//       calories: (json['calories'] ?? 0).toDouble(),
//       protein: (json['protein_in_grams'] ?? 0).toDouble(),
//       fat: (json['fat_in_grams'] ?? 0).toDouble(),
//       carbs: (json['carbohydrates_in_grams'] ?? 0).toDouble(),
//       imageUrl: json['image'] ?? '', // <-- استخدم حقل image
//     );
//   }
// }

class Meal {
  final String id;
  final String name;
  final String description;
  final String image;
  final int prepareTime;
  final int cookTime;
  final int servings;
  final List<String> tags;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final Nutrients nutrients;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.prepareTime,
    required this.cookTime,
    required this.servings,
    required this.tags,
    required this.ingredients,
    required this.steps,
    required this.nutrients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString().trim() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      prepareTime: (json['prepareTime'] as num?)?.toInt() ?? 0,
      cookTime: (json['cookTime'] as num?)?.toInt() ?? 0,
      servings: (json['servings'] as num?)?.toInt() ?? 1,
      tags: json['tags'] is List
          ? (json['tags'] as List).map((e) => e.toString()).toList()
          : [],
      ingredients: json['ingredients'] is List
          ? (json['ingredients'] as List)
              .map((i) => i is Map<String, dynamic>
                  ? Ingredient.fromJson(i)
                  : Ingredient.empty())
              .toList()
          : [],
      steps: json['steps'] is List
          ? (json['steps'] as List).map((e) => e.toString()).toList()
          : [],
      nutrients: json['nutrients'] is Map<String, dynamic>
          ? Nutrients.fromJson(json['nutrients'])
          : Nutrients.empty(),
    );
  }
}

class Ingredient {
  final String name;
  final ServingSize servingSize;

  Ingredient({required this.name, required this.servingSize});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name']?.toString() ?? '',
      servingSize: json['servingSize'] is Map<String, dynamic>
          ? ServingSize.fromJson(json['servingSize'])
          : ServingSize.empty(),
    );
  }

  factory Ingredient.empty() {
    return Ingredient(name: '', servingSize: ServingSize.empty());
  }
}

class ServingSize {
  final String units;
  final String desc;
  final double qty;
  final double? grams;
  final double scale;

  ServingSize({
    required this.units,
    required this.desc,
    required this.qty,
    this.grams,
    required this.scale,
  });

  factory ServingSize.fromJson(Map<String, dynamic> json) {
    return ServingSize(
      units: json['units']?.toString() ?? '',
      desc: json['desc']?.toString() ?? '',
      qty: (json['qty'] as num?)?.toDouble() ?? 0.0,
      grams: (json['grams'] as num?)?.toDouble(),
      scale: (json['scale'] as num?)?.toDouble() ?? 1.0,
    );
  }

  factory ServingSize.empty() {
    return ServingSize(units: '', desc: '', qty: 0, grams: 0, scale: 1.0);
  }
}

class Nutrients {
  final double calories;
  final double netCarbs;
  final double protein;
  final double fat;

  Nutrients({
    required this.calories,
    required this.netCarbs,
    required this.protein,
    required this.fat,
  });

  factory Nutrients.fromJson(Map<String, dynamic> json) {
    return Nutrients(
      calories: (json['caloriesKCal'] as num?)?.toDouble() ?? 0.0,
      netCarbs: (json['netCarbs'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory Nutrients.empty() {
    return Nutrients(
      calories: 0,
      netCarbs: 0,
      protein: 0,
      fat: 0,
    );
  }
}
