import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bars/providers/bar_provider.dart';
import '../bars/pages/bar_detail_page.dart';
import '../discover/widgets/random_bar_section.dart';
import 'widgets/top_bars_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bars = ref.watch(barProvider);

    final visitedBars =
        bars.where((b) => b.visited && b.visitedAt != null).toList()
          ..sort((a, b) => b.visitedAt!.compareTo(a.visitedAt!));

    final visitedCount = bars.where((b) => b.visited).length;

    final lastVisited = visitedBars.isNotEmpty ? visitedBars.first : null;

    // ⭐ TOP 3 BARS
    final topBars = List.of(bars)
      ..where((b) => b.rating > 0)
      ..sort((a, b) => b.rating.compareTo(a.rating));

    final top3 = topBars.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('KneipenTour 🍻')),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 📊 PROGRESS
                Text(
                  'Fortschritt',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 8),

                LinearProgressIndicator(
                  value: bars.isEmpty ? 0 : visitedCount / bars.length,
                ),

                const SizedBox(height: 6),

                Text('$visitedCount / ${bars.length} Bars besucht'),

                const SizedBox(height: 24),

                // 📍 LETZTE BESUCHTE BAR (verbessert)
                Card(
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.history),

                    title: const Text('Letzte besuchte Bar'),

                    subtitle: lastVisited != null
                        ? Text(
                            lastVisited.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text('Noch keine Bar besucht'),

                    trailing: lastVisited != null
                        ? IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BarDetailPage(barId: lastVisited.id),
                                ),
                              );
                            },
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 8),

                // 🎲 RANDOM BAR
                SizedBox(height: constraints.maxHeight * 0.005),

                const Divider(height: 16),

                Text(
                  'Entdecken 🍻',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 8),

                RandomBarSection(bars: bars),

                const Spacer(),

                // ⭐ TOP 3 RANKING
                TopBarsSection(topBars: top3),
              ],
            ),
          );
        },
      ),
    );
  }
}
