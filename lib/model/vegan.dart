class VeganRecipe {
  final String id, title, difficulty, image;

  VeganRecipe({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.image,
  });

  factory VeganRecipe.fromJson(Map<String, dynamic> json) {
    return VeganRecipe(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      difficulty: json['difficulty'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
