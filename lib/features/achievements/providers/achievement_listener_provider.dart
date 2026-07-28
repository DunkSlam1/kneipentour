import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/achievement.dart';
import 'achievement_provider.dart';
import 'achievement_service_provider.dart';

final achievementListenerProvider = Provider<AchievementListener>((ref) {
  return AchievementListener(ref);
});

class AchievementListener {
  final Ref ref;

  AchievementListener(this.ref);

  Future<List<Achievement>> checkForNewAchievements() async {
    final achievements = ref.read(achievementProvider);

    final service = ref.read(achievementServiceProvider);

    return await service.getNewAchievements(achievements);
  }

  Future<void> markAsSeen(Achievement achievement) async {
    final service = ref.read(achievementServiceProvider);

    await service.markAsSeen(achievement);
  }
}
