class Exercise {
  final int? id;
  final String excersiesId;
  final String name;
  final String gifUrl;
  final String bodyPart;
  final String target;
  final String equipment;
  final List<String> secondaryMuscles;
  final List<String> instructions;

  Exercise({
    this.id,
    required this.excersiesId,
    required this.name,
    required this.gifUrl,
    required this.bodyPart,
    required this.target,
    required this.equipment,
    required this.secondaryMuscles,
    required this.instructions,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] is int ? json['id'] : null,
      excersiesId: json['excersiesId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      gifUrl: json['gifUrl']?.toString() ?? '',
      bodyPart: json['bodyPart']?.toString() ?? '',
      target: json['target']?.toString() ?? '',
      equipment: json['equipment']?.toString() ?? '',
      secondaryMuscles: List<String>.from(json['secondaryMuscles'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'excersiesId': excersiesId,
      'name': name,
      'gifUrl': gifUrl,
      'bodyPart': bodyPart,
      'target': target,
      'equipment': equipment,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
    };
  }
}
