// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../theme.dart';

class AppSnackBar {
  AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    IconData icon = Icons.check_circle_rounded,
    Color? iconColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final snackBarTheme = theme.snackBarTheme;
    final backgroundColor = snackBarTheme.backgroundColor ?? colors.dark;
    final textStyle = snackBarTheme.contentTextStyle?.copyWith(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ) ??
        AppText.body.copyWith(
          color: Colors.white,
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        );
    final iconBackgroundOpacity = theme.brightness == Brightness.dark ? 0.18 : 0.12;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: snackBarTheme.behavior ?? SnackBarBehavior.floating,
          duration: duration,
          backgroundColor: backgroundColor,
          elevation: snackBarTheme.elevation ?? 0,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          shape: snackBarTheme.shape ?? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.success)
                      .withOpacity(iconBackgroundOpacity),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.success,
                  size: 19,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      );
  }

  static void success(
    BuildContext context,
    String message,
  ) {
    show(
      context,
      message: message,
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.success,
    );
  }

  static void error(
    BuildContext context,
    String message,
  ) {
    show(
      context,
      message: message,
      icon: Icons.error_rounded,
      iconColor: Colors.redAccent,
    );
  }

  static void info(
    BuildContext context,
    String message,
  ) {
    show(
      context,
      message: message,
      icon: Icons.info_rounded,
      iconColor: Colors.lightBlueAccent,
    );
  }
}