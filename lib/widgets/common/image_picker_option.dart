// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImagePickerOption extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const ImagePickerOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  State<ImagePickerOption> createState() => _ImagePickerOptionState();
}

class _ImagePickerOptionState extends State<ImagePickerOption> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _setPressed(true),
          onTapCancel: () => _setPressed(false),
          onTapUp: (_) => _setPressed(false),
          onTap: widget.onTap,
          child: Container(
            width: double.infinity,
            color: _pressed
                ? CupertinoColors.systemGrey5
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 13,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: CupertinoColors.label,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  widget.icon,
                  color: CupertinoColors.label,
                  size: 19,
                ),
              ],
            ),
          ),
        ),

        if (widget.showDivider)
          Container(
            height: 0.5,
            color: CupertinoColors.separator,
          ),
      ],
    );
  }
}

// =============================================================================
// FLOATING MENU CONTAINER
// Frosted rounded card that wraps a set of ImagePickerOption rows
// =============================================================================

class ImagePickerMenu extends StatelessWidget {
  final List<Widget> children;
  final double width;

  const ImagePickerMenu({
    super.key,
    required this.children,
    this.width = 260,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: Colors.white.withOpacity(0.78),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}