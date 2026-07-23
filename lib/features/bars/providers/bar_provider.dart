import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bar.dart';
import '../repositories/bar_repository.dart';
import '../utils/opening_status.dart';
import '../utils/kneipen_day_helper.dart';
import 'storage_provider.dart';
import '../repositories/bar_data_repository.dart';
import '../models/bar_user_data.dart';
import '../../sync/providers/sync_service_provider.dart';
import '../../sync/services/sync_service.dart';

enum BarSortMode {
  alphabetical,
  ratingDesc,
  ratingAsc,
  openTimeDesc,
  openTimeAsc,
}

enum BarFilterMode { all, openOnly }

class BarNotifier extends Notifier<List<Bar>> {
  BarSortMode _sortMode = BarSortMode.alphabetical;
  BarFilterMode _filterMode = BarFilterMode.all;

  BarSortMode get sortMode => _sortMode;
  BarFilterMode get filterMode => _filterMode;

  final Map<String, Bar> _stateMap = {};
  late final List<Bar> _baseBars = List.from(BarRepository.bars);
  late final BarDataRepository _repository;
  late final SyncService _syncService;

  Timer? _timer;

  @override
  List<Bar> build() {
    _repository = ref.read(barDataRepositoryProvider);
    _syncService = ref.read(syncServiceProvider);

    _startTimer();
    load();

    ref.onDispose(() {
      _timer?.cancel();
    });

    return _applyPipeline(_baseBars);
  }

  // ---------------------------
  // LIVE TIMER
  // ---------------------------

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      state = _applyPipeline(_stateMap.values.toList());
    });
  }

  // ---------------------------
  // LOAD / SAVE
  // ---------------------------

  Future<void> load() async {
    final saved = await _repository.load();

    for (final bar in _baseBars) {
      final data = saved[bar.id];

      _stateMap[bar.id] = bar.copyWith(
        visited: data?.visited ?? false,
        favorite: data?.favorite ?? false,
        rating: data?.rating ?? bar.rating,
        visitedAt: data?.visitedAt,
      );
    }

    state = _applyPipeline(_stateMap.values.toList());
  }

  Future<void> _save() async {
    final userData = {
      for (final bar in _stateMap.values)
        bar.id: BarUserData(
          barId: bar.id,
          visited: bar.visited,
          favorite: bar.favorite,
          rating: bar.rating,
          visitedAt: bar.visitedAt,
        ),
    };

    await _repository.save(userData);
  }

  // ---------------------------
  // PUBLIC CONTROL
  // ---------------------------

  void setSortMode(BarSortMode mode) {
    _sortMode = mode;
    state = _applyPipeline(_stateMap.values.toList());
  }

  void setFilterMode(BarFilterMode mode) {
    _filterMode = mode;
    state = _applyPipeline(_stateMap.values.toList());
  }

  // ---------------------------
  // ACTIONS
  // ---------------------------

  Future<void> clearPersonalData() async {
    await _repository.clear();

    for (final bar in _baseBars) {
      _stateMap[bar.id] = bar.copyWith(
        visited: false,
        favorite: false,
        rating: bar.rating,
        visitedAt: null,
      );
    }

    state = _applyPipeline(_stateMap.values.toList());
  }

  void toggleVisited(String id) {
    final bar = _stateMap[id];
    if (bar == null) return;

    _stateMap[id] = bar.copyWith(
      visited: !bar.visited,
      visitedAt: !bar.visited ? KneipenDayHelper.now() : null,
    );

    state = _applyPipeline(_stateMap.values.toList());

    _save();
    _syncService.notifyDataChanged();
  }

  void toggleFavorite(String id) {
    final bar = _stateMap[id];
    if (bar == null) return;

    _stateMap[id] = bar.copyWith(favorite: !bar.favorite);

    state = _applyPipeline(_stateMap.values.toList());
    _save();
    _syncService.notifyDataChanged();
  }

  void setRating(String id, double rating) {
    final bar = _stateMap[id];
    if (bar == null) return;

    _stateMap[id] = bar.copyWith(rating: rating);

    state = _applyPipeline(_stateMap.values.toList());

    _save();
    _syncService.notifyDataChanged();
  }

  void setVisitedDate(String id, DateTime date) {
    final bar = _stateMap[id];
    if (bar == null) return;

    _stateMap[id] = bar.copyWith(visitedAt: date);

    state = _applyPipeline(_stateMap.values.toList());

    _save();
    _syncService.notifyDataChanged();
  }

  Bar getById(String id) {
    return _stateMap[id] ?? _baseBars.firstWhere((b) => b.id == id);
  }

  // ---------------------------
  // PIPELINE
  // ---------------------------

  List<Bar> _applyPipeline(List<Bar> bars) {
    final filtered = _applyFilter(bars);
    return _applySort(filtered);
  }

  // ---------------------------
  // FILTER
  // ---------------------------

  List<Bar> _applyFilter(List<Bar> bars) {
    switch (_filterMode) {
      case BarFilterMode.all:
        return bars;

      case BarFilterMode.openOnly:
        return bars.where(_isOpen).toList();
    }
  }

  // ---------------------------
  // SORT
  // ---------------------------

  List<Bar> _applySort(List<Bar> bars) {
    final sorted = [...bars];

    switch (_sortMode) {
      case BarSortMode.alphabetical:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;

      case BarSortMode.ratingDesc:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;

      case BarSortMode.ratingAsc:
        sorted.sort((a, b) => a.rating.compareTo(b.rating));
        break;

      case BarSortMode.openTimeAsc:
        sorted.sort((a, b) {
          final aVal = _minutesUntilClose(a) ?? 999999;
          final bVal = _minutesUntilClose(b) ?? 999999;
          return aVal.compareTo(bVal);
        });
        break;

      case BarSortMode.openTimeDesc:
        sorted.sort((a, b) {
          final aVal = _minutesUntilClose(a) ?? 0;
          final bVal = _minutesUntilClose(b) ?? 0;
          return bVal.compareTo(aVal);
        });
        break;
    }

    return sorted;
  }

  // ---------------------------
  // OPEN STATUS HELPERS
  // ---------------------------

  bool _isOpen(Bar bar) => _minutesUntilClose(bar) != null;

  int? _minutesUntilClose(Bar bar) {
    final opening = bar.openingHours;
    if (opening == null) return null;

    final now = DateTime.now();
    final weekday = OpeningStatusHelper.getGermanWeekday(now);

    final today = opening.weekly[weekday];
    if (today == null || today.isEmpty || today.first == "geschlossen") {
      return null;
    }

    final current = now.hour * 60 + now.minute;

    for (final range in today) {
      final parts = range.split('-');
      if (parts.length != 2) continue;

      final open = _parse(parts[0]);
      final close = _parse(parts[1]);

      if (close > open) {
        if (current >= open && current < close) {
          return close - current;
        }
      } else {
        if (current >= open || current < close) {
          return current < close
              ? close - current
              : (24 * 60 - current) + close;
        }
      }
    }

    return null;
  }

  int _parse(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}

final barProvider = NotifierProvider<BarNotifier, List<Bar>>(BarNotifier.new);
