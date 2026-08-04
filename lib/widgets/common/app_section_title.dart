import 'package:flutter/material.dart';
import '../../theme.dart';

class AppSectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? leading;

  const AppSectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 7),
        ],

        Expanded(
          child: Text(
            title,
            style: AppText.heading.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionText!,
              style: AppText.label.copyWith(
                color: AppColors.brand,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}