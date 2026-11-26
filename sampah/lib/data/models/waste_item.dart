import 'waste_category.dart';

/// Satu entri di kamus: nama sampah, kategorinya, tempat buang, dan catatan.
class WasteItem {
  const WasteItem({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.tempat,
    this.catatan = '',
  });

  final int id;
  final String nama;
  final WasteCategory kategori;
  final String tempat;
  final String catatan;

  WasteItem copyWith({
    String? nama,
    WasteCategory? kategori,
    String? tempat,
    String? catatan,
  }) =>
      WasteItem(
        id: id,
        nama: nama ?? this.nama,
        kategori: kategori ?? this.kategori,
        tempat: tempat ?? this.tempat,
        catatan: catatan ?? this.catatan,
      );

  /// Format JSON sama dengan versi HTML (kategori disimpan sebagai teks).
  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'kategori': kategori.label,
        'tempat': tempat,
        'catatan': catatan,
      };

  factory WasteItem.fromJson(Map<String, dynamic> json) => WasteItem(
        id: (json['id'] as num).toInt(),
        nama: json['nama'] as String? ?? '',
        kategori: WasteCategory.fromLabel(json['kategori'] as String? ?? ''),
        tempat: json['tempat'] as String? ?? '',
        catatan: json['catatan'] as String? ?? '',
      );
}
