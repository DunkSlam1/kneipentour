import '../models/achievement.dart';
import 'achievement_storage.dart';

class AchievementService {
  final AchievementStorage _storage;

  AchievementService({AchievementStorage? storage})
    : _storage = storage ?? AchievementStorage();

  Future<List<Achievement>> getNewAchievements(
    List<Achievement> achievements,
  ) async {
    final newAchievements = <Achievement>[];

    for (final achievement in achievements) {
      if (!achievement.isUnlocked) {
        continue;
      }

      final seen = await _storage.hasBeenSeen(achievement.id);

      if (!seen) {
        newAchievements.add(achievement);
      }
    }

    return newAchievements;
  }

  Future<void> markAsSeen(Achievement achievement) async {
    await _storage.markAsSeen(achievement.id);
  }
}
