class VeganRecipe {
  final int id;
  final String veganId;
  final String title;
  final String image;

  VeganRecipe({
    required this.id,
    required this.veganId,
    required this.title,
    required this.image,
  });

  factory VeganRecipe.fromJson(Map<String, dynamic> json) {
    return VeganRecipe(
      id: json['id'],
      veganId: json['veganId'],
      title: json['title'],
      image: json['image'],
    );
  }
}