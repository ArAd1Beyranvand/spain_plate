import 'package:plate_core/plate_core.dart';

import 'gibraltar_colors.dart';

/// The left band: `GBZ` (Great Britain and Northern Ireland – Z) in white on
/// blue. The post-Brexit artwork has no EU star ring, so no flag is drawn; the
/// pre-Brexit stars are not implemented.
abstract final class GibraltarCountry {
  static const PlateCountry gibraltar = PlateCountry(
    code: 'gi',
    captionLines: <String>['GBZ'],
    panelColor: GibraltarColors.bandBlue,
    panelTextColor: GibraltarColors.white,
  );
}
