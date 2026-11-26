import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/waste_category.dart';
import '../data/models/waste_item.dart';
import '../data/repositories/waste_repository.dart';

/// Pusat logika dan state aplikasi (pengganti variabel global di <script> HTML).
/// Semua fitur membaca/mengubah state lewat class ini:
///   - daftar data              -> fitur Daftar & CRUD
///   - [query]                  -> fitur Pencarian
///   - [filter]                 -> fitur Filter kategori
///   - [editing]                -> mode Ubah di form
///   - [pendingDeleteId]        -> konfirmasi hapus dua kali tekan
class WasteController extends ChangeNotifier {
  WasteController(this._repo);

  final WasteRepository _repo;

  List<WasteItem> _all = [];
  String _query = '';
  WasteCategory? _filter;
  int? _editingId;
  int? _pendingDeleteId;
  Timer? _deleteTimer;

  // ---------- state yang dibaca UI ----------
  List<WasteItem> get all => List.unmodifiable(_all);
  String get query => _query;
  WasteCategory? get filter => _filter;
  int? get pendingDeleteId => _pendingDeleteId;
  WasteItem? get editing => _editingId == null ? null : _find(_editingId!);

  /// Data setelah dikenai filter kategori + kata pencarian.
  List<WasteItem> get filtered {
    final kata = _query.trim().toLowerCase();
    return _all.where((s) {
      final cocokKat = _filter == null || s.kategori == _filter;
      final teks = '${s.nama} ${s.tempat} ${s.catatan}'.toLowerCase();
      return cocokKat && teks.contains(kata);
    }).toList();
  }

  int countOf(WasteCategory kategori) =>
      _all.where((s) => s.kategori == kategori).length;

  WasteItem? _find(int id) {
    for (final s in _all) {
      if (s.id == id) return s;
    }
    return null;
  }

  // ---------- muat data ----------
  Future<void> load() async {
    _all = await _repo.load();
    notifyListeners();
  }

  // ---------- pencarian & filter ----------
  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  /// Menekan kategori yang sama dua kali = mematikan filter.
  void toggleFilter(WasteCategory kategori) {
    _filter = _filter == kategori ? null : kategori;
    notifyListeners();
  }

  /// Tombol "Semua": hapus filter sekaligus kata pencarian.
  void resetFilter() {
    _filter = null;
    _query = '';
    notifyListeners();
  }

  // ---------- create + update ----------
  /// Menyimpan data dari form. Jika sedang mode ubah -> update, kalau tidak -> tambah.
  /// Mengembalikan pesan untuk toast, atau null jika input tidak valid.
  Future<String?> save({
    required String nama,
    required WasteCategory kategori,
    required String tempat,
    required String catatan,
  }) async {
    final n = nama.trim();
    final t = tempat.trim();
    if (n.isEmpty || t.isEmpty) return null;

    final String pesan;
    if (_editingId != null) {
      _all = _all
          .map((s) => s.id == _editingId
              ? s.copyWith(
                  nama: n,
                  kategori: kategori,
                  tempat: t,
                  catatan: catatan.trim(),
                )
              : s)
          .toList();
      pesan = 'Perubahan disimpan';
    } else {
      final idBaru = _all.isEmpty
          ? 1
          : _all.map((s) => s.id).reduce((a, b) => a > b ? a : b) + 1;
      _all = [
        WasteItem(
          id: idBaru,
          nama: n,
          kategori: kategori,
          tempat: t,
          catatan: catatan.trim(),
        ),
        ..._all,
      ];
      pesan = 'Sampah ditambahkan';
    }

    _editingId = null;
    notifyListeners();
    await _repo.save(_all);
    return pesan;
  }

  void startEdit(int id) {
    if (_find(id) == null) return;
    _editingId = id;
    notifyListeners();
  }

  void cancelEdit() {
    _editingId = null;
    notifyListeners();
  }

  // ---------- delete ----------
  /// Tekan pertama: minta konfirmasi (otomatis batal setelah 3 detik) -> false.
  /// Tekan kedua pada item yang sama: benar-benar dihapus -> true.
  Future<bool> requestDelete(int id) async {
    if (_pendingDeleteId != id) {
      _pendingDeleteId = id;
      _deleteTimer?.cancel();
      _deleteTimer = Timer(const Duration(seconds: 3), () {
        if (_pendingDeleteId == id) {
          _pendingDeleteId = null;
          notifyListeners();
        }
      });
      notifyListeners();
      return false;
    }

    _deleteTimer?.cancel();
    _all = _all.where((s) => s.id != id).toList();
    _pendingDeleteId = null;
    if (_editingId == id) _editingId = null;
    notifyListeners();
    await _repo.save(_all);
    return true;
  }

  @override
  void dispose() {
    _deleteTimer?.cancel();
    super.dispose();
  }
}
