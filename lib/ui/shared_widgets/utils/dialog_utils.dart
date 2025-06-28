import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

enum MessageType { success, error, warning, info }

showLoading(BuildContext context,) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const CupertinoAlertDialog(
          content: Row(
            children: [
              Text(
                "Loading...",
                style: TextStyle(
                    color: AppColors.Teal,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              CircularProgressIndicator(
                color: AppColors.Teal,
              ),
            ],
          ),
        );
      });
}

hideLoading(BuildContext context) {
  Navigator.pop(context);
}

showMessage(BuildContext context,
    String message, {
      String? title,
      String? posButtonTitle,
      Function? posButtonClick,
      String? negativeButtonTitle,
      Function? negativeButtonClick,
      MessageType type = MessageType.info, // ← ضف هذا السطر

    }) {
  void showMessage(BuildContext context,
      String message, {
        String? title,
        String? posButtonTitle,
        Function? posButtonClick,
        String? negativeButtonTitle,
        Function? negativeButtonClick,
        MessageType type = MessageType.info, // ← ضف هذا السطر
      }) {
    // ممكن تغيّر لون أو تنسيق الرسالة بناءً على `type` إذا حبيت
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.Teal,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(posButtonTitle ?? 'OK'),
            )
          ],
        );
      },
    );
  }
}