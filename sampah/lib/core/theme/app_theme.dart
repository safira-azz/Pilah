import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

/// FITUR: Tema terang & gelap.
/// Menggabungkan [AppColors] dan [AppFonts] menjadi satu ThemeData.
class AppTheme {
  static ThemeData light() => _build(Brightness.light, AppColors.light);
  static ThemeData dark() => _build(Brightness.dark, AppColors.dark);

  static ThemeData _build(Brightness brightness, AppColors c) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.aksen,
        brightness: brightness,
      ).copyWith(primary: c.aksen),
      scaffoldBackgroundColor: c.bg,
      extensions: [c],
    );

    var text = base.textTheme.apply(bodyColor: c.ink, displayColor: c.ink);
    if (AppFonts.useGoogleFonts) {
      text = text.apply(
        fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
      );
    }

    return base.copyWith(textTheme: text);
  }
}
