import '../models/bar_review_data.dart';
import '../storage/bar_review_storage.dart';

class BarReviewDataRepository {
  final BarReviewStorage _storage;

  BarReviewDataRepository(this._storage);

  Future<void> save(Map<String, BarReviewData> reviews) {
    return _storage.save(reviews);
  }

  Future<Map<String, BarReviewData>> load() {
    return _storage.load();
  }

  Future<void> clear() {
    return _storage.clear();
  }
}
