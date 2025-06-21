class RegisterRequestModel {
  final String name;
  final String username;
  final String email;
  final int imageId;
  final String password;
  final String phone;
  final bool? isMale;
  final bool smoker;
  final bool haveCancer;
  final String cancerType;
  final bool haveAFamilyCancer;
  final String familyType;
  final String dateOfBirth;

  RegisterRequestModel({
    required this.name,
    required this.username,
    required this.email,
    required this.imageId,
    required this.password,
    required this.phone,
    required this.isMale,
    required this.smoker,
    required this.haveCancer,
    required this.cancerType,
    required this.haveAFamilyCancer,
    required this.familyType,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'imageId': imageId,
      'password': password,
      'phone': phone,
      'isMale': isMale,
      'smoker': smoker,
      'haveCancer': haveCancer,
      'type': cancerType,
      'haveAFamilyCancer': haveAFamilyCancer,
      'familyType': familyType,
      'dateOfBirth': dateOfBirth,
    };
  }
}
