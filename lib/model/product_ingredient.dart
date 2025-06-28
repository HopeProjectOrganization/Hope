

class ProductWithIngredient {
  final int id; // ده ID المكون
  final int productId; // ➕ أضيفي ده
  final String productName;
  final String barcode;
  final String productType;
  final String ingredientName;
  final String percentage;

  ProductWithIngredient({
    required this.id,
    required this.productId, // ➕
    required this.productName,
    required this.barcode,
    required this.productType,
    required this.ingredientName,
    required this.percentage,
  });

  factory ProductWithIngredient.fromJson(Map<String, dynamic> json) {
    return ProductWithIngredient(
      id: json['id'],
      productId: json['product']['id'],
      productName: json['product']['productName'],
      barcode: json['product']['barcode'],
      productType: json['product']['productType'],
      ingredientName: json['ingredient']?['ingredientName'] ?? '',
      percentage: json['percentage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': {
        'id': productId, // ✅ ضيفي ده لو هتبعتيه مع التعديل
        'productName': productName,
        'barcode': barcode,
        'productType': productType,
      },
      'ingredientName': ingredientName,
      'percentage': percentage,
    };
  }
}
