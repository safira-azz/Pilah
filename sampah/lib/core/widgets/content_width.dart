import 'package:material_ui/material_ui.dart';

/// Membatasi lebar konten maksimal 1060px dan menaruhnya di tengah
/// (setara `max-width: 1060px; margin: 0 auto` di HTML).
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  static const double maxWidth = 1060;

  /// Di bawah lebar ini tata letak berubah jadi satu kolom (mode ponsel).
  static const double breakpoint = 820;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
  }
}
