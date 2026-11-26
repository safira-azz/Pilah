import 'package:material_ui/material_ui.dart';

/// FITUR: Kategori sampah.
/// Empat kategori tetap beserta label dan warna identitasnya.
/// Warna ini dipakai di lencana kartu, penghitung, dan tombol hapus (B3).
enum WasteCategory {
  organik('Organik', 'Organik', Color(0xFF55805F)),
  anorganik('Anorganik', 'Anorganik', Color(0xFFC19A3B)),
  b3('B3', 'B3 (berbahaya)', Color(0xFFA94A3E)),
  residu('Residu', 'Residu', Color(0xFF7A8794));

  const WasteCategory(this.label, this.formLabel, this.color);

  /// Nama singkat (di lencana & penghitung, juga disimpan ke penyimpanan).
  final String label;

  /// Nama lengkap di pilihan dropdown form.
  final String formLabel;

  final Color color;

  static WasteCategory fromLabel(String label) => WasteCategory.values
      .firstWhere((c) => c.label == label, orElse: () => WasteCategory.residu);
}
