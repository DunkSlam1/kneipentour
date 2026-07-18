import '../models/bar.dart';

enum OpeningState { open, closed }

class OpeningStatus {
  final OpeningState state;
  final String text;

  const OpeningStatus({required this.state, required this.text});
}

class OpeningStatusHelper {
  static String getGermanWeekday(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return "Montag";
      case DateTime.tuesday:
        return "Dienstag";
      case DateTime.wednesday:
        return "Mittwoch";
      case DateTime.thursday:
        return "Donnerstag";
      case DateTime.friday:
        return "Freitag";
      case DateTime.saturday:
        return "Samstag";
      case DateTime.sunday:
        return "Sonntag";
      default:
        throw Exception("Ungültiger Wochentag");
    }
  }

  static int _parseTime(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  static String _formatTime(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;

    final hh = h.toString().padLeft(2, '0');
    final mm = m.toString().padLeft(2, '0');

    return "$hh:$mm";
  }

  static String _getClosingInText(String range) {
    final parts = range.split('-');
    if (parts.length != 2) return "";

    final open = _parseTime(parts[0]);
    final close = _parseTime(parts[1]);

    final now = DateTime.now();
    final current = now.hour * 60 + now.minute;

    int remaining;

    if (close > open) {
      remaining = close - current;
    } else {
      remaining = current < close
          ? close - current
          : (24 * 60 - current) + close;
    }

    if (remaining <= 0) return "";

    if (remaining < 60) {
      return "schließt in $remaining Min";
    }

    return "schließt um ${_formatTime(close)}";
  }

  static String _getOpeningInText(String range) {
    final parts = range.split('-');
    if (parts.length != 2) return "";

    final open = _parseTime(parts[0]);

    final now = DateTime.now();
    final current = now.hour * 60 + now.minute;

    int remaining = open - current;

    if (remaining < 0) {
      remaining = (24 * 60 - current) + open;
    }

    if (remaining < 60) {
      return "öffnet in $remaining Min";
    }

    return "öffnet um ${_formatTime(open)}";
  }

  static bool _isOpenNow(String range) {
    final parts = range.split('-');
    if (parts.length != 2) return false;

    final open = _parseTime(parts[0]);
    final close = _parseTime(parts[1]);

    final now = DateTime.now();
    final current = now.hour * 60 + now.minute;

    if (close > open) {
      return current >= open && current < close;
    }

    return current >= open || current < close;
  }

  static OpeningStatus getStatus(OpeningHours? openingHours) {
    if (openingHours == null) {
      return const OpeningStatus(
        state: OpeningState.closed,
        text: "Keine Öffnungszeiten",
      );
    }

    final now = DateTime.now();
    final weekday = getGermanWeekday(now);

    final today = openingHours.weekly[weekday];

    // 1. HEUTE prüfen
    if (today != null && today.isNotEmpty && today.first != "geschlossen") {
      for (final range in today) {
        if (_isOpenNow(range)) {
          final text = _getClosingInText(range);

          return OpeningStatus(
            state: OpeningState.open,
            text: text.isNotEmpty ? "Geöffnet • $text" : "Geöffnet",
          );
        }
      }
    }

    // 2. VORTAG prüfen (Mitternacht)
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayWeekday = getGermanWeekday(yesterday);

    final prev = openingHours.weekly[yesterdayWeekday];

    if (prev != null && prev.isNotEmpty && prev.first != "geschlossen") {
      for (final range in prev) {
        final parts = range.split('-');
        if (parts.length != 2) continue;

        final open = _parseTime(parts[0]);
        final close = _parseTime(parts[1]);

        if (close < open) {
          final current = now.hour * 60 + now.minute;

          if (current < close) {
            final text = _getClosingInText(range);

            return OpeningStatus(
              state: OpeningState.open,
              text: text.isNotEmpty ? "Geöffnet • $text" : "Geöffnet",
            );
          }
        }
      }
    }

    // 3. GESCHLOSSEN → nächstes Öffnen
    final nextDays = [now, now.add(const Duration(days: 1))];

    for (final day in nextDays) {
      final weekday = getGermanWeekday(day);
      final data = openingHours.weekly[weekday];

      if (data == null || data.isEmpty || data.first == "geschlossen") {
        continue;
      }

      final range = data.first;
      final text = _getOpeningInText(range);

      return OpeningStatus(
        state: OpeningState.closed,
        text: text.isNotEmpty ? "Geschlossen • $text" : "Geschlossen",
      );
    }

    return const OpeningStatus(state: OpeningState.closed, text: "Geschlossen");
  }
}
