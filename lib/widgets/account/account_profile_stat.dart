import 'package:flutter/material.dart';
import '../../theme.dart';

class AccountProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const AccountProfileStat({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppText.heading.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: AppText.label.copyWith(
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }
}