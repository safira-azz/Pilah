import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';

/// FITUR: Header / judul aplikasi.
///
/// Menampilkan nama "Pilah", garis emas kecil di bawahnya, dan satu kalimat
/// pengantar. Ukuran judul menyesuaikan lebar layar (maks. ±83px).
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final width = MediaQuery.sizeOf(context).width;
    final titleSize = (width * 0.09).clamp(48.0, 83.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilah',
          style: AppFonts.serif(
            size: titleSize,
            weight: FontWeight.w400,
            color: c.ink,
            height: 1.15,
            letterSpacing: -0.02 * titleSize,
          ),
        ),
        const SizedBox(height: 18),
        Container(width: 56, height: 2, color: c.emas),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Text(
            'Catatan jenis sampah dan cara membuangnya. Tambah, ubah, dan cari '
            'sendiri sesuai kebutuhan lingkunganmu.',
            style: AppFonts.sans(size: 16.8, color: c.inkSoft, height: 1.6),
          ),
        ),
        const SizedBox(height: 36),
      ],
    );
  }
}
