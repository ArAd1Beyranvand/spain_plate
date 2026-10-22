import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:plate_alphabet/plate_alphabet.dart';
import 'package:plate_core/plate_core.dart';

import 'gibraltar_colors.dart';
import 'gibraltar_country.dart';

/// Where the ink sits, in plate coordinates. Measured off the platekit-flattened
/// references (`Current_Post-Brexit_*`, `G_3624_C_*`, `G_6065_E_*`) at the
/// 520×111 mm the article gives.
///
/// Reference ink is y ~16..94 (78 high) on a 111 plate. Ink fills ~0.55 of its
/// box, so matching would need a ~140 box; the box fills the plate instead and
/// the ink comes out at ~75% of the reference.
///
/// Banded plates: band x 0..46, characters x 91..472 (`G_3624_C`: 91..470).
/// Temporary plate: characters x 61..458, expiry band x 476..520 with the month
/// over the year (`G_6065_E`).
abstract final class _Layout {
  static const double width = 520;
  static const double height = 111;
  static const double rowTop = 3;
  static const double rowHeight = 105;

  static const double bandEnd = 46;
  static const double left = 91;
  static const double right = 472;

  static const double plainLeft = 20.8;
  static const double plainRight = 499;

  static const double tempLeft = 61;
  static const double tempRight = 458;
  static const double expiryStart = 476;
  static const double expiryTop = 8;
  static const double expiryHeight = 42;
  static const double expiryYearTop = 61;

  static const PlatePanel panel = PlatePanel(
    box: PlateBox(0, 0, bandEnd, height),
    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 14),
  );
  static const PlatePanel none = PlatePanel(box: PlateBox(0, 0, 0, 0));
}

class _Field {
  const _Field(this.key, this.alphabet, this.length, {int? minLength, this.gapBefore = false})
    : minLength = minLength ?? length;

  final String key;
  final PlateAlphabet alphabet;
  final int length;
  final int minLength;

  /// A printed space precedes this field.
  final bool gapBefore;
}

abstract final class GibraltarPlates {
  static double _spacing(double pitch, double height) => max(0, pitch - 0.6 * 0.72 * height);

  static const _Field _g = _Field('prefix', GibraltarAlphabets.prefix, 1);
  static const _Field _series = _Field('series', GibraltarAlphabets.letters, 1);

  /// One builder lays a one-line plate out from its fields on a uniform pitch,
  /// a printed space counting as one cell. Front and rear differ only in theme.
  static PlateSpec _oneLine({
    required String id,
    required List<_Field> fields,
    double left = _Layout.left,
    double right = _Layout.right,
    bool banded = true,
    bool expiry = false,
  }) {
    final cells = fields.fold<int>(0, (n, f) => n + f.length + (f.gapBefore ? 1 : 0));
    final pitch = (right - left) / cells;
    final slots = <PlateSlot>[];
    var cursor = left;
    for (final f in fields) {
      if (f.gapBefore) cursor += pitch;
      slots.add(
        PlateSlot(
          alphabet: f.alphabet,
          box: PlateBox(cursor, _Layout.rowTop, f.length * pitch, _Layout.rowHeight),
          length: f.length,
          minLength: f.minLength,
          // A variable run is centred, not pitched.
          spacing: f.minLength == f.length ? _spacing(pitch, _Layout.rowHeight) : 0,
        ),
      );
      cursor += f.length * pitch;
    }
    if (expiry) {
      for (final top in const <double>[_Layout.expiryTop, _Layout.expiryYearTop]) {
        slots.add(
          PlateSlot(
            alphabet: GibraltarAlphabets.digits,
            box: PlateBox(
              _Layout.expiryStart,
              top,
              _Layout.width - _Layout.expiryStart,
              _Layout.expiryHeight,
            ),
            length: 2,
            spacing: 0,
            color: GibraltarColors.white,
          ),
        );
      }
    }
    return PlateSpec(
      id: id,
      country: GibraltarCountry.gibraltar,
      canvasWidth: _Layout.width,
      canvasHeight: _Layout.height,
      panel: banded ? _Layout.panel : _Layout.none,
      noPanel: !banded,
      background: _background(banded: banded, expiry: expiry),
      slots: slots,
      textGroups: <PlateTextGroup>[
        for (var i = 0; i < fields.length; i++)
          PlateTextGroup(<int>[i], key: fields[i].key, prefix: fields[i].gapBefore ? ' ' : ''),
        if (expiry) ...<PlateTextGroup>[
          PlateTextGroup(<int>[fields.length], key: 'month'),
          PlateTextGroup(<int>[fields.length + 1], key: 'year'),
        ],
      ],
    );
  }

  static PlateSection _background({required bool banded, required bool expiry}) {
    if (!banded && !expiry) return PlateSection.plain;
    return PlateSection.columns(<PlatePart>[
      if (banded) const PlatePart(PlateSection.fill(PlateFill.panel), end: _Layout.bandEnd),
      if (expiry) ...const <PlatePart>[
        PlatePart(PlateSection.plain, end: _Layout.expiryStart),
        PlatePart(PlateSection.fill(PlateFill.color(GibraltarColors.expiryGreen))),
      ] else
        const PlatePart(PlateSection.plain),
    ]);
  }

  /// `G 6442 F`: the 2001 series, `G`, four digits 1000–9999 and a series
  /// letter. The picture's 5-digit pre-2001 serials (`G 99999`) are allowed
  /// by length. Front (white) and rear (yellow) differ only in theme.
  static final PlateSpec private = _oneLine(
    id: 'gi.private',
    fields: const <_Field>[
      _g,
      _Field('serial', GibraltarAlphabets.digits, 5, minLength: 1),
      _series,
    ],
  );

  /// The same with a green month/year band at the right (`G 6065 E`, 10/19).
  static final PlateSpec temporary = _oneLine(
    id: 'gi.temporary',
    fields: const <_Field>[
      _g,
      _Field('serial', GibraltarAlphabets.digits, 5, minLength: 1),
      _series,
    ],
    left: _Layout.tempLeft,
    right: _Layout.tempRight,
    expiry: true,
  );

  /// Trailer, `GT 1234 A`: `GT` replaces `G` (compulsory since 2016). The
  /// photograph is too small to measure; the private layout is used.
  static final PlateSpec trailer = _oneLine(
    id: 'gi.trailer',
    fields: const <_Field>[
      _Field('prefix', GibraltarAlphabets.prefix, 2),
      _Field('serial', GibraltarAlphabets.digits, 4, minLength: 1),
      _series,
    ],
  );

  /// Official/pre-2001 form without a series letter, `G 1` (the Chief
  /// Minister's car). Photograph too small to measure.
  static final PlateSpec numbered = _oneLine(
    id: 'gi.numbered',
    fields: const <_Field>[_g, _Field('serial', GibraltarAlphabets.digits, 5, minLength: 1)],
  );

  /// Dealer, `DLR 190`: letters then digits, from the border-crossing photo
  /// (the picture, not the brief's `4 digits`, shows three).
  static final PlateSpec dealer = _oneLine(
    id: 'gi.dealer',
    fields: const <_Field>[
      _Field('letters', GibraltarAlphabets.letters, 3),
      _Field('serial', GibraltarAlphabets.digits, 4, minLength: 1, gapBefore: true),
    ],
    left: _Layout.plainLeft,
    right: _Layout.plainRight,
    banded: false,
  );

  /// Armed forces, `44 RN 34`: unbanded.
  static final PlateSpec armedForces = _oneLine(
    id: 'gi.forces',
    fields: const <_Field>[
      _Field('first', GibraltarAlphabets.digits, 2),
      _Field('unit', GibraltarAlphabets.letters, 2, gapBefore: true),
      _Field('last', GibraltarAlphabets.digits, 2, gapBefore: true),
    ],
    left: _Layout.plainLeft,
    right: _Layout.plainRight,
    banded: false,
  );
}
