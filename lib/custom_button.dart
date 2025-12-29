import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.text,
    this.textColor,
    this.backgroundColor,
    this.icon,

    this.containerWidth,
    this.containerPadding,
    required this.onPressed,
    this.containerHeight,
    this.borderRadius,
    this.boxBorder,
  });

  final String? text;
  final Color? textColor;
  final Widget? icon;
  final Color? backgroundColor;
  final double? containerWidth, containerHeight;
  final EdgeInsetsGeometry? containerPadding;
  final VoidCallback onPressed;
  final Radius? borderRadius;
  final BoxBorder? boxBorder;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(6),
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        splashColor: Colors.white.withValues(alpha: 0.5),
        onTap: onPressed,
        child: Container(
          width: containerWidth,
          height: containerHeight,
          padding:
              containerPadding ??
              EdgeInsets.symmetric(vertical: (17), horizontal: (16)),
          decoration: BoxDecoration(
            borderRadius: borderRadius != null
                ? BorderRadius.all(borderRadius!)
                : BorderRadius.circular(4),

            border: boxBorder,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                const SizedBox(),
                SizedBox(height: (23), width: (23), child: icon!),
              ],
              SizedBox(width: (15)),
              CustomText(
                text: text ?? '',
                fontSize: (16),
                fontWeight: FontWeight.w600,
                color: textColor ?? Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
