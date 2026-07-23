import 'package:shared_preferences/shared_preferences.dart';

class DeviceIdStorage {
  static const _key = 'device_id';

  Future<String?> loadDeviceId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_key);
  }

  Future<void> saveDeviceId(String id) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_key, id);
  }
}
