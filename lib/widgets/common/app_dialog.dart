// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../theme.dart';

class AppDialog {
  AppDialog._();

  // ===========================================================================
  // CONFIRM DIALOG
  // ===========================================================================

  static Future<bool> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool destructive = false,
  }) async {
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dialog',
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (
        dialogContext,
        animation,
        secondaryAnimation,
      ) {
        return SafeArea(
          child: Center(
            child: _ConfirmDialog(
              title: title,
              message: message,
              confirmText: confirmText,
              cancelText: cancelText,
              destructive: destructive,
            ),
          ),
        );
      },
      transitionBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.92,
              end: 1.0,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );

    return result ?? false;
  }

  // ===========================================================================
  // SUCCESS
  // ===========================================================================

  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Done',
    VoidCallback? onPressed,
  }) {
    return _showMessage(
      context,
      icon: Icons.check_rounded,
      iconColor: AppColors.success,
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================

  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return _showMessage(
      context,
      icon: Icons.close_rounded,
      iconColor: Colors.redAccent,
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  // ===========================================================================
  // INFO
  // ===========================================================================

  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return _showMessage(
      context,
      icon: Icons.info_outline_rounded,
      iconColor: AppColors.brand,
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  // ===========================================================================
  // MESSAGE DIALOG
  // ===========================================================================

  static Future<void> _showMessage(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String buttonText,
    VoidCallback? onPressed,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dialog',
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (
        dialogContext,
        animation,
        secondaryAnimation,
      ) {
        return SafeArea(
          child: Center(
            child: _MessageDialog(
              icon: icon,
              iconColor: iconColor,
              title: title,
              message: message,
              buttonText: buttonText,
              onPressed: onPressed,
            ),
          ),
        );
      },
      transitionBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.92,
              end: 1.0,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}

// =============================================================================
// CONFIRM DIALOG
// =============================================================================

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool destructive;

  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.destructive,
  });

  @override
  Widget build(BuildContext context) {
    final confirmColor =
        destructive ? Colors.redAccent : AppColors.brand;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 320,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                22,
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppText.heading.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppText.body.copyWith(
                      color: AppColors.muted,
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 0.7,
              color: AppColors.line,
            ),

            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _DialogAction(
                      label: cancelText,
                      color: AppColors.ink,
                      fontWeight: FontWeight.w500,
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ),

                  Container(
                    width: 0.7,
                    color: AppColors.line,
                  ),

                  Expanded(
                    child: _DialogAction(
                      label: confirmText,
                      color: confirmColor,
                      fontWeight: FontWeight.w700,
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// MESSAGE DIALOG
// =============================================================================

class _MessageDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const _MessageDialog({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 320,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                22,
              ),
              child: Column(
                children: [
                  // Icon
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 27,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppText.heading.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppText.body.copyWith(
                      color: AppColors.muted,
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 0.7,
              color: AppColors.line,
            ),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: _DialogAction(
                label: buttonText,
                color: AppColors.brand,
                fontWeight: FontWeight.w700,
                onTap: () {
                  Navigator.pop(context);
                  onPressed?.call();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// ACTION BUTTON
// =============================================================================

class _DialogAction extends StatelessWidget {
  final String label;
  final Color color;
  final FontWeight fontWeight;
  final VoidCallback onTap;

  const _DialogAction({
    required this.label,
    required this.color,
    required this.fontWeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 48,
          child: Center(
            child: Text(
              label,
              style: AppText.body.copyWith(
                color: color,
                fontSize: 14,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}