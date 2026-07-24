import 'section_layout.dart';

class SectionLayoutCalculator {
  const SectionLayoutCalculator();

  Map<SectionLayout, double> calculate({
    required double availableHeight,
    required List<SectionLayout> sections,
  }) {
    final result = <SectionLayout, double>{};

    double remainingHeight = availableHeight;

    SectionLayout? flexibleSection;

    // 1. Normale Sections berechnen
    for (final section in sections) {
      if (section.fillRemainingSpace) {
        flexibleSection = section;
        continue;
      }

      var height = availableHeight * section.targetPercent;

      // Mindesthöhe anwenden
      if (height < section.minHeight) {
        height = section.minHeight;
      }

      // Maximalhöhe anwenden
      if (section.maxHeight != null && height > section.maxHeight!) {
        height = section.maxHeight!;
      }

      result[section] = height;
      remainingHeight -= height;
    }

    // 2. Rest an flexible Section geben
    if (flexibleSection != null) {
      var height = remainingHeight;

      if (height < flexibleSection.minHeight) {
        height = flexibleSection.minHeight;
      }

      if (flexibleSection.maxHeight != null &&
          height > flexibleSection.maxHeight!) {
        height = flexibleSection.maxHeight!;
      }

      result[flexibleSection] = height;
    }

    return result;
  }
}
