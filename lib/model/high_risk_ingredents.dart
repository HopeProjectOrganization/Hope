class HighRiskIngredient {
  final int? id;
  final String ingredientName;
  final String riskLevel;
  final String safeLimit;
  final String englishDescription;
  final String arabicDescription;

  HighRiskIngredient({
    this.id,
    required this.ingredientName,
    required this.riskLevel,
    required this.safeLimit,
    required this.englishDescription,
    required this.arabicDescription,
  });

  factory HighRiskIngredient.fromJson(Map<String, dynamic> json) {
    return HighRiskIngredient(
      id: json['id'],
      ingredientName: json['ingredientName'],
      riskLevel: json['riskLevel'],
      safeLimit: json['safeLimit'] ?? '',
      englishDescription: json['english_description'],
      arabicDescription: json['arabic_description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingredientName': ingredientName,
      'riskLevel': riskLevel,
      'safeLimit': safeLimit,
      'english_description': englishDescription,
      'arabic_description': arabicDescription,
    };
  }
}
