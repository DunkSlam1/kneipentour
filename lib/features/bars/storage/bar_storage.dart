import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/bar.dart';

class BarStorage {
  static const _key = 'bars_state';

  /// Speichern
  static Future<void> save(List<Bar> bars) async {
    final prefs = await SharedPreferences.getInstance();

    final data = bars
        .map(
          (b) => {
            'id': b.id,
            'visited': b.visited,
            'favorite': b.favorite,
            'rating': b.rating,
            'visitedAt': b.visitedAt?.toIso8601String(),
          },
        )
        .toList();

    await prefs.setString(_key, jsonEncode(data));
  }

  /// Laden
  static Future<Map<String, Map<String, dynamic>>> load() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_key);
    if (jsonString == null) return {};

    final List decoded = jsonDecode(jsonString);

    return {
      for (final item in decoded)
        item['id']: {
          'visited': item['visited'] ?? false,
          'favorite': item['favorite'] ?? false,
          'rating': (item['rating'] ?? 0.0).toDouble(),
          'visitedAt': item['visitedAt'] != null
              ? DateTime.parse(item['visitedAt'])
              : null,
        },
    };
  }

  /// Alle gespeicherten persönlichen Bar-Daten löschen
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
