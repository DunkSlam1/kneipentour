import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/bar_storage.dart';
import '../storage/bar_review_storage.dart';

import '../repositories/bar_data_repository.dart';
import '../repositories/bar_review_data_repository.dart';

final barStorageProvider = Provider<BarStorage>((ref) {
  return BarStorage();
});

final barReviewStorageProvider = Provider<BarReviewStorage>((ref) {
  return BarReviewStorage();
});

final barDataRepositoryProvider = Provider<BarDataRepository>((ref) {
  return BarDataRepository(ref.read(barStorageProvider));
});

final barReviewDataRepositoryProvider = Provider<BarReviewDataRepository>((
  ref,
) {
  return BarReviewDataRepository(ref.read(barReviewStorageProvider));
});
