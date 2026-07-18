// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/bar.dart';
import '../utils/kneipen_day_helper.dart';

class OpeningHoursSection extends StatelessWidget {
  final OpeningHours? openingHours;

  const OpeningHoursSection({super.key, required this.openingHours});

  @override
  Widget build(BuildContext context) {
    if (openingHours == null) {
      return const SizedBox.shrink();
    }

    final daysOrder = [
      "Montag",
      "Dienstag",
      "Mittwoch",
      "Donnerstag",
      "Freitag",
      "Samstag",
      "Sonntag",
    ];

    String formatTimes(List<String>? times) {
      if (times == null || times.isEmpty) {
        return "geschlossen";
      }

      return times.join(", ");
    }

    String shortDay(String day) {
      switch (day) {
        case "Montag":
          return "Mo";
        case "Dienstag":
          return "Di";
        case "Mittwoch":
          return "Mi";
        case "Donnerstag":
          return "Do";
        case "Freitag":
          return "Fr";
        case "Samstag":
          return "Sa";
        case "Sonntag":
          return "So";
        default:
          return day;
      }
    }

    final today = KneipenDayHelper.currentWeekday();

    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 8),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "🕒 Öffnungszeiten",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ...daysOrder.map((day) {
              final times = openingHours!.weekly[day];

              final isToday = day == today;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2),

                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),

                decoration: BoxDecoration(
                  color: isToday ? Colors.amber.withOpacity(0.15) : null,

                  borderRadius: BorderRadius.circular(6),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      children: [
                        Text(
                          shortDay(day),
                          style: TextStyle(
                            fontWeight: isToday
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),

                        if (isToday)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),

                            child: Text(
                              "Heute",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),

                    Text(
                      formatTimes(times),
                      style: TextStyle(
                        fontWeight: isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
