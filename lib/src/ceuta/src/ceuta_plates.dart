import 'dart:math';

import 'package:flutter/widgets.dart' show EdgeInsets;
import 'package:plate_alphabet/plate_alphabet.dart';
import 'package:plate_core/plate_core.dart';

import 'ceuta_colors.dart';
import 'ceuta_country.dart';

/// Where the ink sits, in plate units. Every reference is flattened to the
/// 500×110 the article gives (4 px per unit) and each glyph run is read off
/// the column projection of its ink (`.plateref/ce/flat_*`).
///
/// A field is a centre and a printed pitch (glyph centre to glyph centre):
///
/// - Euroband (`2000_2008_ZGZ_largo`, vector): blue x 8.5–46 under the frame,
///   so the section ends at 46; stars x 11–42.5, y 22.5–52; `E` white, x
///   20–35.5, y 70.5–86.3. Digits of `2008` x 68–276, letters x 317.5–469; ink
///   y 18.25–91.25 (73 tall).
/// - Taxi: digits x 61.5–277.8, letters x 316.8–478.5; ink y 15–94.5.
/// - Historic `H7010BBD`: `H` x 78–120, digits x 126–319, letters x 324–472,
///   touching; ink y 14.2–92.8.
/// - Trailer (`R 7286 BBW`): `R` x 23–69, digits x 81.5–302, letters x
///   329.5–481. The provisional plate takes the same layout; its own photo is
///   mottled and its runs merge, so one photo cannot give a pitch.
/// - Dealer (`S 1746 BCD`): `S` x 35–64, digits x 129–275 (the `1` is narrow,
///   its cell starts near 120), letters x 340.5–452; the sticker at x 460–489
///   and the two black straps are not drawn. Condensed face, pitch 42.
/// - Diplomatic (`CD 1 001`, `CC 10 014`): prefix x 18.5–122, centre about 68;
///   the embassy group is centred near 235 (CD 219, CC 240) and may be three
///   digits (`OI 303 073`); car number x 325–477, pitch 52.
/// - Mossos d'Esquadra (`CME 2342`, CHECK-fitted, blurred): letters x 3–148,
///   digits x 241–490; ink y 22.8–95.5.
///
/// Every ink is about 75 tall on a 110 plate; a box that tall would need ~140,
/// so each box is the full canvas height and the ink lands near 58, about 78%
/// of reference. The fixed prefixes are labels at the slots' size.
abstract final class _Layout {
  static const double width = 500, height = 110;
  static const double bandEnd = 46;

  static const double box = 110, top = 0;
  static const double prefixWidth = 50;

  static const double starsLeft = 1, starsTop = 2, starsHeight = 70.4;
  static const double eLeft = 4.7, eTop = 66.4, eWidth = 46;
  static const double eHeight = 24, eGlyph = 31;

  static const _Field euroDigits = _Field(172, 54.8);
  static const _Field euroLetters = _Field(393.25, 53.9);
  static const _Field taxiDigits = _Field(169.65, 57.4);
  static const _Field taxiLetters = _Field(397.65, 58.7);
  static const _Field historicDigits = _Field(222.2, 49.9);
  static const _Field historicLetters = _Field(398, 50.3);
  static const double historicPrefixCx = 99;
  static const _Field trailerDigits = _Field(196, 52.9);
  static const _Field trailerLetters = _Field(401, 53.5);
  static const double trailerPrefixCx = 46;
  static const _Field dealerDigits = _Field(197.5, 42);
  static const _Field dealerLetters = _Field(396.4, 41.7);
  static const double dealerPrefixCx = 49.5;

  static const _Field diplomaticCode = _Field(68, 56);
  static const double embassyLeft = 160, embassyWidth = 150;
  static const _Field diplomaticCar = _Field(400, 52);

  static const _Field policeCode = _Field(76, 49);
  static const _Field policeDigits = _Field(365, 62);
}

/// A run of glyphs centred on [centre], printed every [pitch].
class _Field {
  const _Field(this.centre, this.pitch);

  final double centre, pitch;
}

/// Ceuta's plates, Spain's national series. Groups `number`, `letters` on a
/// registration; `prefix`, `number` on a police plate; `code`, `embassy`,
/// `number` on a diplomatic plate.
///
/// [private] is the current series, `1234 BCD` black on white with the EU
/// band; [historic] is the same with a fixed `H`; [taxi] is white on blue with
/// the band. [trailer] (`R`), [provisional] (`P`) and [dealer] (`S`) are
/// single-colour fields with no band and a fixed prefix; [diplomatic] (embassy
/// code of one to three digits) pairs with [CeutaThemes.diplomatic],
/// [CeutaThemes.consular] or [CeutaThemes.organisation]; [police] is a state
/// code of one to three letters and four digits.
///
/// Diplomatic code 83 is Israel's in the article's table and is refused with
/// [CeutaPlates.israel] on the diplomatic spec, reason `COUNTRY NOT FOUND`, in
/// the controller, input machine, validator and canvas.
///
/// Not implemented: the 1971–2000 provincial series (`A-0849-CS`, `PO-9385-BH`,
/// the numeric `OR 29495`), superseded in 2000 and not Ceuta's current system;
/// the Ertzaintza plate, whose first glyph is a special Basque `E` that no font
/// carries; the `M` e-scooter plate (unticked in the offline stage and with no
/// reference); the yellow moped, special and `TA` plates, which the article
/// describes only in prose.
abstract final class CeutaPlates {
  /// The error every layer shows for a refused embassy code.
  static const String notFound = 'COUNTRY NOT FOUND';

  /// Embassy code 83 as typed, with and without a leading zero.
  static const PlateRestriction israel = PlateRestriction(
    group: 'embassy',
    values: <String>['83', '083'],
    reason: notFound,
  );

  static final PlateSpec private = _registration(
    'ce.private',
    _Layout.euroDigits,
    _Layout.euroLetters,
    band: true,
  );
  static final PlateSpec historic = _registration(
    'ce.historic',
    _Layout.historicDigits,
    _Layout.historicLetters,
    band: true,
    prefix: ('H', _Layout.historicPrefixCx),
  );
  static final PlateSpec taxi = _registration(
    'ce.taxi',
    _Layout.taxiDigits,
    _Layout.taxiLetters,
    band: true,
  );
  static final PlateSpec trailer = _registration(
    'ce.trailer',
    _Layout.trailerDigits,
    _Layout.trailerLetters,
    prefix: ('R', _Layout.trailerPrefixCx),
  );
  static final PlateSpec provisional = _registration(
    'ce.provisional',
    _Layout.trailerDigits,
    _Layout.trailerLetters,
    prefix: ('P', _Layout.trailerPrefixCx),
  );
  static final PlateSpec dealer = _registration(
    'ce.dealer',
    _Layout.dealerDigits,
    _Layout.dealerLetters,
    prefix: ('S', _Layout.dealerPrefixCx),
  );

  static final PlateSpec police = _spec(
    id: 'ce.police',
    slots: <PlateSlot>[
      _run(CeutaAlphabets.stateLetters, 3, _Layout.policeCode, minLength: 1),
      _run(CeutaAlphabets.digits, 4, _Layout.policeDigits),
    ],
    groups: const <PlateTextGroup>[
      PlateTextGroup(<int>[0], key: 'prefix'),
      PlateTextGroup(<int>[1], key: 'number'),
    ],
  );

  static final PlateSpec diplomatic = _spec(
    id: 'ce.diplomatic',
    slots: <PlateSlot>[
      _run(CeutaAlphabets.diplomaticLetters, 2, _Layout.diplomaticCode),
      PlateSlot(
        alphabet: CeutaAlphabets.digits,
        box: const PlateBox(_Layout.embassyLeft, _Layout.top, _Layout.embassyWidth, _Layout.box),
        length: 3,
        minLength: 1,
      ),
      _run(CeutaAlphabets.digits, 3, _Layout.diplomaticCar),
    ],
    groups: const <PlateTextGroup>[
      PlateTextGroup(<int>[0], key: 'code'),
      PlateTextGroup(<int>[1], key: 'embassy'),
      PlateTextGroup(<int>[2], key: 'number'),
    ],
    restrictions: const <PlateRestriction>[israel],
  );

  static List<PlateSpec> get all => <PlateSpec>[
    private,
    historic,
    taxi,
    trailer,
    provisional,
    dealer,
    police,
    diplomatic,
  ];

  /// One field of [count] characters centred on [field]; a variable field
  /// (`minLength`) keeps spacing 0.
  static PlateSlot _run(PlateAlphabet alphabet, int count, _Field field, {int? minLength}) =>
      PlateSlot(
        alphabet: alphabet,
        box: PlateBox(
          field.centre - count * field.pitch / 2,
          _Layout.top,
          count * field.pitch,
          _Layout.box,
        ),
        length: count,
        minLength: minLength,
        spacing: minLength == null ? max(0, field.pitch - 0.6 * 0.72 * _Layout.box) : 0,
      );

  static PlateSpec _registration(
    String id,
    _Field digits,
    _Field letters, {
    bool band = false,
    (String, double)? prefix,
  }) => _spec(
    id: id,
    band: band,
    slots: <PlateSlot>[
      _run(CeutaAlphabets.digits, 4, digits),
      _run(CeutaAlphabets.letters, 3, letters),
    ],
    groups: const <PlateTextGroup>[
      PlateTextGroup(<int>[0], key: 'number'),
      PlateTextGroup(<int>[1], key: 'letters'),
    ],
    labels: <PlateLabel>[
      if (prefix != null)
        PlateLabel(
          text: prefix.$1,
          box: PlateBox(
            prefix.$2 - _Layout.prefixWidth / 2,
            _Layout.top,
            _Layout.prefixWidth,
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
    country: CeutaCountry.ceuta,
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
          color: CeutaColors.white,
        ),
      ...labels,
    ],
    textGroups: groups,
    restrictions: restrictions,
  );
}
