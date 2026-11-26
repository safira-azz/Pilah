import 'package:material_ui/material_ui.dart';

/// FITUR: Palet warna (setara variabel CSS `:root` di HTML).
/// Ada dua set: terang dan gelap. Warna diakses lewat `context.colors`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.panel,
    required this.ink,
    required this.inkSoft,
    required this.garis,
    required this.aksen,
    required this.aksenTeks,
    required this.emas,
    required this.bayang,
  });

  final Color bg;
  final Color panel;
  final Color ink;
  final Color inkSoft;
  final Color garis;
  final Color aksen;
  final Color aksenTeks;
  final Color emas;
  final Color bayang;

  static const light = AppColors(
    bg: Color(0xFFF4F5F1),
    panel: Color(0xFFFFFFFF),
    ink: Color(0xFF16241D),
    inkSoft: Color(0xFF66756C),
    garis: Color(0xFFDFE3DC),
    aksen: Color(0xFF2F5D46),
    aksenTeks: Color(0xFFFFFFFF),
    emas: Color(0xFFA8873F),
    bayang: Color(0xFF16241D),
  );

  static const dark = AppColors(
    bg: Color(0xFF0F1713),
    panel: Color(0xFF16211B),
    ink: Color(0xFFE8EDE6),
    inkSoft: Color(0xFF94A39A),
    garis: Color(0xFF263329),
    aksen: Color(0xFF7FB394),
    aksenTeks: Color(0xFF0F1713),
    emas: Color(0xFFD2B36A),
    bayang: Color(0xFF000000),
  );

  /// Bayangan lembut untuk kartu/panel.
  List<BoxShadow> get shadow => [
        BoxShadow(
          color: bayang.withAlpha(13),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: bayang.withAlpha(36),
          blurRadius: 32,
          spreadRadius: -12,
          offset: const Offset(0, 12),
        ),
      ];

  @override
  AppColors copyWith({Color? bg}) => AppColors(
        bg: bg ?? this.bg,
        panel: panel,
        ink: ink,
        inkSoft: inkSoft,
        garis: garis,
        aksen: aksen,
        aksenTeks: aksenTeks,
        emas: emas,
        bayang: bayang,
      );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      bg: l(bg, other.bg),
      panel: l(panel, other.panel),
      ink: l(ink, other.ink),
      inkSoft: l(inkSoft, other.inkSoft),
      garis: l(garis, other.garis),
      aksen: l(aksen, other.aksen),
      aksenTeks: l(aksenTeks, other.aksenTeks),
      emas: l(emas, other.emas),
      bayang: l(bayang, other.bayang),
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

extension SoftColor on Color {
  /// Versi transparan sebuah warna (setara `color-mix(... 13%, transparent)`).
  Color soft(double opacity) => withAlpha((opacity * 255).round());
}
