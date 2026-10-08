import 'package:flutter/widgets.dart';

/// The colours of the Spanish plates, sampled from the flattened references
/// (modal pixel of the region, balanced against the field of the same photo).
///
/// Black on white and the euroband `033FA2` come from the vector reference
/// (`2000_2008_ZGZ_largo`), so they are the artwork's own. The coloured
/// fields are photographs and carry the lighting of their photo: the
/// diplomatic red `F84A47`, green `00C7B0` and blue `0654BE`, the trailer red
/// `FC2323`, the taxi blue `0573F1` and the provisional teal `11ACB5`. The
/// article calls the provisional plate green; the photo is a teal, so the
/// pixels win.
abstract final class SpainColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color euroBlue = Color(0xFF033FA2);

  static const Color diplomaticRed = Color(0xFFF84A47);
  static const Color diplomaticRedInk = Color(0xFFF2F3F1);
  static const Color consularGreen = Color(0xFF00C7B0);
  static const Color consularGreenInk = Color(0xFFF2F6F4);
  static const Color organisationBlue = Color(0xFF0654BE);
  static const Color organisationBlueInk = Color(0xFFD6DBEE);

  static const Color trailerRed = Color(0xFFFC2323);
  static const Color trailerInk = Color(0xFF483C3D);

  static const Color taxiBlue = Color(0xFF0573F1);
  static const Color taxiInk = Color(0xFFB1C5F5);

  static const Color provisionalTeal = Color(0xFF11ACB5);
  static const Color provisionalInk = Color(0xFFF9FAFB);

  static const Color inactive = Color(0xFFB0B0B0);
}
