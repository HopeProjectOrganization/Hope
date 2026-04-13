class RecModel {
  final String id;
  final String name;
  final String thumbnail;
  final String category;
  final String area;
  final String instructions;
  final String youtube;
  final Map<String, String> ingredients; // ingredient -> measure
  final String? tags;
  final String? source;

  RecModel({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.category,
    required this.area,
    required this.instructions,
    required this.youtube,
    required this.ingredients,
    this.tags,
    this.source,
  });

  factory RecModel.fromJson(Map<String, dynamic> json) {
    final Map<String, String> ingredientsMap = {};

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      final ing = ingredient?.toString().trim();
      final mea = measure?.toString().trim();

      if (ing != null && ing.isNotEmpty) {
        ingredientsMap[ing] = (mea != null && mea.isNotEmpty) ? mea : '';
      }
    }

    return RecModel(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '',
      thumbnail: json['strMealThumb']?.toString() ?? '',
      category: json['strCategory']?.toString() ?? '',
      area: json['strArea']?.toString() ?? '',
      instructions: json['strInstructions']?.toString() ?? '',
      youtube: json['strYoutube']?.toString() ?? '',
      ingredients: ingredientsMap,
      tags: json['strTags']?.toString(),
      source: json['strSource']?.toString(),
    );
  }

  /// تحويل الـ Map إلى List علشان تعرضه في UI
  List<MapEntry<String, String>> get ingredientsList {
    return ingredients.entries.toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': thumbnail,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strYoutube': youtube,
      'strTags': tags,
      'strSource': source,
    };
  }
}