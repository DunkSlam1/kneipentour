import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bars/repositories/bar_data_repository.dart';
import '../../bars/repositories/bar_review_data_repository.dart';
import '../../bars/providers/storage_provider.dart';
import '../models/sync_payload.dart';
import '../providers/sync_provider.dart';
import '../../bars/models/bar_user_data.dart';
import '../../bars/models/bar_review_data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../bars/providers/bar_provider.dart';
import '../../bars/providers/bar_review_provider.dart';

class SyncService {
  SyncService(this.ref) {
    _barRepository = ref.read(barDataRepositoryProvider);
    _reviewRepository = ref.read(barReviewDataRepositoryProvider);
  }

  final Ref ref;

  bool _isDownloading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Timer? _timer;

  late final BarDataRepository _barRepository;
  late final BarReviewDataRepository _reviewRepository;

  void notifyDataChanged() {
    _timer?.cancel();

    _timer = Timer(const Duration(seconds: 2), () {
      _syncNow();
    });
  }

  Future<void> _syncNow() async {
    if (_isDownloading) {
      print('Download läuft - kein Upload');
      return;
    }
    final syncConfig = await ref.read(syncProvider.future);

    if (!syncConfig.isConnected) {
      print('Keine Tour verbunden - kein Upload');
      return;
    }

    print('Aktuelle Tour: ${syncConfig.tourId}');

    final bars = await _barRepository.load();

    final reviews = await _reviewRepository.load();

    final payload = SyncPayload(bars: bars, reviews: reviews);

    print('Sync-Paket erstellt');
    print('Bars: ${payload.bars.length}');
    print('Reviews: ${payload.reviews.length}');

    try {
      final batch = _firestore.batch();
      final tourDoc = _firestore.collection('tours').doc(syncConfig.tourId);

      batch.set(tourDoc, {
        'bars': payload.bars.length,
        'reviews': payload.reviews.length,
        'lastChangedBy': syncConfig.deviceId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      for (final bar in payload.bars.values) {
        final doc = tourDoc.collection('bars').doc(bar.barId);

        batch.set(doc, bar.toJson());
      }

      for (final review in payload.reviews.values) {
        final doc = tourDoc.collection('reviews').doc(review.barId);

        batch.set(doc, review.toJson());
      }

      await batch.commit();

      print('${payload.bars.length} Bars synchronisiert');
      print('${payload.reviews.length} Reviews synchronisiert');
      print('Firestore-Test erfolgreich');
    } catch (e) {
      print('Firestore-Fehler: $e');
    }
  }

  Future<void> downloadBars() async {
    _isDownloading = true;

    try {
      final syncConfig = await ref.read(syncProvider.future);

      if (syncConfig.tourId == null) {
        return;
      }

      final snapshot = await _firestore
          .collection('tours')
          .doc(syncConfig.tourId)
          .collection('bars')
          .get();

      final Map<String, BarUserData> bars = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();

        bars[doc.id] = BarUserData.fromJson({...data, 'barId': doc.id});
      }

      await _barRepository.save(bars);
      await ref.read(barProvider.notifier).reload();

      if (bars.isNotEmpty) {}

      print('${bars.length} Bars aus Firebase geladen');
    } finally {
      _isDownloading = false;
    }
  }

  Future<void> downloadReviews() async {
    _isDownloading = true;

    try {
      final syncConfig = await ref.read(syncProvider.future);

      if (syncConfig.tourId == null) {
        return;
      }

      final snapshot = await _firestore
          .collection('tours')
          .doc(syncConfig.tourId)
          .collection('reviews')
          .get();

      final Map<String, BarReviewData> reviews = {};

      for (final doc in snapshot.docs) {
        reviews[doc.id] = BarReviewData.fromJson(doc.id, doc.data());
      }

      await _reviewRepository.save(reviews);

      await ref.read(barReviewProvider.notifier).reload();

      print('${reviews.length} Reviews aus Firebase geladen');
    } finally {
      _isDownloading = false;
    }
  }

  Future<void> syncOnStartup() async {
    final syncConfig = await ref.read(syncProvider.future);

    if (!syncConfig.isConnected) {
      print('Keine Tour verbunden - kein Sync');
      return;
    }

    print('Starte Synchronisation für ${syncConfig.tourId}');

    print('Fremde Änderung - lade Daten');

    await downloadBars();
    await downloadReviews();

    print('Daten aus Firebase aktualisiert');

    await startRealtimeSync();

    print('Startup-Sync abgeschlossen');
  }

  StreamSubscription<DocumentSnapshot>? _tourListener;

  Future<void> startRealtimeSync() async {
    final syncConfig = await ref.read(syncProvider.future);

    if (!syncConfig.isConnected) {
      print('Kein Live-Sync - keine Tour verbunden');
      return;
    }

    _tourListener?.cancel();

    _tourListener = _firestore
        .collection('tours')
        .doc(syncConfig.tourId)
        .snapshots()
        .listen((event) async {
          if (_isDownloading) {
            print('Download läuft bereits - ignoriere Event');
            return;
          }

          if (!event.exists) {
            return;
          }

          final data = event.data();

          if (data == null) {
            return;
          }

          final changedBy = data['lastChangedBy'];

          print('🔥 Änderung erkannt von: $changedBy');

          // eigene Änderung ignorieren
          if (changedBy == syncConfig.deviceId) {
            print('Eigene Änderung - ignoriere');
            return;
          }

          // Änderung von anderem Gerät übernehmen
          // Änderung von anderem Gerät übernehmen
          print('Fremde Änderung - lade Daten');

          await downloadBars();
          await downloadReviews();
        });

    print('Live-Sync gestartet');
  }
}
