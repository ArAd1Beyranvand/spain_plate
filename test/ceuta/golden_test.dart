import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spain_plate/spain_plate.dart';
import 'package:plate_core/plate_core.dart';

/// One golden per category, drawn with real bold faces so the ink can be
/// measured against the references (`platekit golden-check`).
///
/// Regenerate with `flutter test --update-goldens` after a deliberate change.
void main() {
  setUpAll(() async {
    final FontLoader loader = FontLoader('Roboto');
    for (final String path in const <String>[
      '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
    ]) {
      final File face = File(path);
      if (!face.existsSync()) continue;
      loader.addFont(face.readAsBytes().then((b) => ByteData.view(b.buffer)));
    }
    await loader.load();
  });

  /// category id -> (spec, theme, sample value: one space-separated token
  /// per slot, i.e. per field — `'AB 1234'`, never `'A B 1 2 3 4'`)
  final Map<String, (PlateSpec, PlateTheme, String)> cases =
      <String, (PlateSpec, PlateTheme, String)>{
        'private': (CeutaPlates.private, CeutaThemes.private, '2008 ZGZ'),
        'historic': (CeutaPlates.historic, CeutaThemes.historic, '7010 BBD'),
        'taxi': (CeutaPlates.taxi, CeutaThemes.taxi, '6334 HRD'),
        'trailer': (CeutaPlates.trailer, CeutaThemes.trailer, '7286 BBW'),
        'provisional': (CeutaPlates.provisional, CeutaThemes.provisional, '1588 BBS'),
        'dealer': (CeutaPlates.dealer, CeutaThemes.dealer, '1746 BCD'),
        'police': (CeutaPlates.police, CeutaThemes.police, 'CME 2342'),
        'diplomatic': (CeutaPlates.diplomatic, CeutaThemes.diplomatic, 'CD 1 001'),
        'consular': (CeutaPlates.diplomatic, CeutaThemes.consular, 'CC 10 014'),
        'organisation': (CeutaPlates.diplomatic, CeutaThemes.organisation, 'OI 303 073'),
      };

  for (final MapEntry<String, (PlateSpec, PlateTheme, String)> c in cases.entries) {
    testWidgets(c.key, (tester) async {
      final (PlateSpec spec, PlateTheme theme, String values) = c.value;
      final PlateController controller = PlateController.fromValues(spec, values.split(' '));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 680,
                height: 300,
                child: PlateThemeScope(
                  theme: theme,
                  child: PlateView(
                    controller: controller,
                    theme: theme,
                    country: CeutaCountry.ceuta,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(find.byType(PlateView), matchesGoldenFile('goldens/ce_${c.key}.png'));
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    });
  }
}
