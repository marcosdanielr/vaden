import 'package:flutter/material.dart';

import '../../themes/colors.dart';

enum PrimaryButtonStyle { filled, outlined }

class VadenButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double width;
  final IconData? icon;
  final double? borderRadius;
  final bool? socialButton;
  final String? socialIconPath;
  final bool? enabledControl;
  final bool darkMode;
  final PrimaryButtonStyle style;
  final TextStyle? titleTextStyle;

  const VadenButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor = VadenColors.primaryColor,
    this.foregroundColor = Colors.white,
    this.height = 48,
    this.width = double.infinity,
    this.icon = Icons.arrow_forward_rounded,
    this.borderRadius = 40,
    this.socialButton = false,
    this.socialIconPath,
    this.enabledControl,
    this.darkMode = false,
    this.style = PrimaryButtonStyle.filled,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = enabledControl == false;
    final disabledColor = VadenColors.disabledColor;

    final isOutlined = style == PrimaryButtonStyle.outlined;
    final effectiveBackgroundColor = isOutlined ? Colors.transparent : backgroundColor;
    final effectiveForegroundColor =
        titleTextStyle?.color ?? (isOutlined ? VadenColors.primaryColor : foregroundColor);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        fixedSize: Size(width, height),
        backgroundColor: isDisabled ? disabledColor : effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
        textStyle: titleTextStyle ?? theme.textTheme.bodyLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          side: isOutlined
              ? BorderSide(
                  color: isDisabled ? disabledColor : VadenColors.primaryColor,
                  width: 1,
                )
              : BorderSide.none,
        ),
        elevation: 0,
      ),
      onPressed: isDisabled ? null : onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (socialButton == true && socialIconPath != null)
            SvgPicture.asset(
              socialIconPath ?? '',
              package: AppImage.packageName,
            )
          else
            const SizedBox.shrink(),
          const Spacer(),
          Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDisabled ? Colors.white : effectiveForegroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (icon != null)
            Icon(
              icon,
              size: 24,
              color: isDisabled ? Colors.white : effectiveForegroundColor,
            ),
        ],
      ),
    );
  }
}
