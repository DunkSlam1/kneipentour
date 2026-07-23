import 'package:shared_preferences/shared_preferences.dart';

class SyncStorage {
  static const _tourIdKey = 'sync_tour_id';

  Future<String?> loadTourId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_tourIdKey);
  }

  Future<void> saveTourId(String tourId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tourIdKey, tourId);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_tourIdKey);
  }
}
