import 'package:material_ui/material_ui.dart';

import '../../controllers/waste_controller.dart';
import '../../core/widgets/content_width.dart';
import '../category_counter/category_counter.dart';
import '../header/header_section.dart';
import '../search/search_section.dart';
import '../waste_form/waste_form.dart';
import '../waste_list/waste_list.dart';

/// Halaman utama: hanya MENYUSUN tata letak, semua fitur ada di foldernya masing-masing.
///
/// Layar lebar (> 820px): form di kiri (330px), pencarian + daftar di kanan.
/// Layar sempit: satu kolom, form di atas lalu pencarian + daftar.
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});

  final WasteController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final compact =
                  MediaQuery.sizeOf(context).width <= ContentWidth.breakpoint;

              final form = WasteForm(controller: controller);
              final kanan = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchSection(controller: controller),
                  WasteList(controller: controller),
                ],
              );

              return Column(
                children: [
                  // ---- bagian atas: judul + penghitung kategori ----
                  ContentWidth(
                    padding: EdgeInsets.fromLTRB(24, compact ? 40 : 56, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeaderSection(),
                        CategoryCounter(
                            controller: controller, compact: compact),
                      ],
                    ),
                  ),

                  // ---- bagian utama: form + daftar ----
                  ContentWidth(
                    padding: const EdgeInsets.fromLTRB(24, 36, 24, 72),
                    child: compact
                        ? Column(children: [
                            form,
                            const SizedBox(height: 28),
                            kanan,
                          ])
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 330, child: form),
                              const SizedBox(width: 36),
                              Expanded(child: kanan),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
