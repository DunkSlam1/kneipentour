import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bar_provider.dart';
import '../widgets/bar_card.dart';
import 'bar_detail_page.dart';

class BarsPage extends ConsumerWidget {
  const BarsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bars = ref.watch(barProvider);

    // ⭐ WICHTIG: Notifier nur für Actions + Meta-State
    final notifier = ref.read(barProvider.notifier);
    final filterMode = notifier.filterMode;
    final sortMode = notifier.sortMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kneipen'),

        actions: [
          PopupMenuButton<BarSortMode>(
            icon: const Icon(Icons.sort),
            initialValue: sortMode,
            onSelected: notifier.setSortMode,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: BarSortMode.alphabetical,
                child: Text('A–Z'),
              ),
              PopupMenuItem(
                value: BarSortMode.ratingDesc,
                child: Text('Beste Bewertung'),
              ),
              PopupMenuItem(
                value: BarSortMode.ratingAsc,
                child: Text('Schlechteste Bewertung'),
              ),
              PopupMenuItem(
                value: BarSortMode.openTimeAsc,
                child: Text('Schließt bald'),
              ),
              PopupMenuItem(
                value: BarSortMode.openTimeDesc,
                child: Text('Lange offen'),
              ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SegmentedButton<BarFilterMode>(
              segments: const [
                ButtonSegment(
                  value: BarFilterMode.all,
                  label: Text('Alle'),
                  icon: Icon(Icons.list, size: 18),
                ),
                ButtonSegment(
                  value: BarFilterMode.openOnly,
                  label: Text('Nur offen'),
                  icon: Icon(Icons.local_bar, size: 18),
                ),
              ],

              // ⭐ wichtig: Set muss stabil sein
              selected: {filterMode},

              onSelectionChanged: (newSelection) {
                notifier.setFilterMode(newSelection.first);
              },
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: ListView.builder(
              itemCount: bars.length,
              itemBuilder: (context, index) {
                final bar = bars[index];

                return BarCard(
                  bar: bar,

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BarDetailPage(barId: bar.id),
                      ),
                    );
                  },

                  onToggleVisited: () {
                    notifier.toggleVisited(bar.id);
                  },

                  onToggleFavorite: () {
                    notifier.toggleFavorite(bar.id);
                  },

                  onToggleRating: (rating) {
                    notifier.setRating(bar.id, rating);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
