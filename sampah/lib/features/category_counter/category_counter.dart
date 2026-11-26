import 'package:material_ui/material_ui.dart';

import '../../controllers/waste_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/widgets/panel.dart';
import '../../data/models/waste_category.dart';

/// FITUR: Penghitung kategori + filter cepat.
///
/// Empat "tong" (Organik, Anorganik, B3, Residu) yang menampilkan jumlah
/// data per kategori. Setiap tong juga tombol filter:
///   - tekan sekali  -> daftar hanya menampilkan kategori itu
///   - tekan lagi    -> filter dimatikan
/// Di layar sempit tampil 2x2, di layar lebar 4 sebaris.
class CategoryCounter extends StatelessWidget {
  const CategoryCounter({
    super.key,
    required this.controller,
    required this.compact,
  });

  final WasteController controller;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final side = BorderSide(color: c.garis);
    final cats = WasteCategory.values;

    Widget cell(int i, {Border? border}) => Expanded(
          child: _Tong(
            kategori: cats[i],
            jumlah: controller.countOf(cats[i]),
            aktif: controller.filter == cats[i],
            border: border,
            onTap: () => controller.toggleFilter(cats[i]),
          ),
        );

    final Widget isi;
    if (compact) {
      isi = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(children: [
              cell(0, border: Border(right: side, bottom: side)),
              cell(1, border: Border(bottom: side)),
            ]),
          ),
          IntrinsicHeight(
            child: Row(children: [
              cell(2, border: Border(right: side)),
              cell(3),
            ]),
          ),
        ],
      );
    } else {
      isi = IntrinsicHeight(
        child: Row(children: [
          for (var i = 0; i < cats.length; i++)
            cell(i, border: i < cats.length - 1 ? Border(right: side) : null),
        ]),
      );
    }

    return Panel(clip: true, child: isi);
  }
}

class _Tong extends StatelessWidget {
  const _Tong({
    required this.kategori,
    required this.jumlah,
    required this.aktif,
    required this.onTap,
    this.border,
  });

  final WasteCategory kategori;
  final int jumlah;
  final bool aktif;
  final VoidCallback onTap;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(border: border),
      child: Material(
        color: aktif ? kategori.color.soft(0.14) : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          hoverColor: kategori.color.soft(0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$jumlah',
                  style: AppFonts.serif(
                    size: 33.6,
                    weight: FontWeight.w400,
                    color: c.ink,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: kategori.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      kategori.label,
                      style: AppFonts.sans(size: 14, color: c.inkSoft),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
