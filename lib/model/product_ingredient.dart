import 'package:hope/Admin/add/admin_product_screen.dart';

class ProductWithIngredient {
  final int id;
  final String productName;
  final String barcode;
  final String productType;
  final String ingredientName;
  final String percentage;
  final List<IngredientEntry> ingredients;

  ProductWithIngredient({
    required this.id,
    required this.productName,
    required this.barcode,
    required this.productType,
    required this.ingredientName,
    required this.percentage,
    this.ingredients = const [],
  });

  factory ProductWithIngredient.fromJson(Map<String, dynamic> json) {
    return ProductWithIngredient(
      id: json['id'],
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
        'productName': productName,
        'barcode': barcode,
        'productType': productType,
      },
      'ingredient': {
        'ingredientName': ingredientName,
      },
      'percentage': percentage,
    };
  }
}
