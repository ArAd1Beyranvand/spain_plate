import 'dart:math';

import 'package:flutter/widgets.dart' show EdgeInsets;
import 'package:plate_alphabet/plate_alphabet.dart';
import 'package:plate_core/plate_core.dart';

import 'spain_colors.dart';
import 'spain_country.dart';

/// Where the ink sits, in plate units. Every reference is flattened to the
/// 500×110 the article gives (4 px per unit) and projected onto each axis.
///
/// Euroband (`2000_2008_ZGZ_largo`, vector): blue x 8.5–46 under the frame, so
/// the section ends at 46; stars x 11–42.5, y 22.5–52 (the shared asset is
/// 34 across, about 8% larger, placed with its centre on theirs); `E` white,
/// x 20–35.5, y 70.5–86.3 (cap 15.8). Digits of `2008` centred 90.0, 144.8,
/// 199.7, 254.0 (pitch 54.7), letters 338.9, 393.3, 446.8 (pitch 54.0); ink
/// y 18.25–91.25 (73 tall, centre 54.75).
///
/// Taxi (`Taxi_license_plate_behind_01`): digits 42.9, 105.9, 169.0, 232.0
/// (pitch 63.0), letters 323.0, 387.8, 452.6 (pitch 64.8); ink y 19.2–94.5.
///
/// Trailer (`1971_R_7286_BBW_remolque`): `R` centred 45.0, digits 116.7,
/// 169.5, 222.4, 275.3 (pitch 52.9), letters 347.4, 401.1, 454.3 (pitch 53.5);
/// ink y 15–94.2. The provisional plate is laid out from it; its own photo is
/// CHECK-fitted and measures a tighter pitch (about 45), which one photo
/// cannot confirm.
///
/// Diplomatic (`CD_1_001`, `CC_10_014`, `OI_303_073`): prefix letters 46.3 and
/// 102.4 (CD); the embassy group ends at 237.6 (mean of CD 222, CC 241.6, OI
/// 249.3), the car number is centred 348.7, 401.2, 453.7 (CD and CC), and both
/// groups step 52.5 (CC 53.6, OI 51.5; CD's last group 50.9). The OI photo is
/// stretched to 4.79 and is left out of the first and last centres. Ink y
/// 16.5–93.2.
///
/// Every ink is about 75 tall on a 110 plate; a box that tall would need ~140,
/// so each box is the full canvas height and the ink lands near 58, about 78%
/// of reference. The trailer's `R` and the provisional `P` are fixed labels at
/// the slots' size.
abstract final class _Layout {
  static const double width = 500, height = 110;
  static const double bandEnd = 46;

  static const double box = 110, top = 0;

  static const double starsLeft = 1, starsTop = 2, starsHeight = 70.4;
  static const double eLeft = 4.7, eTop = 66.4, eWidth = 46;
  static const double eHeight = 24, eGlyph = 31;

  static const _Row euro = _Row(90.0, 54.7, 338.9, 54.0);
  static const _Row taxi = _Row(42.9, 63.0, 323.0, 64.8);
  static const _Row lead = _Row(116.7, 52.9, 347.4, 53.5);
  static const double leadCx = 45;

  static const double dipLetterCx = 46.3, dipLetterPitch = 56.1;
  static const double dipEmbassyEnd = 237.6, dipPitch = 52.5;
  static const double dipNumberCx = 348.7;
}

/// Four digits at [digitCx] and three letters at [letterCx], each group evenly
/// pitched.
class _Row {
  const _Row(this.digitCx, this.digitPitch, this.letterCx, this.letterPitch);

  final double digitCx, digitPitch, letterCx, letterPitch;
}

/// The Spanish plates. Groups `number`, `letters` on a registration;
/// `code`, `embassy`, `number` on a diplomatic plate.
///
/// [private] is the current series, `1234 BCD` black on white with the EU
/// band; [taxi], [trailer] and [provisional] are single-colour fields with no
/// band, and [diplomatic] (embassy code of one to three digits)
/// pairs with [SpainThemes.diplomatic], [SpainThemes.consular] or
/// [SpainThemes.organisation].
///
/// Diplomatic code 83 is Israel's in the article's table and is refused with
/// [SpainPlates.israel] on every diplomatic spec, reason
/// `COUNTRY NOT FOUND`, in the controller, input machine, validator and
/// canvas.
///
/// Not implemented: the historic `H` plate, the Mossos d'Esquadra and other
/// police plates, the yellow moped, E-scooter, special, temporary and dealer
/// plates, TA plates, and the 1971 province series; no usable reference was
/// measured for them.
abstract final class SpainPlates {
  /// The error every layer shows for a refused embassy code.
  static const String notFound = 'COUNTRY NOT FOUND';

  /// Embassy code 83 as typed, with and without a leading zero.
  static const PlateRestriction israel = PlateRestriction(
    group: 'embassy',
    values: <String>['83', '083'],
    reason: notFound,
  );

  static final PlateSpec private = _registration('es.private', _Layout.euro, band: true);
  static final PlateSpec taxi = _registration('es.taxi', _Layout.taxi);
  static final PlateSpec trailer = _registration('es.trailer', _Layout.lead, lead: 'R');
  static final PlateSpec provisional = _registration('es.provisional', _Layout.lead, lead: 'P');
  static final PlateSpec diplomatic = _spec(
    id: 'es.diplomatic',
    slots: <PlateSlot>[
      _run(SpainAlphabets.diplomaticLetters, 2, _Layout.dipLetterCx, _Layout.dipLetterPitch),
      _run(
        SpainAlphabets.digits,
        3,
        _Layout.dipEmbassyEnd - 2 * _Layout.dipPitch,
        _Layout.dipPitch,
        minLength: 1,
      ),
      _run(SpainAlphabets.digits, 3, _Layout.dipNumberCx, _Layout.dipPitch),
    ],
    groups: const <PlateTextGroup>[
      PlateTextGroup(<int>[0], key: 'code'),
      PlateTextGroup(<int>[1], key: 'embassy'),
      PlateTextGroup(<int>[2], key: 'number'),
    ],
    restrictions: const <PlateRestriction>[israel],
  );

  static List<PlateSpec> get all => <PlateSpec>[private, taxi, trailer, provisional, diplomatic];

  /// One field of [count] characters whose first cell is centred on
  /// [firstCx]; a variable field (`minLength`) keeps spacing 0.
  static PlateSlot _run(
    PlateAlphabet alphabet,
    int count,
    double firstCx,
    double pitch, {
    int? minLength,
  }) => PlateSlot(
    alphabet: alphabet,
    box: PlateBox(firstCx - pitch / 2, _Layout.top, count * pitch, _Layout.box),
    length: count,
    minLength: minLength,
    spacing: minLength == null ? max(0, pitch - 0.6 * 0.72 * _Layout.box) : 0,
  );

  static PlateSpec _registration(String id, _Row row, {bool band = false, String? lead}) => _spec(
    id: id,
    band: band,
    slots: <PlateSlot>[
      _run(SpainAlphabets.digits, 4, row.digitCx, row.digitPitch),
      _run(SpainAlphabets.letters, 3, row.letterCx, row.letterPitch),
    ],
    groups: const <PlateTextGroup>[
      PlateTextGroup(<int>[0], key: 'number'),
      PlateTextGroup(<int>[1], key: 'letters'),
    ],
    labels: <PlateLabel>[
      if (lead != null)
        PlateLabel(
          text: lead,
          box: PlateBox(
            _Layout.leadCx - _Layout.lead.digitPitch / 2,
            _Layout.top,
            _Layout.lead.digitPitch,
            _Layout.box,
          ),
          glyphHeight: _Layout.box,
        ),
    ],
  );

  static PlateSpec _spec({
    required String id,
    required List<PlateSlot> slots,
    required List<PlateTextGroup> groups,
    bool band = false,
    List<PlateLabel> labels = const <PlateLabel>[],
    List<PlateRestriction> restrictions = const <PlateRestriction>[],
  }) => PlateSpec(
    id: id,
    country: SpainCountry.spain,
    canvasWidth: _Layout.width,
    canvasHeight: _Layout.height,
    panel: band
        ? const PlatePanel(
            box: PlateBox(
              _Layout.starsLeft,
              _Layout.starsTop,
              _Layout.bandEnd,
              _Layout.starsHeight,
            ),
            padding: EdgeInsets.zero,
          )
        : const PlatePanel(box: PlateBox(0, 0, 0, 0)),
    noPanel: !band,
    background: band
        ? const PlateSection.columns(<PlatePart>[
            PlatePart(PlateSection.fill(PlateFill.panel), end: _Layout.bandEnd),
            PlatePart(PlateSection.plain),
          ])
        : PlateSection.plain,
    slots: slots,
    labels: <PlateLabel>[
      if (band)
        const PlateLabel(
          text: 'E',
          box: PlateBox(_Layout.eLeft, _Layout.eTop, _Layout.eWidth, _Layout.eHeight),
          glyphHeight: _Layout.eGlyph,
          color: SpainColors.white,
        ),
      ...labels,
    ],
    textGroups: groups,
    restrictions: restrictions,
  );
}
