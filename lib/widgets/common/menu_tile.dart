import 'package:flutter/material.dart';
import '../../theme.dart';

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const MenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppColors.line.withOpacity(0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 5,
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.softBrand,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: AppColors.brand,
                  size: 21,
                ),
              ),
              title: Text(
                label,
                style: AppText.body.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                ),
              ),
              trailing: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: AppColors.bg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.muted,
                  size: 19,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}