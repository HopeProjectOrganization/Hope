class PlaceModel {
  final String name;
  final String phone;
  final String address;
  final String? website;
  final String? logo;

  PlaceModel({
    required this.name,
    required this.phone,
    required this.address,
    this.website,
    this.logo,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      website: json['website'],
      logo: json['logo'],
    );
  }
}
