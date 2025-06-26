import 'package:jwt_decoder/jwt_decoder.dart';

Future<int?> getUserIdFromToken(String token) async {
  try {
    final decoded = JwtDecoder.decode(token);
    print("🧩 Decoded Token: $decoded");

    final userId = decoded['sub']; // أو 'id' أو حسب ما مسميه في السيرفر

    if (userId is String) {
      return int.tryParse(userId);
    } else if (userId is int) {
      return userId;
    } else {
      return null;
    }
  } catch (e) {
    print("❌ Error decoding token: $e");
    return null;
  }
}
