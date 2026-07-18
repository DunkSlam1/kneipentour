import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bars/providers/bar_provider.dart';
import 'widgets/logbook_entry_card.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bars = ref.watch(barProvider);

    final visitedBars = bars.where((bar) => bar.visited).toList()
      ..sort((a, b) {
        if (a.visitedAt == null && b.visitedAt == null) {
          return 0;
        }

        if (a.visitedAt == null) {
          return 1;
        }

        if (b.visitedAt == null) {
          return -1;
        }

        return b.visitedAt!.compareTo(a.visitedAt!);
      });

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Besuchte Bars: ${visitedBars.length}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          if (visitedBars.isEmpty)
            const Center(child: Text('Noch keine Bars besucht 🍻'))
          else
            ...visitedBars.map((bar) => LogbookEntryCard(bar: bar)),
        ],
      ),
    );
  }
}
