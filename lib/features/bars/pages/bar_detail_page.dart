import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bar_provider.dart';
import '../widgets/opening_hours_section.dart';
import '../widgets/bar_review_section.dart';

class BarDetailPage extends ConsumerWidget {
  final String barId;

  const BarDetailPage({super.key, required this.barId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bar = ref.watch(barProvider).firstWhere((b) => b.id == barId);

    return Scaffold(
      appBar: AppBar(
        title: Text(bar.name),
        actions: [
          IconButton(
            icon: Icon(
              bar.favorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              ref.read(barProvider.notifier).toggleFavorite(bar.id);
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📍 Adresse
            Text(bar.address, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 8),

            Text('Stadtteil: ${bar.district}'),

            const SizedBox(height: 24),

            OpeningHoursSection(openingHours: bar.openingHours),

            const SizedBox(height: 24),

            const SizedBox(height: 24),

            // 🍺 Visited Status
            Row(
              children: [
                Icon(
                  bar.visited ? Icons.check_circle : Icons.circle_outlined,
                  color: bar.visited ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(bar.visited ? "Besucht 🍻" : "Noch nicht besucht"),
              ],
            ),

            const SizedBox(height: 24),

            // ✔ Visited Button
            ElevatedButton.icon(
              icon: Icon(bar.visited ? Icons.remove_done : Icons.check),
              label: Text(
                bar.visited
                    ? "Als nicht besucht markieren"
                    : "Als besucht markieren",
              ),
              onPressed: () {
                ref.read(barProvider.notifier).toggleVisited(bar.id);
              },
            ),

            const SizedBox(height: 12),

            // ⭐ FAVORIT BUTTON
            ElevatedButton.icon(
              icon: Icon(bar.favorite ? Icons.favorite : Icons.favorite_border),
              label: Text(
                bar.favorite ? "Favorit entfernen" : "Zu Favoriten hinzufügen",
              ),
              onPressed: () {
                ref.read(barProvider.notifier).toggleFavorite(bar.id);
              },
            ),

            const SizedBox(height: 24),

            // ⭐ RATING SECTION (NEU / KONSISTENT)
            const Text(
              "Bewertung",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

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

                return GestureDetector(
                  onTap: () {
                    double newRating;

                    if (bar.rating == starValue) {
                      newRating = starValue - 0.5;
                    } else {
                      newRating = starValue;
                    }

                    if (newRating < 0.5) {
                      newRating = 0.0; // ⭐ keine Bewertung
                    }

                    ref.read(barProvider.notifier).setRating(bar.id, newRating);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(icon, color: Colors.amber, size: 34),
                  ),
                );
              }),
            ),

            const SizedBox(height: 12),

            // 🧹 Bewertung entfernen
            if (bar.rating > 0)
              TextButton.icon(
                onPressed: () {
                  ref.read(barProvider.notifier).setRating(bar.id, 0.0);
                },
                icon: const Icon(Icons.clear),
                label: const Text("Bewertung entfernen"),
              ),

            const SizedBox(height: 32),

            BarReviewSection(bar: bar),
          ],
        ),
      ),
    );
  }
}
