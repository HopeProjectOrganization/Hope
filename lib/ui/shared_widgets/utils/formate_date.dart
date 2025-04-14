import 'package:intl/intl.dart';

String formatDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return "Unknown Date";
  try {
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat("dd MMM yyyy").format(dateTime);
  } catch (e) {
    return "Invalid Date";
  }
}
