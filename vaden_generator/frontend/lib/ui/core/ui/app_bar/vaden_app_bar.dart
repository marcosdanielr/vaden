import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../themes/colors.dart';

enum VadenAppBarMode {
  development,
  production,
}

class VadenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VadenAppBarMode mode;
  final double fontSize;
  final double? letterSpacing;
  final double? lineHeight;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;

  const VadenAppBar({
    super.key,
    required this.title,
    this.mode = VadenAppBarMode.development,
    this.fontSize = 24.0,
    this.letterSpacing,
    this.lineHeight,
    this.actions,
    this.centerTitle = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: BoxDecoration(
          gradient: mode == VadenAppBarMode.development
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    VadenColors.gradientStart,
                    VadenColors.gradientEnd,
                  ],
                )
              : null,
          color: mode == VadenAppBarMode.production
              ? VadenColors.productionColor
              : null,
        ),
        child: AppBar(
          title: Text(
            title,
            style: GoogleFonts.anekBangla(
              color: VadenColors.txtSecondary,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: letterSpacing ?? fontSize * 0.04,
              height: lineHeight ?? fontSize / 24.0,
            ),
          ),
          centerTitle: centerTitle,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: actions,
          leading: leading,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
