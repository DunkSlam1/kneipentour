import 'package:flutter/material.dart';

import '../../bars/models/bar.dart';
import '../../bars/utils/opening_status.dart';

class DailyStatusSection extends StatelessWidget {
  final List<Bar> bars;

  const DailyStatusSection({super.key, required this.bars});

  @override
  Widget build(BuildContext context) {
    int open = 0;
    int openingLater = 0;
    int closed = 0;

    for (final bar in bars) {
      final status = OpeningStatusHelper.getStatus(bar.openingHours);

      if (status.state == OpeningState.open) {
        open++;
      } else if (status.text.contains('öffnet')) {
        openingLater++;
      } else {
        closed++;
      }
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

        child: Row(
          children: [
            const Icon(Icons.today, size: 30),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Tagesstatus',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      _buildStatus(context, Colors.green, '$open offen'),

                      const SizedBox(width: 12),

                      _buildStatus(
                        context,
                        Colors.amber,
                        '$openingLater später',
                      ),

                      const SizedBox(width: 12),

                      _buildStatus(context, Colors.red, '$closed geschlossen'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(BuildContext context, Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: 5),

        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
