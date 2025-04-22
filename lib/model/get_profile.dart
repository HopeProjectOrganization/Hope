class GetUserProfileData {
  final String? message;
  final Data? data;

  GetUserProfileData({
    required this.message,
    required this.data,
  });

  factory GetUserProfileData.fromJson(Map<String, dynamic> json) {
    return GetUserProfileData(
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  final int? id;
  final String email;
  final String password;
  final String name;
  final String phone;
  final int? avatarId;
  final bool isMale;
  final bool smoker;
  final bool haveCancer;
  final String type;
  final bool haveAFamillyCancer;
  final String familyType;
  final String dateOfBirth;
  final String role;

  Data({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.phone,
    required this.avatarId,
    required this.isMale,
    required this.smoker,
    required this.haveCancer,
    required this.type,
    required this.haveAFamillyCancer,
    required this.familyType,
    required this.dateOfBirth,
    required this.role,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"] as int?,
      email: json["email"] ?? 'N/A',
      password: json["password"] ?? '',
      name: json["name"] ?? 'N/A',
      phone: json["phone"] ?? '',
      avatarId: json["imageId"] as int?,
      isMale: json["isMale"] ?? false,
      smoker: json["smoker"] ?? false,
      haveCancer: json["haveCancer"] ?? false,
      type: json["type"] ?? 'None',
      haveAFamillyCancer: json["haveAFamillyCancer"] ?? false,
      familyType: json["familyType"] ?? 'None',
      dateOfBirth: json["dateOfBirth"] ?? '',
      role: json["role"] ?? '',
    );
  }
}
