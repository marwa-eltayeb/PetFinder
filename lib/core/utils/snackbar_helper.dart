import 'package:flutter/material.dart';

class SnackBarHelper {

  static void showSnackBar(
      BuildContext context,
      String message, {
        Color? backgroundColor,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.blue);
  }

  static void showSuccess(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.green);
  }

  static void showError(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.red);
  }

  static void showWarning(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.orange);
  }
}