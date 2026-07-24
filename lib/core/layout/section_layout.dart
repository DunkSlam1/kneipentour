class SectionLayout {
  /// Zielanteil der verfügbaren Höhe (z.B. 0.15 = 15%)
  final double targetPercent;

  /// Mindesthöhe, damit der Inhalt sinnvoll dargestellt werden kann
  final double minHeight;

  /// Maximale Höhe.
  /// null bedeutet: keine Begrenzung
  final double? maxHeight;

  /// Diese Section bekommt später den verbleibenden Platz
  final bool fillRemainingSpace;

  const SectionLayout({
    required this.targetPercent,
    required this.minHeight,
    this.maxHeight,
    this.fillRemainingSpace = false,
  });
}
