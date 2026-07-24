import 'package:flutter/material.dart';

class ProgressSection extends StatelessWidget {
  final int visitedCount;
  final int totalBars;

  const ProgressSection({
    super.key,
    required this.visitedCount,
    required this.totalBars,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Fortschritt', style: Theme.of(context).textTheme.titleLarge),

        const SizedBox(height: 8),

        LinearProgressIndicator(
          value: totalBars == 0 ? 0 : visitedCount / totalBars,
        ),

        const SizedBox(height: 6),

        Text('$visitedCount / $totalBars Bars besucht'),
      ],
    );
  }
}
