import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/bar_review.dart';

class BarReviewStorage {
  static const _key = 'bar_reviews';

  // Speichern
  static Future<void> save(Map<String, BarReview> reviews) async {
    final prefs = await SharedPreferences.getInstance();

    final data = reviews.map((barId, review) {
      return MapEntry(barId, {
        'location': review.location,
        'atmosphere': review.atmosphere,
        'price': review.price,
        'drinks': review.drinks,
        'service': review.service,

        'beerPrices': review.beerPrices,
        'specials': review.specials,
        'notes': review.notes,
      });
    });

    await prefs.setString(_key, jsonEncode(data));
  }

  // Laden
  static Future<Map<String, BarReview>> load() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_key);

    if (jsonString == null) {
      return {};
    }

    final Map<String, dynamic> decoded = jsonDecode(jsonString);

    return decoded.map((barId, value) {
      return MapEntry(
        barId,

        BarReview(
          barId: barId,

          location: (value['location'] ?? 0).toDouble(),

          atmosphere: (value['atmosphere'] ?? 0).toDouble(),

          price: (value['price'] ?? 0).toDouble(),

          drinks: (value['drinks'] ?? 0).toDouble(),

          service: (value['service'] ?? 0).toDouble(),

          beerPrices: value['beerPrices'] ?? '',

          specials: value['specials'] ?? '',

          notes: value['notes'] ?? '',
        ),
      );
    });
  }

  /// Alle gespeicherten Bewertungen und Notizen löschen
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
