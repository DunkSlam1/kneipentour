import '../../bars/models/bar_user_data.dart';
import '../../bars/models/bar_review_data.dart';

class SyncPayload {
  final Map<String, BarUserData> bars;
  final Map<String, BarReviewData> reviews;

  const SyncPayload({required this.bars, required this.reviews});
}
