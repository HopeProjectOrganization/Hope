class RecipeModel {
  final int? id;
  final String recipeId;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String imageUrl;
  final String? tags;
  final String? youtubeUrl;
  final Map<String, String> ingredients;

  RecipeModel({
    this.id,
    required this.recipeId,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.imageUrl,
    this.tags,
    this.youtubeUrl,
    required this.ingredients,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final ingredientsMap = (json['ingredients'] as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        ) ??
        {};

    return RecipeModel(
      id: json['id'],
      recipeId: json['recipeId'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      area: json['area'] ?? '',
      instructions: json['instructions'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      tags: json['tags'],
      youtubeUrl: json['youtubeUrl'],
      ingredients: ingredientsMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipeId': recipeId,
      'name': name,
      'category': category,
      'area': area,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'tags': tags,
      'youtubeUrl': youtubeUrl,
      'ingredients': ingredients,
    };
  }
}
