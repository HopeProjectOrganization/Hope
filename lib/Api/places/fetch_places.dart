import 'package:hope/model/places_dm.dart';
import 'package:http/http.dart' as http;

Future<PlaceModel?> fetchPlaceById(String id) async {
  final url = Uri.parse('http://192.168.1.45:8081/Places/id/$id');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("Response: ${response.body}");
    } else {
      print("Failed to load place. Status: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }
}
