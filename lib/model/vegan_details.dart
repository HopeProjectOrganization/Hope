class VeganRecipeDetail {
  final String id, title, difficulty, portion, time, description, image;
  final List<String> ingredients;
  final List<String> steps;

  VeganRecipeDetail({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.portion,
    required this.time,
    required this.description,
    required this.image,
    required this.ingredients,
    required this.steps,
  });

  factory VeganRecipeDetail.fromJson(Map<String, dynamic> json) {
    List<String> steps = [];
    if (json['method'] != null && json['method'] is List) {
      steps = (json['method'] as List).map((stepMap) {
        if (stepMap is Map) return stepMap.values.first.toString();
        return '';
      }).toList();
    }

    return VeganRecipeDetail(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      difficulty: json['difficulty'] ?? '',
      portion: json['portion'] ?? '',
      time: json['time'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: steps,
    );
  }
}
