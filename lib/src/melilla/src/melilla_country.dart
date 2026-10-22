import 'package:plate_core/plate_core.dart';

import 'melilla_colors.dart';

/// Melilla as a `PlateCountry`: the EU band every Spanish plate of the current
/// series carries. The `E` beneath the stars is a [PlateLabel] on the spec, so
/// [captionLines] is empty. `ea` is the code ISO 3166-1 reserves for Melilla and
/// Melilla.
abstract final class MelillaCountry {
  static const PlateCountry melilla = PlateCountry(
    code: 'ea',
    captionLines: <String>[],
    panelColor: MelillaColors.euroBlue,
    panelTextColor: MelillaColors.white,
    flagAspectRatio: 46 / 70.4,
    flag: EuropeanStars.band,
  );
}
