import 'package:flutter/material.dart';

import '../../bars/models/bar.dart';

import '../../bars/pages/bar_detail_page.dart';

class TopBarsSection extends StatelessWidget {
  final List<Bar> topBars;

  const TopBarsSection({super.key, required this.topBars});

  @override
  Widget build(BuildContext context) {
    if (topBars.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const Text(
          'Top 3 Bars ⭐',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 4),

        Column(
          children: List.generate(topBars.length, (index) {
            final bar = topBars[index];

            final medal = switch (index) {
              0 => '🥇',
              1 => '🥈',
              _ => '🥉',
            };

            return SizedBox(
              height: 24,
              child: Row(
                children: [
                  Text(medal, style: const TextStyle(fontSize: 18)),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      bar.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(width: 2),

                  Text(
                    '⭐${bar.rating.toStringAsFixed(1)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  IconButton(
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.open_in_new, size: 20),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BarDetailPage(barId: bar.id),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
