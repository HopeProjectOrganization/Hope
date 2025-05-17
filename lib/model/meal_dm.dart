class Meal {
  final int id;
  final String name;
  final String categoryName;
  final String categoryThumbnail;
  final int prepTimeInMinutes;
  final int cookTimeInMinutes;
  final String difficulty;
  final int serving;
  final List<String> ingredients;
  final List<double> measurements;
  final List<String> directions;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final String imageUrl;

  Meal({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.categoryThumbnail,
    required this.prepTimeInMinutes,
    required this.cookTimeInMinutes,
    required this.difficulty,
    required this.serving,
    required this.ingredients,
    required this.measurements,
    required this.directions,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.imageUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<double> measurements = [];
    List<String> directions = [];

    for (int i = 1; i <= 10; i++) {
      final ingredient = json['ingredient_$i'];
      final measurement = json['measurement_$i'];
      final direction = json['directions_step_$i'];

      if (ingredient != null) {
        ingredients.add(ingredient);
      }

      if (measurement != null) {
        measurements.add((measurement as num).toDouble());
      }

      if (direction != null) {
        directions.add(direction);
      }
    }

    return Meal(
      id: json['id'] ?? 0,
      name: json['recipe'] ?? 'No name',
      categoryName: json['category']?['category'] ?? 'Unknown',
      categoryThumbnail: json['category']?['thumbnail'] ?? '',
      prepTimeInMinutes: json['prep_time_in_minutes'] ?? 0,
      cookTimeInMinutes: json['cook_time_in_minutes'] ?? 0,
      difficulty: json['difficulty'] ?? 'Unknown',
      serving: json['serving'] ?? 1,
      ingredients: ingredients,
      measurements: measurements,
      directions: directions,
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein_in_grams'] ?? 0).toDouble(),
      fat: (json['fat_in_grams'] ?? 0).toDouble(),
      carbs: (json['carbohydrates_in_grams'] ?? 0).toDouble(),
      imageUrl: json['image'] ?? '',
    );
  }
}
