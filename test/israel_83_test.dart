import 'package:flutter_test/flutter_test.dart';
import 'package:plate_core/plate_core.dart';
import 'package:spain_plate/spain_plate.dart';

/// Embassy code 83 (Israel) must be refused on a diplomatic plate.
void main() {
  test('three-digit spec refuses 083', () {
    final PlateSpec spec = SpainPlates.diplomatic;
    expect(spec.restrictions, contains(SpainPlates.israel));
    expect(spec.restrictionViolatedBy(['CD', '083', '123'])?.reason, SpainPlates.notFound);
    expect(spec.restrictionViolatedBy(['CD', '084', '123']), isNull);
  });

  test('two-digit spec refuses 83', () {
    final PlateSpec spec = SpainPlates.diplomatic;
    expect(spec.restrictionViolatedBy(['CD', '83', '123'])?.reason, SpainPlates.notFound);
  });

  test('controller refuses a run that is 83', () {
    final PlateController c = PlateController.fromValues(SpainPlates.diplomatic, <String?>[
      'CD',
      '7',
      '123',
    ]);
    expect(c.setAt(1, '83'), isFalse);
    expect(c.valueAt(1), '7');
    expect(c.rejection.value?.reason, 'COUNTRY NOT FOUND');
    expect(c.setAt(1, '84'), isTrue);
    expect(c.valueAt(1), '84');
    expect(c.rejection.value, isNull);
    c.dispose();
  });
}
