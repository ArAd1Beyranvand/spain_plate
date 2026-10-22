import 'package:plate_core/plate_core.dart';

import 'ceuta_colors.dart';

/// Ceuta as a `PlateCountry`: the EU band every Spanish plate of the current
/// series carries. The `E` beneath the stars is a [PlateLabel] on the spec, so
/// [captionLines] is empty. `ea` is the code ISO 3166-1 reserves for Ceuta and
/// Melilla.
abstract final class CeutaCountry {
  static const PlateCountry ceuta = PlateCountry(
    code: 'ea',
    captionLines: <String>[],
    panelColor: CeutaColors.euroBlue,
    panelTextColor: CeutaColors.white,
    flagAspectRatio: 46 / 70.4,
    flag: EuropeanStars.band,
  );
}
