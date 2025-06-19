

class PlaceModel {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String location;
  final String website;
  final String image;

  PlaceModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.location,
    required this.website,
    required this.image,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] ?? 0,
      name: json['hospitalName'] ?? '',
      phone: (json['hospitalNumber'] ?? '')
          .toString()
          .replaceAll(RegExp(r'[^\d\+]'), '')
          .trim(),
      address: json['hospitalAddress'] ?? '',
      location: json['hospitalLocation'] ?? '',
      website: json['hospitalWebsite'] ?? '',
      image: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hospitalName': name,
      'hospitalNumber': phone,
      'hospitalAddress': address,
      'hospitalLocation': location,
      'hospitalWebsite': website,
      'logo': image,
    };
  }

  @override
  String toString() {
    return 'PlaceModel(name: $name, phone: $phone)';
  }
}
