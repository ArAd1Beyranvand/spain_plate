import 'package:plate_core/plate_core.dart';

import 'spain_colors.dart';

/// Spain as a `PlateCountry`: the EU band. The `E` beneath the stars is a
/// [PlateLabel] on the spec, so [captionLines] is empty.
abstract final class SpainCountry {
  static const PlateCountry spain = PlateCountry(
    code: 'es',
    captionLines: <String>[],
    panelColor: SpainColors.euroBlue,
    panelTextColor: SpainColors.white,
    flagAspectRatio: 46 / 70.4,
    flag: SvgPlateAsset(
      'assets/flags/Flag_of_Europe.svg',
      package: 'plate_core',
    ),
  );
}
