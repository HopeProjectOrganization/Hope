import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hope/Api/notification/notification_service.dart';
import 'package:hope/model/notification_dm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final hasLogged = await hasUserLoggedMealsToday();
    if (!hasLogged) {
      final token = await FirebaseMessaging.instance.getToken();
      final notification = NotificationModel(
        token: token,
        title: "تذكير الوجبات 🍽️",
        body: "لم تسجل وجباتك اليوم. سجلها الآن للحفاظ على صحتك!",
      );
      await NotificationApiService().sendToToken(notification);
    }
    return Future.value(true);
  });
}

Future<bool> hasUserLoggedMealsToday() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now();
  final key = "${today.year}-${today.month}-${today.day}";
  return prefs.getBool("mealAdded_$key") ?? false;
}
