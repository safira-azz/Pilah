import 'package:material_ui/material_ui.dart';

import '../../controllers/waste_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/widgets/pill_button.dart';

/// FITUR: Pencarian.
///
/// Kolom cari menyaring daftar secara langsung saat mengetik, mencocokkan
/// nama, tempat buang, dan catatan (tidak peduli huruf besar/kecil).
/// Tombol "Semua" muncul saat filter kategori aktif, dan menghapus
/// filter sekaligus isi kolom cari.
class SearchSection extends StatefulWidget {
  const SearchSection({super.key, required this.controller});

  final WasteController controller;

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final _text = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_sync);
  }

  /// Kalau query dikosongkan dari luar (tombol "Semua"), kosongkan juga kolomnya.
  void _sync() {
    if (widget.controller.query.isEmpty && _text.text.isNotEmpty) {
      _text.clear();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_sync);
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    OutlineInputBorder border(Color color, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: color, width: w),
        );

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _text,
            onChanged: widget.controller.setQuery,
            textInputAction: TextInputAction.search,
            style: AppFonts.sans(size: 16, color: c.ink),
            decoration: InputDecoration(
              hintText: 'Cari nama, tempat, atau catatan',
              hintStyle: AppFonts.sans(size: 16, color: c.inkSoft.soft(0.55)),
              filled: true,
              fillColor: c.panel,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              enabledBorder: border(c.garis),
              focusedBorder: border(c.aksen),
            ),
          ),
        ),
        if (widget.controller.filter != null) ...[
          const SizedBox(width: 10),
          PillButton(label: 'Semua', onPressed: widget.controller.resetFilter),
        ],
      ],
    );
  }
}
