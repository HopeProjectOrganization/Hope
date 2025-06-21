import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

showLoading(
  BuildContext context,
) {
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

showMessage(
  BuildContext context,
  String message, {
  String? title,
  String? posButtonTitle,
  Function? posButtonClick,
  String? negativeButtonTitle,
  Function? negativeButtonClick,
}) {
  showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content: Text(
            message,
            style: TextStyle(
                color: AppColors.Teal,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            if (posButtonTitle != null)
              TextButton(
                  style: FilledButton.styleFrom(
                    textStyle: TextStyle(fontSize: 16, color: AppColors.Teal),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                    if (posButtonClick != null) posButtonClick();
                  },
                  child: Text(posButtonTitle)),
            if (negativeButtonTitle != null)
              TextButton(
                  style: FilledButton.styleFrom(
                    textStyle: TextStyle(fontSize: 16, color: AppColors.Teal),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {
                    hideLoading(context);
                    if (negativeButtonClick != null) negativeButtonClick();
                  },
                  child: Text(negativeButtonTitle))
          ],
        );
      });
}
