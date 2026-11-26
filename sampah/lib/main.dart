import 'package:material_ui/material_ui.dart';

import 'package:sampah/app.dart';
import 'package:sampah/controllers/waste_controller.dart';
import 'package:sampah/data/repositories/waste_repository.dart';

/// Titik masuk aplikasi.
/// Data dimuat dulu dari penyimpanan lokal, baru UI ditampilkan,
/// jadi layar tidak sempat "kosong" sebelum data siap.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final controller = WasteController(WasteRepository());
  await controller.load();

  runApp(PilahApp(controller: controller));
}
