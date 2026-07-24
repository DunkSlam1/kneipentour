import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bars/providers/bar_provider.dart';
import 'widgets/top_bars_section.dart';

import 'widgets/progress_section.dart';
import 'widgets/last_visited_section.dart';
import 'widgets/discover_section.dart';

import '../../core/layout/home_layout.dart';
import '../../core/layout/section_layout_calculator.dart';

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
          final layout = const SectionLayoutCalculator().calculate(
            availableHeight: constraints.maxHeight - 32 - 8,
            sections: [
              HomeLayout.progress,
              HomeLayout.lastVisited,
              HomeLayout.discover,
              HomeLayout.topBars,
            ],
          );

          debugPrint('--- HOME LAYOUT ---');
          debugPrint('Progress: ${layout[HomeLayout.progress]}');
          debugPrint('Last: ${layout[HomeLayout.lastVisited]}');
          debugPrint('Discover: ${layout[HomeLayout.discover]}');
          debugPrint('TopBars: ${layout[HomeLayout.topBars]}');

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 📊 PROGRESS
                SizedBox(
                  height: layout[HomeLayout.progress],
                  child: SizedBox(
                    height: layout[HomeLayout.progress],
                    child: ProgressSection(
                      visitedCount: visitedCount,
                      totalBars: bars.length,
                    ),
                  ),
                ),

                // 📍 LETZTE BESUCHTE BAR (verbessert)
                SizedBox(
                  height: layout[HomeLayout.lastVisited],
                  child: SizedBox(
                    height: layout[HomeLayout.lastVisited],
                    child: LastVisitedSection(lastVisited: lastVisited),
                  ),
                ),

                const SizedBox(height: 8),

                // 🎲 RANDOM BAR
                // 🎲 RANDOM BAR
                Expanded(child: DiscoverSection(bars: bars)),

                // ⭐ TOP 3 RANKING
                SizedBox(
                  height: layout[HomeLayout.topBars],
                  child: TopBarsSection(topBars: top3),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
