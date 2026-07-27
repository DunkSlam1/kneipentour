import '../models/bar.dart';
import '../utils/kneipen_day_helper.dart';

enum OpeningState { open, closed }

class OpeningStatus {
  final OpeningState state;
  final String text;

  const OpeningStatus({required this.state, required this.text});
}

class OpeningStatusHelper {
  static DateTime _getKneipenNow() {
    return KneipenDayHelper.normalize(DateTime.now());
  }

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

    final current = KneipenDayHelper.currentMinutes();

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

    final current = KneipenDayHelper.currentMinutes();

    // Öffnungszeit heute bereits vorbei
    if (open <= current) {
      return "";
    }

    final remaining = open - current;

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

    final current = KneipenDayHelper.currentMinutes();

    int adjustedClose = close;

    if (close <= open) {
      adjustedClose += 24 * 60;
    }

    return current >= open && current < adjustedClose;
  }

  static bool isOpenToday(OpeningHours? openingHours) {
    if (openingHours == null) {
      return false;
    }

    final now = _getKneipenNow();
    final weekday = getGermanWeekday(now);

    final today = openingHours.weekly[weekday];

    if (today == null || today.isEmpty) {
      return false;
    }

    if (today.first == "geschlossen") {
      return false;
    }

    return true;
  }

  static OpeningStatus getStatus(OpeningHours? openingHours) {
    if (openingHours == null) {
      return const OpeningStatus(
        state: OpeningState.closed,
        text: "Keine Öffnungszeiten",
      );
    }

    final now = _getKneipenNow();
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

    // 3. GESCHLOSSEN → prüfen ob heute noch eine Öffnung kommt
    final todayData = openingHours.weekly[weekday];

    if (todayData != null &&
        todayData.isNotEmpty &&
        todayData.first != "geschlossen") {
      for (final range in todayData) {
        final parts = range.split('-');

        if (parts.length != 2) continue;

        final open = _parseTime(parts[0]);
        final close = _parseTime(parts[1]);

        final current = now.hour * 60 + now.minute;

        // zukünftige Öffnung heute
        if (current < open) {
          final text = _getOpeningInText(range);

          return OpeningStatus(
            state: OpeningState.closed,
            text: text.isNotEmpty ? "Geschlossen • $text" : "Geschlossen",
          );
        }

        // Öffnung heute vorbei
        if (current >= close && close > open) {
          continue;
        }
      }
    }

    return const OpeningStatus(state: OpeningState.closed, text: "Geschlossen");
  }
}
