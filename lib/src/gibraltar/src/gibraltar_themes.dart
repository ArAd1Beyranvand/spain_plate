import 'package:flutter/widgets.dart';
import 'package:plate_core/plate_core.dart';

import 'gibraltar_colors.dart';

/// Black on one field, no frame colour of its own (the printed rule is thin).
abstract final class GibraltarThemes {
  static const double _border = 0.025;
  static const double _radius = 0.06;

  static PlateTheme _mono(Color field) => PlateTheme.monochrome(
    field: field,
    ink: GibraltarColors.black,
    inactive: GibraltarColors.inactiveOnLight,
    borderWidthRatio: _border,
    plateRadiusRatio: _radius,
  );

  static final PlateTheme front = _mono(GibraltarColors.white);

  /// Rear, temporary, trailer, official and armed-forces plates.
  static final PlateTheme rear = _mono(GibraltarColors.rearYellow);
}
