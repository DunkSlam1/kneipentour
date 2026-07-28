import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bars/providers/bar_provider.dart';
import '../models/achievement.dart';
import '../services/achievement_definitions.dart';

final achievementProvider = Provider<List<Achievement>>((ref) {
  final bars = ref.watch(barProvider);

  final visitedCount = bars.where((bar) => bar.visited).length;

  final achievements = [
    ...AchievementDefinitions.visitedBarAchievements(bars.length),

    ...AchievementDefinitions.categoryAchievements(bars),

    ...AchievementDefinitions.personalAchievements(bars),
  ];

  return achievements.map((achievement) {
    var currentValue = achievement.currentValue;

    // Fortschrittserfolge: Anzahl besuchter Kneipen
    if (achievement.id.startsWith('visited_')) {
      currentValue = visitedCount;
    }

    return Achievement(
      id: achievement.id,
      title: achievement.title,
      description: achievement.description,
      icon: achievement.icon,
      category: achievement.category,
      requiredValue: achievement.requiredValue,
      currentValue: currentValue,
    );
  }).toList();
});
