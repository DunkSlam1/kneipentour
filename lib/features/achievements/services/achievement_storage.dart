import 'package:shared_preferences/shared_preferences.dart';

class AchievementStorage {
  static const _key = 'seen_achievement_ids';

  Future<Set<String>> loadSeenAchievements() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_key)?.toSet() ?? {};
  }

  Future<void> markAsSeen(String achievementId) async {
    final prefs = await SharedPreferences.getInstance();

    final current = await loadSeenAchievements();

    current.add(achievementId);

    await prefs.setStringList(_key, current.toList());
  }

  Future<bool> hasBeenSeen(String achievementId) async {
    final seen = await loadSeenAchievements();

    return seen.contains(achievementId);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
