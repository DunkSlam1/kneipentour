import 'dart:math';

import '../../bars/models/bar.dart';
import '../../bars/utils/opening_status.dart';
import '../models/bar_pick_filter.dart';

class BarPickerService {
  List<Bar> getCandidates(
    List<Bar> bars,
    BarPickFilter filter, {
    bool onlyUnvisited = false,
  }) {
    var candidates = switch (filter) {
      BarPickFilter.all => bars,

      BarPickFilter.openNow => bars.where((bar) {
        final status = OpeningStatusHelper.getStatus(bar.openingHours);

        return status.state == OpeningState.open;
      }).toList(),

      BarPickFilter.openToday => bars.where((bar) {
        // deine bestehende Logik bleibt hier
        return true;
      }).toList(),

      BarPickFilter.unvisited => bars.where((bar) {
        return !bar.visited;
      }).toList(),
    };

    if (onlyUnvisited) {
      candidates = candidates.where((bar) {
        return !bar.visited;
      }).toList();
    }

    return candidates;
  }

  Bar? pickRandomBar(
    List<Bar> bars,
    BarPickFilter filter, {
    bool onlyUnvisited = false,
  }) {
    final candidates = getCandidates(
      bars,
      filter,
      onlyUnvisited: onlyUnvisited,
    );

    if (candidates.isEmpty) {
      return null;
    }

    final random = Random();

    return candidates[random.nextInt(candidates.length)];
  }
}
