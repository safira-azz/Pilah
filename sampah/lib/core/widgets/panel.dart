import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';

/// Kotak putih berborder dan bersudut bulat yang dipakai di banyak tempat
/// (form, penghitung kategori, kartu sampah).
class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 16,
    this.withShadow = true,
    this.clip = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool withShadow;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: padding,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        color: c.panel,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: c.garis),
        boxShadow: withShadow ? c.shadow : null,
      ),
      child: child,
    );
  }
}
