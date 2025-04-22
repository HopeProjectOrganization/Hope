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
  final String? id;
  final String? email;
  final String? password;
  final String? username;
  final String? phone;
  final int? avatarId;
  final bool isMale;
  final bool smoker;
  final bool haveCancer;
  final String? type;
  final bool haveAFamillyCancer;
  final String? familyType;
  final String dateOfBirth;
  final String role;

  Data({
    required this.id,
    required this.username,
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
      id: json["id"],
      email: json["email"],
      password: json["password"],
      username: json["username"] ?? 'NNN',
      phone: json["phone"],
      avatarId: json["avaterId"],
      isMale: json["isMale"] ?? false,
      // تأكد من أن الاسم في JSON مطابق
      smoker: json["smoker"] ?? false,
      haveCancer: json["haveCancer"] ?? false,
      type: json["type"],
      haveAFamillyCancer: json["haveAFamillyCancer"] ?? false,
      // تأكد من أن الاسم في JSON مطابق
      familyType: json["familyType"],
      dateOfBirth: json["dateOfBirth"] ?? "",
      // تأكد من أن الاسم في JSON مطابق
      role: json["role"] ?? "",
    );
  }
}
