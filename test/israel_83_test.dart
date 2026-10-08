import 'package:flutter_test/flutter_test.dart';
import 'package:plate_core/plate_core.dart';
import 'package:spain_plate/spain_plate.dart';

/// Embassy code 83 (Israel) must be refused on a diplomatic plate.
void main() {
  List<String?> values(String s) => s.split('');

  test('three-digit spec refuses 083', () {
    final PlateSpec spec = SpainPlates.diplomatic;
    expect(spec.restrictions, contains(SpainPlates.israel));
    expect(
      spec.restrictionViolatedBy(values('CD083123'))?.reason,
      SpainPlates.notFound,
    );
    expect(spec.restrictionViolatedBy(values('CD084123')), isNull);
  });

  test('two-digit spec refuses 83', () {
    final PlateSpec spec = SpainPlates.diplomaticFor(2);
    expect(
      spec.restrictionViolatedBy(values('CD83123'))?.reason,
      SpainPlates.notFound,
    );
  });

  test('controller drops the digit that completes 83', () {
    final PlateController c = PlateController.fromValues(
      SpainPlates.diplomaticFor(2),
      values('CD8_123'),
    );
    expect(c.setAt(3, '3'), isFalse);
    expect(c.valueAt(3), isNull);
    expect(c.rejection.value?.reason, 'COUNTRY NOT FOUND');
    expect(c.setAt(3, '4'), isTrue);
    expect(c.rejection.value, isNull);
    c.dispose();
  });
}
