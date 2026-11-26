import 'package:material_ui/material_ui.dart';

import '../../controllers/waste_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/widgets/panel.dart';
import '../../core/widgets/pill_button.dart';
import '../../core/widgets/toast.dart';
import '../../data/models/waste_category.dart';

/// FITUR: Form tambah & ubah sampah (Create + Update).
///
/// Satu form dipakai untuk dua mode:
///   - Mode TAMBAH (default): judul "Tambah sampah", tombol "Simpan".
///   - Mode UBAH: aktif saat tombol "Ubah" di kartu ditekan. Form terisi data
///     lama, judul jadi "Ubah sampah", tombol jadi "Simpan perubahan", dan
///     muncul tombol "Batal". Layar otomatis menggulir ke form.
/// Nama dan tempat buang wajib diisi; kategori dipilih dari dropdown;
/// catatan boleh kosong.
class WasteForm extends StatefulWidget {
  const WasteForm({super.key, required this.controller});

  final WasteController controller;

  @override
  State<WasteForm> createState() => _WasteFormState();
}

class _WasteFormState extends State<WasteForm> {
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _tempat = TextEditingController();
  final _catatan = TextEditingController();
  final _namaFocus = FocusNode();

  WasteCategory _kategori = WasteCategory.organik;
  int? _loadedId; // id item yang sedang dimuat ke form (null = mode tambah)

  bool get _sedangEdit => _loadedId != null;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_sync);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_sync);
    _nama.dispose();
    _tempat.dispose();
    _catatan.dispose();
    _namaFocus.dispose();
    super.dispose();
  }

  /// Menyelaraskan form dengan state controller (masuk/keluar mode ubah).
  void _sync() {
    final e = widget.controller.editing;
    if (e?.id == _loadedId) return;

    if (e != null) {
      setState(() {
        _loadedId = e.id;
        _nama.text = e.nama;
        _tempat.text = e.tempat;
        _catatan.text = e.catatan;
        _kategori = e.kategori;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Scrollable.ensureVisible(
          context,
          alignment: 0.2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        _namaFocus.requestFocus();
      });
    } else {
      setState(_clear);
    }
  }

  void _clear() {
    _loadedId = null;
    _kategori = WasteCategory.organik;
    _nama.clear();
    _tempat.clear();
    _catatan.clear();
    _formKey.currentState?.reset();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final pesan = await widget.controller.save(
      nama: _nama.text,
      kategori: _kategori,
      tempat: _tempat.text,
      catatan: _catatan.text,
    );
    if (!mounted) return;

    setState(_clear);
    if (pesan != null) showToast(context, pesan);
  }

  InputDecoration _deco(AppColors c, {String? hint}) {
    UnderlineInputBorder line(Color color, [double w = 1]) =>
        UnderlineInputBorder(borderSide: BorderSide(color: color, width: w));
    return InputDecoration(
      hintText: hint,
      hintStyle: AppFonts.sans(size: 16, color: c.inkSoft.soft(0.55)),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      enabledBorder: line(c.garis),
      focusedBorder: line(c.aksen, 2),
      errorBorder: line(WasteCategory.b3.color),
      focusedErrorBorder: line(WasteCategory.b3.color, 2),
    );
  }

  Widget _label(AppColors c, String text) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 6),
        child: Text(
          text,
          style: AppFonts.sans(
            size: 14.1,
            weight: FontWeight.w500,
            color: c.inkSoft,
          ),
        ),
      );

  String? _wajib(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final inputStyle = AppFonts.sans(size: 16, color: c.ink);

    return Panel(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _sedangEdit ? 'Ubah sampah' : 'Tambah sampah',
              style: AppFonts.serif(size: 25.6, color: c.ink, height: 1.15),
            ),

            _label(c, 'Nama sampah'),
            TextFormField(
              controller: _nama,
              focusNode: _namaFocus,
              style: inputStyle,
              decoration: _deco(c, hint: 'Contoh: kulit pisang'),
              validator: _wajib,
              textInputAction: TextInputAction.next,
            ),

            _label(c, 'Kategori'),
            InputDecorator(
              decoration: _deco(c),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<WasteCategory>(
                  value: _kategori,
                  isDense: true,
                  isExpanded: true,
                  dropdownColor: c.panel,
                  style: inputStyle,
                  items: [
                    for (final k in WasteCategory.values)
                      DropdownMenuItem(value: k, child: Text(k.formLabel)),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _kategori = v);
                  },
                ),
              ),
            ),

            _label(c, 'Dibuang ke mana'),
            TextFormField(
              controller: _tempat,
              style: inputStyle,
              decoration: _deco(c, hint: 'Contoh: tong hijau / bank sampah'),
              validator: _wajib,
              textInputAction: TextInputAction.next,
            ),

            _label(c, 'Cara menangani'),
            TextFormField(
              controller: _catatan,
              style: inputStyle,
              decoration:
                  _deco(c, hint: 'Misal: dibilas dulu, jangan dicampur'),
              minLines: 2,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
            ),

            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: PillButton(
                    label: _sedangEdit ? 'Simpan perubahan' : 'Simpan',
                    filled: true,
                    onPressed: _submit,
                  ),
                ),
                if (_sedangEdit) ...[
                  const SizedBox(width: 10),
                  PillButton(
                    label: 'Batal',
                    onPressed: widget.controller.cancelEdit,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
