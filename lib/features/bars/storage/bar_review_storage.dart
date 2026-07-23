import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/bar_review_data.dart';

class BarReviewStorage {
  static const _key = 'bar_reviews';

  // Speichern
  Future<void> save(Map<String, BarReviewData> reviews) async {
    final prefs = await SharedPreferences.getInstance();

    final data = reviews.map((barId, review) {
      return MapEntry(barId, review.toJson());
    });

    await prefs.setString(_key, jsonEncode(data));
  }

  // Laden
  Future<Map<String, BarReviewData>> load() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_key);

    if (jsonString == null) {
      return {};
    }

    final Map<String, dynamic> decoded = jsonDecode(jsonString);

    return decoded.map((barId, value) {
      return MapEntry(barId, BarReviewData.fromJson(barId, value));
    });
  }

  /// Alle gespeicherten Bewertungen und Notizen löschen
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
