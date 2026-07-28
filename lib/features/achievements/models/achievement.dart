enum AchievementCategory { progress, explorer, collector, discovery, special }

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;

  final AchievementCategory category;

  final int requiredValue;
  final int currentValue;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.requiredValue,
    this.currentValue = 0,
  });

  bool get isUnlocked => currentValue >= requiredValue;

  double get progress {
    if (requiredValue == 0) return 1;

    return (currentValue / requiredValue).clamp(0, 1);
  }
}
