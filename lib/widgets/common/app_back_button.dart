// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool overlay;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.overlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ??
        (overlay
            ? Colors.black.withOpacity(0.30)
            : Colors.white);

    final icon = iconColor ??
        (overlay
            ? Colors.white
            : Colors.black87);

            

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed ??
            () => Navigator.of(context).maybePop(),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: overlay
                ? Border.all(
                    color: Colors.white.withOpacity(0.25),
                  )
                : null,
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: icon,
            size: 18,
          ),
        ),
      ),
    );
  }
}