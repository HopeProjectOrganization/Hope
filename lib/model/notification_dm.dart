class NotificationModel {
  final String title;
  final String message;
  final String? token; // في حالة إرسال token
  final String? topic; // في حالة إرسال topic

  NotificationModel({
    required this.title,
    required this.message,
    this.token,
    this.topic,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'token': token,
      'topic': topic,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      message: json['message'],
      token: json['token'],
      topic: json['topic'],
    );
  }
}
