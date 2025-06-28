import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> subscribeUserToCancerTopic(String cancerType) async {
  final topic = cancerType.toLowerCase().replaceAll(' ', '-');
  await FirebaseMessaging.instance.subscribeToTopic(topic);
}
