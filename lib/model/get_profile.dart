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
  final String username;
  final String name;
  final String phone;
  final String? avatarId;
  final bool isMale;
  final bool smoker;
  final bool haveCancer;
  final String type;
  final bool haveAFamillyCancer;
  final String familyType;
  final String dateOfBirth;
  final String role;

  Data({
    required this.name,
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
      id: json["id"] as int?,
      email: json["email"] ?? 'N/A',
      password: json["password"] ?? '',
      username:
          json["username"]?.isNotEmpty == true ? json["username"] : 'No Name',
      name: json["name"]?.isNotEmpty == true ? json["name"] : 'No Name',
      // تغيير هنا للتحقق من القيمة الفارغة
      phone: json["phone"] ?? '11111111',
      avatarId: json["imageId"] ?? "5",
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
