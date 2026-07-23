import '../../bars/models/bar_user_data.dart';
import '../../bars/models/bar_review_data.dart';

class SyncDataRepository {
  Future<void> saveBarData(
    String tourId,
    Map<String, BarUserData> data,
  ) async {}

  Future<Map<String, BarUserData>> loadBarData(String tourId) async {
    return {};
  }

  Future<void> saveReviews(
    String tourId,
    Map<String, BarReviewData> reviews,
  ) async {}

  Future<Map<String, BarReviewData>> loadReviews(String tourId) async {
    return {};
  }
}
