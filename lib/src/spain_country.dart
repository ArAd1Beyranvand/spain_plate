import 'package:plate_core/plate_core.dart';

import 'spain_colors.dart';

/// Spain as a `PlateCountry`: the EU band. The twelve stars are drawn into the
/// shared asset `plate_core` ships; the `E` beneath them is a [PlateLabel] on the spec, so
/// [captionLines] is empty. The plates with no band set `noPanel`.
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
