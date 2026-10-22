import 'package:flutter/widgets.dart';
import 'package:plate_core/plate_core.dart';

import 'melilla_colors.dart';

/// One ink on one field, the frame in the ink.
///
/// The vector reference's frame is about 4.25 of 110 thick (0.04) with a corner
/// arc near 10 (0.09). The photographed plates show no printed frame, so theirs
/// is none and a small radius; neither is measured beyond looking at the flats.
abstract final class MelillaThemes {
  /// Registration plate: black on white, with the euroband.
  static final PlateTheme private = _framed(MelillaColors.white, MelillaColors.black);

  /// Historic `H`: black on white, as the private plate.
  static final PlateTheme historic = _framed(MelillaColors.white, MelillaColors.black);

  static final PlateTheme taxi = _flat(MelillaColors.taxiBlue, MelillaColors.taxiInk);
  static final PlateTheme trailer = _flat(MelillaColors.trailerRed, MelillaColors.trailerInk);
  static final PlateTheme provisional = _flat(
    MelillaColors.provisionalTeal,
    MelillaColors.provisionalInk,
  );
  static final PlateTheme dealer = _flat(MelillaColors.dealerRed, MelillaColors.dealerInk);
  static final PlateTheme police = _flat(MelillaColors.policeField, MelillaColors.policeInk);

  /// `CD`, diplomatic.
  static final PlateTheme diplomatic = _flat(
    MelillaColors.diplomaticRed,
    MelillaColors.diplomaticRedInk,
  );

  /// `CC`, consular.
  static final PlateTheme consular = _flat(
    MelillaColors.consularGreen,
    MelillaColors.consularGreenInk,
  );

  /// `OI`, international organisation.
  static final PlateTheme organisation = _flat(
    MelillaColors.organisationBlue,
    MelillaColors.organisationBlueInk,
  );
}

PlateTheme _framed(Color field, Color ink) => PlateTheme.monochrome(
  field: field,
  ink: ink,
  inactive: MelillaColors.inactive,
  borderWidthRatio: 0.04,
  plateRadiusRatio: 0.09,
);

PlateTheme _flat(Color field, Color ink) => PlateTheme.monochrome(
  field: field,
  ink: ink,
  inactive: MelillaColors.inactive,
  borderWidthRatio: 0,
  plateRadiusRatio: 0.06,
);
