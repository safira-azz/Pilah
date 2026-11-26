import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/waste_category.dart';
import '../models/waste_item.dart';

/// FITUR: Penyimpanan lokal + data awal.
/// Menggantikan `localStorage` di HTML dengan `shared_preferences`.
/// - Pertama kali dibuka (belum ada data tersimpan): pakai [seedData].
/// - Setelah itu: baca dari penyimpanan, dan simpan ulang tiap ada perubahan.
class WasteRepository {
  static const _key = 'pilah_data_v1';

  static const seedData = <WasteItem>[
    WasteItem(
      id: 1,
      nama: 'Kulit pisang',
      kategori: WasteCategory.organik,
      tempat: 'Tong hijau / komposter',
      catatan: 'Bisa dijadikan kompos dalam 2-3 minggu.',
    ),
    WasteItem(
      id: 2,
      nama: 'Botol plastik PET',
      kategori: WasteCategory.anorganik,
      tempat: 'Bank sampah',
      catatan: 'Bilas, lepas tutup dan labelnya, lalu injak biar pipih.',
    ),
    WasteItem(
      id: 3,
      nama: 'Baterai bekas',
      kategori: WasteCategory.b3,
      tempat: 'Titik drop-off limbah B3',
      catatan: 'Jangan dibuang ke tong biasa, simpan di wadah tertutup.',
    ),
    WasteItem(
      id: 4,
      nama: 'Popok sekali pakai',
      kategori: WasteCategory.residu,
      tempat: 'Tong abu-abu',
      catatan: 'Buang isinya ke toilet dulu, lalu bungkus rapat.',
    ),
  ];

  Future<List<WasteItem>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw != null) {
        final list = jsonDecode(raw) as List<dynamic>;
        return list
            .map((e) => WasteItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Data rusak / storage tidak bisa dibaca: lanjut pakai data awal.
    }
    return List.of(seedData);
  }

  Future<void> save(List<WasteItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _key,
        jsonEncode(items.map((e) => e.toJson()).toList()),
      );
    } catch (_) {
      // Gagal menyimpan tidak boleh membuat aplikasi crash.
    }
  }
}
