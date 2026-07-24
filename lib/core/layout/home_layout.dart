import 'section_layout.dart';

class HomeLayout {
  static const progress = SectionLayout(
    targetPercent: 0.10,
    minHeight: 70,
    maxHeight: 85,
  );

  static const lastVisited = SectionLayout(
    targetPercent: 0.10,
    minHeight: 70,
    maxHeight: 85,
  );

  static const discover = SectionLayout(
    targetPercent: 0.50,
    minHeight: 220,
    fillRemainingSpace: true,
  );

  static const topBars = SectionLayout(
    targetPercent: 0.20,
    minHeight: 110,
    maxHeight: 130,
  );
}
