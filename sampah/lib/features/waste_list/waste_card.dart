import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/widgets/panel.dart';
import '../../core/widgets/pill_button.dart';
import '../../data/models/waste_category.dart';
import '../../data/models/waste_item.dart';

/// FITUR: Kartu satu data sampah (+ tombol Ubah & Hapus).
///
/// Isi kartu: nama, lencana kategori berwarna, tempat buang, dan catatan
/// (disembunyikan kalau kosong).
///
/// Tombol Hapus memakai konfirmasi dua langkah supaya tidak terhapus tak
/// sengaja: tekan pertama berubah merah "Yakin hapus?", tekan kedua baru
/// menghapus. Tanpa ditekan lagi, tombol kembali normal setelah 3 detik.
class WasteCard extends StatelessWidget {
  const WasteCard({
    super.key,
    required this.item,
    required this.menungguHapus,
    required this.onEdit,
    required this.onDelete,
  });

  final WasteItem item;
  final bool menungguHapus;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final warna = item.kategori.color;
    final bahaya = WasteCategory.b3.color;

    return Panel(
      radius: 14,
      withShadow: false,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 6,
            children: [
              Text(
                item.nama,
                style: AppFonts.serif(size: 21.6, color: c.ink, height: 1.15),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: warna.soft(0.13),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.kategori.label,
                  style: AppFonts.sans(
                    size: 12.8,
                    weight: FontWeight.w500,
                    color: warna,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: 'Buang ke: ',
                style: TextStyle(color: c.ink, fontWeight: FontWeight.w500),
              ),
              TextSpan(text: item.tempat),
            ]),
            style: AppFonts.sans(size: 15.2, color: c.inkSoft, height: 1.6),
          ),
          if (item.catatan.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              item.catatan,
              style: AppFonts.sans(size: 15.2, color: c.inkSoft, height: 1.6),
            ),
          ],
          const SizedBox(height: 16),
          Container(height: 1, color: c.garis),
          const SizedBox(height: 14),
          Row(
            children: [
              PillButton(label: 'Ubah', compact: true, onPressed: onEdit),
              const SizedBox(width: 8),
              PillButton(
                label: menungguHapus ? 'Yakin hapus?' : 'Hapus',
                compact: true,
                background: menungguHapus ? bahaya : null,
                foreground: menungguHapus ? Colors.white : null,
                borderColor: menungguHapus ? bahaya : null,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
