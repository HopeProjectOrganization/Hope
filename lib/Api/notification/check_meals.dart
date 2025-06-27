import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hope/Api/notification/notification_service.dart';
import 'package:hope/model/notification_dm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      print("✅ WorkManager task running: $task");

      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();

      final hasLogged = await hasUserLoggedMealsToday();
      print("🧾 Has logged meals today? $hasLogged");

      if (!hasLogged) {
        final token = await FirebaseMessaging.instance.getToken();
        print("📲 Got FCM token: $token");

        if (token != null) {
          final notification = NotificationModel(
            token: token,
            title: "Meal Reminder 🍽️",
            body:
                "You haven't logged your meals today. Log them now to stay healthy!",
          );

          await NotificationApiService().sendToToken(notification);
          print("✅ Notification sent successfully to token");
        } else {
          print("⚠️ Token was null, could not send notification.");
        }
      }

      return Future.value(true); // ✅ نجح
    } catch (e, stack) {
      print("❌ Error in WorkManager task: $e");
      print("🪵 StackTrace: $stack");
      return Future.value(false); // ❌ فشل
    }
  });
}

Future<bool> hasUserLoggedMealsToday() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now();
  final key = "${today.year}-${today.month}-${today.day}";
  final result = prefs.getBool("mealAdded_$key") ?? false;
  print("📆 Checked key $key → $result");
  return result;
}
