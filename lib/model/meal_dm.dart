
class Meal {
  final String id;
  final String name;
  final String description;
  final String image;
  final int prepareTime;
  final int cookTime;
  final int servings;
  final List<String> tags;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final Nutrients nutrients;
  DateTime? date; // ⬅️ أضفنا ده

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.prepareTime,
    required this.cookTime,
    required this.servings,
    required this.tags,
    required this.ingredients,
    required this.steps,
    required this.nutrients,
    this.date, // ⬅️ مهم
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString().trim() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      prepareTime: (json['prepareTime'] as num?)?.toInt() ?? 0,
      cookTime: (json['cookTime'] as num?)?.toInt() ?? 0,
      servings: (json['servings'] as num?)?.toInt() ?? 1,
      tags: json['tags'] is List
          ? (json['tags'] as List).map((e) => e.toString()).toList()
          : [],
      ingredients: json['ingredients'] is List
          ? (json['ingredients'] as List)
              .map((i) => i is Map<String, dynamic>
                  ? Ingredient.fromJson(i)
                  : Ingredient.empty())
              .toList()
          : [],
      steps: json['steps'] is List
          ? (json['steps'] as List).map((e) => e.toString()).toList()
          : [],
      nutrients: json['nutrients'] is Map<String, dynamic>
          ? Nutrients.fromJson(json['nutrients'])
          : Nutrients.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'prepareTime': prepareTime,
      'cookTime': cookTime,
      'servings': servings,
      'tags': tags,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'steps': steps,
      'nutrients': nutrients.toJson(),
    };
  }

  Meal copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    int? prepareTime,
    int? cookTime,
    int? servings,
    List<String>? tags,
    List<Ingredient>? ingredients,
    List<String>? steps,
    Nutrients? nutrients,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      prepareTime: prepareTime ?? this.prepareTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      tags: tags ?? this.tags,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      nutrients: nutrients ?? this.nutrients,
    );
  }
}

class Ingredient {
  final String name;
  final ServingSize servingSize;

  Ingredient({required this.name, required this.servingSize});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name']?.toString() ?? '',
      servingSize: json['servingSize'] is Map<String, dynamic>
          ? ServingSize.fromJson(json['servingSize'])
          : ServingSize.empty(),
    );
  }

  factory Ingredient.empty() {
    return Ingredient(name: '', servingSize: ServingSize.empty());
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'servingSize': servingSize.toJson(),
    };
  }
}

class ServingSize {
  final String units;
  final String desc;
  final double qty;
  final double? grams;
  final double scale;

  ServingSize({
    required this.units,
    required this.desc,
    required this.qty,
    this.grams,
    required this.scale,
  });

  factory ServingSize.fromJson(Map<String, dynamic> json) {
    return ServingSize(
      units: json['units']?.toString() ?? '',
      desc: json['desc']?.toString() ?? '',
      qty: (json['qty'] as num?)?.toDouble() ?? 0.0,
      grams: (json['grams'] as num?)?.toDouble(),
      scale: (json['scale'] as num?)?.toDouble() ?? 1.0,
    );
  }

  factory ServingSize.empty() {
    return ServingSize(units: '', desc: '', qty: 0, grams: 0, scale: 1.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'units': units,
      'desc': desc,
      'qty': qty,
      'grams': grams,
      'scale': scale,
    };
  }
}

class Nutrients {
  final double calories;
  final double netCarbs;
  final double protein;
  final double fat;

  Nutrients({
    required this.calories,
    required this.netCarbs,
    required this.protein,
    required this.fat,
  });

  factory Nutrients.fromJson(Map<String, dynamic> json) {
    return Nutrients(
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      netCarbs: (json['netCarbs'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory Nutrients.empty() {
    return Nutrients(
      calories: 0,
      netCarbs: 0,
      protein: 0,
      fat: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'netCarbs': netCarbs,
      'protein': protein,
      'fat': fat,
    };
  }
}
