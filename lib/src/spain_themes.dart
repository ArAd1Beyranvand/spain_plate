import 'package:flutter/widgets.dart';
import 'package:plate_core/plate_core.dart';

import 'spain_colors.dart';

/// One ink on one field, the frame in the ink.
///
/// The vector reference's frame is about 4.25 of 110 thick (0.04) with a corner
/// arc near 10 (0.09). The photographed 1971-series plates show no printed
/// frame, so theirs is none and a small radius; neither is measured beyond
/// looking at the flats.
abstract final class SpainThemes {
  /// Registration plate: black on white, with the euroband.
  static final PlateTheme private = _framed(
    SpainColors.white,
    SpainColors.black,
  );

  static final PlateTheme taxi = _flat(
    SpainColors.taxiBlue,
    SpainColors.taxiInk,
  );
  static final PlateTheme trailer = _flat(
    SpainColors.trailerRed,
    SpainColors.trailerInk,
  );
  static final PlateTheme provisional = _flat(
    SpainColors.provisionalTeal,
    SpainColors.provisionalInk,
  );

  /// `CD`, diplomatic.
  static final PlateTheme diplomatic = _flat(
    SpainColors.diplomaticRed,
    SpainColors.diplomaticRedInk,
  );

  /// `CC`, consular.
  static final PlateTheme consular = _flat(
    SpainColors.consularGreen,
    SpainColors.consularGreenInk,
  );

  /// `OI`, international organisation.
  static final PlateTheme organisation = _flat(
    SpainColors.organisationBlue,
    SpainColors.organisationBlueInk,
  );
}

PlateTheme _framed(Color field, Color ink) => PlateTheme.monochrome(
  field: field,
  ink: ink,
  inactive: SpainColors.inactive,
  borderWidthRatio: 0.04,
  plateRadiusRatio: 0.09,
);

PlateTheme _flat(Color field, Color ink) => PlateTheme.monochrome(
  field: field,
  ink: ink,
  inactive: SpainColors.inactive,
  borderWidthRatio: 0,
  plateRadiusRatio: 0.06,
);
