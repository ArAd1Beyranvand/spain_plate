import 'package:flutter/widgets.dart';
import 'package:plate_core/plate_core.dart';

import 'ceuta_colors.dart';

/// One ink on one field, the frame in the ink.
///
/// The vector reference's frame is about 4.25 of 110 thick (0.04) with a corner
/// arc near 10 (0.09). The photographed plates show no printed frame, so theirs
/// is none and a small radius; neither is measured beyond looking at the flats.
abstract final class CeutaThemes {
  /// Registration plate: black on white, with the euroband.
  static final PlateTheme private = _framed(CeutaColors.white, CeutaColors.black);

  /// Historic `H`: black on white, as the private plate.
  static final PlateTheme historic = _framed(CeutaColors.white, CeutaColors.black);

  static final PlateTheme taxi = _flat(CeutaColors.taxiBlue, CeutaColors.taxiInk);
  static final PlateTheme trailer = _flat(CeutaColors.trailerRed, CeutaColors.trailerInk);
  static final PlateTheme provisional = _flat(
    CeutaColors.provisionalTeal,
    CeutaColors.provisionalInk,
  );
  static final PlateTheme dealer = _flat(CeutaColors.dealerRed, CeutaColors.dealerInk);
  static final PlateTheme police = _flat(CeutaColors.policeField, CeutaColors.policeInk);

  /// `CD`, diplomatic.
  static final PlateTheme diplomatic = _flat(
    CeutaColors.diplomaticRed,
    CeutaColors.diplomaticRedInk,
  );

  /// `CC`, consular.
  static final PlateTheme consular = _flat(CeutaColors.consularGreen, CeutaColors.consularGreenInk);

  /// `OI`, international organisation.
  static final PlateTheme organisation = _flat(
    CeutaColors.organisationBlue,
    CeutaColors.organisationBlueInk,
  );
}

PlateTheme _framed(Color field, Color ink) => PlateTheme.monochrome(
  field: field,
  ink: ink,
  inactive: CeutaColors.inactive,
  borderWidthRatio: 0.04,
  plateRadiusRatio: 0.09,
);

PlateTheme _flat(Color field, Color ink) => PlateTheme.monochrome(
  field: field,
  ink: ink,
  inactive: CeutaColors.inactive,
  borderWidthRatio: 0,
  plateRadiusRatio: 0.06,
);
