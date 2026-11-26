import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

/// Tombol berbentuk pil (kapsul). `filled` = tombol utama berwarna aksen.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = false,
    this.compact = false,
    this.background,
    this.foreground,
    this.borderColor,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;
  final bool compact;
  final Color? background;
  final Color? foreground;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: background ?? (filled ? c.aksen : Colors.transparent),
        foregroundColor: foreground ?? (filled ? c.aksenTeks : c.ink),
        shape: StadiumBorder(
          side: BorderSide(color: borderColor ?? (filled ? c.aksen : c.garis)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 16 : 20,
          vertical: compact ? 5 : 10,
        ),
        minimumSize: Size.zero,
        textStyle: AppFonts.sans(
          size: compact ? 13.6 : 15.2,
          weight: FontWeight.w500,
        ),
      ),
      child: Text(label),
    );
  }
}
