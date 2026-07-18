import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bar_review.dart';
import '../storage/bar_review_storage.dart';

class BarReviewNotifier extends Notifier<Map<String, BarReview>> {
  @override
  Map<String, BarReview> build() {
    _load();

    return {};
  }

  Future<void> clearReviews() async {
    await BarReviewStorage.clear();

    state = {};
  }

  Future<void> _load() async {
    final saved = await BarReviewStorage.load();

    state = saved;
  }

  // Bewertung einer Bar holen
  BarReview getReview(String barId) {
    return state[barId] ?? BarReview(barId: barId);
  }

  // komplette Bewertung setzen
  void updateReview(BarReview review) {
    state = {...state, review.barId: review};

    BarReviewStorage.save(state);
  }

  // einzelne Kategorie ändern

  void updateCategory({
    required String barId,
    required String category,
    required double value,
  }) {
    final current = getReview(barId);

    BarReview updated;

    switch (category) {
      case 'location':
        updated = current.copyWith(location: value);
        break;

      case 'atmosphere':
        updated = current.copyWith(atmosphere: value);
        break;

      case 'price':
        updated = current.copyWith(price: value);
        break;

      case 'drinks':
        updated = current.copyWith(drinks: value);
        break;

      case 'service':
        updated = current.copyWith(service: value);
        break;

      default:
        return;
    }

    updateReview(updated);
  }

  // Texte ändern

  void updateTexts({
    required String barId,
    String? beerPrices,
    String? specials,
    String? notes,
  }) {
    final current = getReview(barId);

    updateReview(
      current.copyWith(
        beerPrices: beerPrices,
        specials: specials,
        notes: notes,
      ),
    );
  }
}

final barReviewProvider =
    NotifierProvider<BarReviewNotifier, Map<String, BarReview>>(
      BarReviewNotifier.new,
    );
