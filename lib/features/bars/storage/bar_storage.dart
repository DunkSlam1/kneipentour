import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/bar_user_data.dart';

class BarStorage {
  static const _key = 'bars_state';

  /// Speichern
  Future<void> save(Map<String, BarUserData> data) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonData = data.map((barId, userData) {
      return MapEntry(barId, userData.toJson());
    });

    await prefs.setString(_key, jsonEncode(jsonData));
  }

  /// Laden
  Future<Map<String, BarUserData>> load() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_key);

    if (jsonString == null) {
      return {};
    }

    final Map<String, dynamic> decoded = jsonDecode(jsonString);

    return decoded.map((barId, value) {
      return MapEntry(barId, BarUserData.fromJson(value));
    });
  }

  /// Alle gespeicherten persönlichen Bar-Daten löschen
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
