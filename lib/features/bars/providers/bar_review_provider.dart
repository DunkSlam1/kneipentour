import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bar_review_data.dart';
import '../repositories/bar_review_data_repository.dart';
import 'storage_provider.dart';

import '../../sync/providers/sync_service_provider.dart';
import '../../sync/services/sync_service.dart';

class BarReviewNotifier extends Notifier<Map<String, BarReviewData>> {
  late final BarReviewDataRepository _repository;
  late final SyncService _syncService;

  @override
  Map<String, BarReviewData> build() {
    _repository = ref.read(barReviewDataRepositoryProvider);
    _syncService = ref.read(syncServiceProvider);

    _load();

    return {};
  }

  Future<void> clearReviews() async {
    await _repository.clear();

    state = {};
  }

  Future<void> reload() async {
    await _load();
  }

  Future<void> _load() async {
    final saved = await _repository.load();

    state = saved;
  }

  // Bewertung einer Bar holen
  BarReviewData getReview(String barId) {
    return state[barId] ?? BarReviewData(barId: barId);
  }

  // komplette Bewertung setzen
  void updateReview(BarReviewData review) {
    state = {...state, review.barId: review};

    _repository.save(state);

    _syncService.notifyDataChanged();
  }

  // einzelne Kategorie ändern

  void updateCategory({
    required String barId,
    required String category,
    required double value,
  }) {
    final current = getReview(barId);

    BarReviewData updated;

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
    NotifierProvider<BarReviewNotifier, Map<String, BarReviewData>>(
      BarReviewNotifier.new,
    );
