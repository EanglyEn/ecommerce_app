import 'package:flutter/material.dart';
import '../../theme.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // =============================================================
            // ICON
            // =============================================================
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.brand.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.brand,
                size: 34,
              ),
            ),

            const SizedBox(height: 18),

            // =============================================================
            // TITLE
            // =============================================================
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppText.heading.copyWith(
                fontSize: 19,
                color: colors.ink,
              ),
            ),

            // =============================================================
            // MESSAGE
            // =============================================================
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(
                  color: colors.muted,
                  fontSize: 13,
                ),
              ),
            ],

            // =============================================================
            // BUTTON
            // =============================================================
            if (buttonText != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  foregroundColor: Colors.white,
                ),
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}