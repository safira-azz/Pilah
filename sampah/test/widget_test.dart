import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sampah/app.dart';
import 'package:sampah/controllers/waste_controller.dart';
import 'package:sampah/core/theme/app_fonts.dart';
import 'package:sampah/data/repositories/waste_repository.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AppFonts.useGoogleFonts = false; // tidak butuh internet saat test
  });

  testWidgets('menampilkan judul dan data awal', (tester) async {
    final controller = WasteController(WasteRepository());
    await controller.load();

    await tester.pumpWidget(PilahApp(controller: controller));

    expect(find.text('Pilah'), findsOneWidget);
    expect(find.text('Kulit pisang'), findsOneWidget);
    expect(find.text('4 dari 4 sampah ditampilkan'), findsOneWidget);
  });

  test('pencarian dan filter kategori', () async {
    final controller = WasteController(WasteRepository());
    await controller.load();

    controller.setQuery('baterai');
    expect(controller.filtered.length, 1);

    controller.resetFilter();
    expect(controller.filtered.length, 4);
  });
}
