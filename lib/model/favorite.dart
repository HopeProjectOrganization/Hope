class FavoriteMeal {
  final String mealId;
  final String category;
  final String type;

  FavoriteMeal({
    required this.mealId,
    required this.category,
    required this.type,
  });

  factory FavoriteMeal.fromJson(Map<String, dynamic> json) {
    return FavoriteMeal(
      mealId: json['mealId'],
      category: json['category'],
      type: json['type'],
    );
  }
}
