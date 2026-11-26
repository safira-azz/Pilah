import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

/// FITUR: Tipografi.
/// Judul memakai Newsreader (serif), isi memakai Hanken Grotesk (sans),
/// sama seperti versi HTML. Set [useGoogleFonts] = false untuk test/offline.
class AppFonts {
  static bool useGoogleFonts = true;

  static TextStyle serif({
    double size = 16,
    FontWeight weight = FontWeight.w500,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    final base = TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
    if (useGoogleFonts) return GoogleFonts.newsreader(textStyle: base);
    return base.copyWith(fontFamily: 'Georgia');
  }

  static TextStyle sans({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? height,
  }) {
    final base = TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
    if (useGoogleFonts) return GoogleFonts.hankenGrotesk(textStyle: base);
    return base;
  }
}
