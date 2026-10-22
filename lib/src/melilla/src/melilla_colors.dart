import 'package:flutter/widgets.dart';

/// The colours of Melilla's plates, which are Spain's national series, sampled
/// from the flattened references (modal pixel of the region, balanced against
/// the field of the same photo).
///
/// Black on white and the euroband `033FA2` come from the vector reference
/// (`2000_2008_ZGZ_largo`). The coloured fields are photographs and carry the
/// lighting of their photo: diplomatic red `F64A47`, consular green `01BDA7`,
/// organisation blue `0654BE`, trailer red `F42223`, dealer red `DB132A`,
/// taxi blue `056EEA` and provisional teal `11ABB3`. The article calls the
/// provisional plate green; the photo is a teal, so the pixels win. The
/// Mossos d'Esquadra photo is hazy and its beige field `E2D5BE` and navy ink
/// `1F1E3A` are the least certain values here.
abstract final class MelillaColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color euroBlue = Color(0xFF033FA2);

  static const Color diplomaticRed = Color(0xFFF64A47);
  static const Color diplomaticRedInk = Color(0xFFF3F4F0);
  static const Color consularGreen = Color(0xFF01BDA7);
  static const Color consularGreenInk = Color(0xFFECE9E8);
  static const Color organisationBlue = Color(0xFF0654BE);
  static const Color organisationBlueInk = Color(0xFFD6DBEE);

  static const Color trailerRed = Color(0xFFF42223);
  static const Color trailerInk = Color(0xFF463A3B);

  static const Color dealerRed = Color(0xFFDB132A);
  static const Color dealerInk = Color(0xFFEBF2ED);

  static const Color taxiBlue = Color(0xFF056EEA);
  static const Color taxiInk = Color(0xFFBCCCF6);

  static const Color provisionalTeal = Color(0xFF11ABB3);
  static const Color provisionalInk = Color(0xFFF9FAFB);

  static const Color policeField = Color(0xFFE2D5BE);
  static const Color policeInk = Color(0xFF1F1E3A);

  static const Color inactive = Color(0xFFB0B0B0);
}
