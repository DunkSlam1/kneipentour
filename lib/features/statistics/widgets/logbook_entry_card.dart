import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bars/models/bar.dart';
import '../../bars/providers/bar_provider.dart';
import 'edit_visit_date_dialog.dart';

class LogbookEntryCard extends ConsumerWidget {
  final Bar bar;

  const LogbookEntryCard({super.key, required this.bar});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // 📅 Erstbesuch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bar.visitedAt != null
                      ? 'Erstbesuch: ${_formatDate(bar.visitedAt!)}'
                      : 'Kein Erstbesuch gespeichert',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),

                IconButton(
                  icon: const Icon(Icons.edit_calendar),
                  tooltip: bar.visitedAt != null
                      ? 'Erstbesuch ändern'
                      : 'Erstbesuch hinzufügen',

                  onPressed: () async {
                    final date = await showDialog<DateTime>(
                      context: context,
                      builder: (context) =>
                          EditVisitDateDialog(initialDate: bar.visitedAt),
                    );

                    if (date != null) {
                      ref
                          .read(barProvider.notifier)
                          .setVisitedDate(bar.id, date);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 🍺 Name
            Text(
              bar.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            // 📍 Adresse
            Text(bar.address),

            const SizedBox(height: 12),

            // ⭐ Bewertung
            if (bar.rating > 0)
              Row(
                children: List.generate(5, (index) {
                  final starValue = index + 1.0;

                  IconData icon;

                  if (bar.rating >= starValue) {
                    icon = Icons.star;
                  } else if (bar.rating >= starValue - 0.5) {
                    icon = Icons.star_half;
                  } else {
                    icon = Icons.star_border;
                  }

                  return Icon(icon, size: 20, color: Colors.amber);
                }),
              )
            else
              const Text(
                'Noch nicht bewertet',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');

    final month = date.month.toString().padLeft(2, '0');

    final year = date.year;

    return '$day.$month.$year';
  }
}
