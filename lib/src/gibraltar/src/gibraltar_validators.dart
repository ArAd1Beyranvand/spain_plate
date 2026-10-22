import 'package:plate_core/plate_core.dart';

/// Quiet until something is typed, then every field must reach its minimum
/// length. The `prefix` is `G`, or `GT` on a trailer plate.
class GibraltarValidator extends PlateValidator {
  const GibraltarValidator();

  @override
  PlateValidation validate(PlateEntry entry) {
    final PlateValidation? refused = restrictionVerdict(entry);
    if (refused != null) return refused;
    if (entry.values.every((String? v) => v == null || v.isEmpty)) {
      return const PlateValidation.valid();
    }
    for (final PlateTextGroup g in entry.spec.effectiveTextGroups) {
      for (final int i in g.indices) {
        final PlateSlot? slot = entry.spec.slotAt(i);
        final String value = i < entry.values.length ? (entry.values[i] ?? '') : '';
        if (slot != null && !slot.isComplete(value)) {
          return PlateValidation.invalid('The ${g.key ?? 'field'} is incomplete.');
        }
        if (g.key == 'prefix' && value != 'G' && value != 'GT') {
          return const PlateValidation.invalid('The prefix is G or GT.');
        }
        if (g.key == 'serial' &&
            entry.spec.id == 'gi.private' &&
            value.length == 4 &&
            value.startsWith('0')) {
          return const PlateValidation.invalid('A four-digit serial runs 1000 to 9999.');
        }
      }
    }
    return const PlateValidation.valid();
  }
}
