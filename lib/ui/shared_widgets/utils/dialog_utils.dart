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

void showMessage(
  BuildContext context,
  String message, {
  String? title,
  String? posButtonTitle,
  Function? posButtonClick,
  String? negativeButtonTitle,
  Function? negativeButtonClick,
  MessageType type = MessageType.info,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: title != null
            ? Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.Teal,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.Teal,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              if (posButtonClick != null) posButtonClick();
            },
            isDefaultAction: true,
            child: Text(
              posButtonTitle ?? 'OK',
              style: const TextStyle(color: AppColors.Teal),
            ),
          ),
          if (negativeButtonTitle != null)
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                if (negativeButtonClick != null) negativeButtonClick();
              },
              isDestructiveAction: true,
              child: Text(
                negativeButtonTitle,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      );
    },
  );
}