import 'package:chatgpt/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
      duration: duration,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber_rounded,
      duration: duration,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColor.primaryColor,
      icon: Icons.info_outline,
      duration: duration,
    );
  }

  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 2),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      action: SnackBarAction(
        label: 'DISMISS',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
