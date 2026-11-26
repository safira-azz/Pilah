import 'package:material_ui/material_ui.dart';

import '../../controllers/waste_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/widgets/dashed_border_box.dart';
import '../../core/widgets/toast.dart';
import 'waste_card.dart';

/// FITUR: Daftar sampah (Read) + keterangan jumlah + tampilan kosong.
///
/// Menampilkan data yang sudah lolos filter kategori dan pencarian, dengan
/// keterangan "X dari Y sampah ditampilkan" di atasnya.
/// Kalau tidak ada yang tampil, muncul kotak putus-putus dengan pesan:
///   - belum ada data sama sekali -> ajakan mengisi form
///   - data ada tapi tidak cocok  -> saran ganti kata / kategori
/// Aksi Ubah dan Hapus pada kartu diteruskan ke [WasteController].
class WasteList extends StatelessWidget {
  const WasteList({super.key, required this.controller});

  final WasteController controller;

  Future<void> _hapus(BuildContext context, int id) async {
    final terhapus = await controller.requestDelete(id);
    if (terhapus && context.mounted) showToast(context, 'Sampah dihapus');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hasil = controller.filtered;
    final total = controller.all.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 14, 4, 14),
          child: Text(
            '${hasil.length} dari $total sampah ditampilkan',
            style: AppFonts.sans(size: 14.1, color: c.inkSoft),
          ),
        ),
        if (hasil.isEmpty)
          SizedBox(
            width: double.infinity,
            child: DashedBorderBox(
              color: c.inkSoft,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 44),
              child: Text(
                total == 0
                    ? 'Belum ada data. Isi formulir untuk menambah sampah pertama.'
                    : 'Tidak ada yang cocok. Coba kata lain atau pilih semua kategori.',
                textAlign: TextAlign.center,
                style: AppFonts.sans(size: 16, color: c.inkSoft, height: 1.6),
              ),
            ),
          )
        else
          for (var i = 0; i < hasil.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            WasteCard(
              key: ValueKey(hasil[i].id),
              item: hasil[i],
              menungguHapus: controller.pendingDeleteId == hasil[i].id,
              onEdit: () => controller.startEdit(hasil[i].id),
              onDelete: () => _hapus(context, hasil[i].id),
            ),
          ],
      ],
    );
  }
}
