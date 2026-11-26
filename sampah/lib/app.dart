import 'package:material_ui/material_ui.dart';

import 'package:sampah/controllers/waste_controller.dart';
import 'package:sampah/core/theme/app_theme.dart';
import 'package:sampah/features/home/home_page.dart';

/// Root widget: mengatur tema terang/gelap (mengikuti pengaturan sistem,
/// sama seperti `prefers-color-scheme` di versi HTML) dan halaman utama.
class PilahApp extends StatelessWidget {
  const PilahApp({super.key, required this.controller});

  final WasteController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilah – Kamus Klasifikasi Sampah',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: HomePage(controller: controller),
    );
  }
}
