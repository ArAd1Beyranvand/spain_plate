import 'package:plate_alphabet/plate_alphabet.dart';
import 'package:plate_core/plate_core.dart';

/// Judges a Spanish plate. A registration is four digits and three consonants
/// (`1234 BCD`); a diplomatic plate is a prefix from [SpainAlphabets.diplomaticCodes],
/// one to three digits for the embassy or organisation, and three digits.
/// Reports, never bars a keystroke; the one refusal is the restriction the
/// diplomatic specs carry.
class SpainValidator extends GatedPlateValidator {
  const SpainValidator();

  @override
  String get gateGroup => 'number';

  static const String reasonNumber = 'The number is four digits.';
  static const String reasonLetters = 'The counter is three consonants (no vowels, no Q).';
  static const String reasonCode = 'The prefix is CD, CC, TA or OI.';
  static const String reasonEmbassy = 'The embassy code is one to three digits.';
  static const String reasonCar = 'The car number is three digits.';

  static final RegExp _consonants = RegExp(r'^[BCDFGHJKLMNPRSTVWXYZ]{3}$');

  @override
  PlateValidation judge(PlateEntry entry) {
    final String code = entry.group('code');
    if (code.isNotEmpty) {
      if (!SpainAlphabets.diplomaticCodes.contains(code)) {
        return const PlateValidation.invalid(reasonCode);
      }
      final String embassy = entry.group('embassy');
      if (!isDigits(embassy) || embassy.length > 3) {
        return const PlateValidation.invalid(reasonEmbassy);
      }
      if (!isDigitsOfLength(entry.group('number'), 3)) {
        return const PlateValidation.invalid(reasonCar);
      }
      return const PlateValidation.valid();
    }
    if (!isDigitsOfLength(entry.group('number'), 4)) {
      return const PlateValidation.invalid(reasonNumber);
    }
    if (!_consonants.hasMatch(entry.group('letters'))) {
      return const PlateValidation.invalid(reasonLetters);
    }
    return const PlateValidation.valid();
  }
}
