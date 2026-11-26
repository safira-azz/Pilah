import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

/// FITUR: Notifikasi kecil (toast) di bawah layar, hilang sendiri setelah 2 detik.
/// Dipakai setelah menambah, mengubah, atau menghapus data.
void showToast(BuildContext context, String message) {
  final c = context.colors;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: AppFonts.sans(size: 14.4, color: c.bg),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.ink,
        elevation: 0,
        width: 280,
        shape: const StadiumBorder(),
      ),
    );
}
