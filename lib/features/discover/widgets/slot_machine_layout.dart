class SlotMachineLayout {
  final double width;
  final double height;

  const SlotMachineLayout({required this.width, required this.height});

  // Rahmen
  double get borderRadius => width * 0.06;

  double get outerBorder => width * 0.012;

  double get innerPadding => width * 0.025;

  // Bereiche der Maschine

  double get headerHeight => height * 0.14;

  double get windowTop => height * 0.18;

  double get windowHeight => height * 0.42;

  double get controlHeight => height * 0.20;

  double get footHeight => height * 0.05;

  // Dekoration

  double get ledSize => width * 0.025;
}
