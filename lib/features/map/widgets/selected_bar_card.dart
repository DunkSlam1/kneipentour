import 'package:flutter/material.dart';

import '../../bars/models/bar.dart';
import '../../bars/pages/bar_detail_page.dart';
import '../../bars/utils/opening_status.dart';

class SelectedBarCard extends StatelessWidget {
  final Bar bar;

  const SelectedBarCard({super.key, required this.bar});

  @override
  Widget build(BuildContext context) {
    final status = OpeningStatusHelper.getStatus(bar.openingHours);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🍺 ${bar.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              status.text,
              style: TextStyle(
                color: status.state == OpeningState.open
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            if (bar.rating > 0)
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(bar.rating.toStringAsFixed(1)),
                ],
              )
            else
              const Text(
                "Noch nicht bewertet",
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BarDetailPage(barId: bar.id),
                    ),
                  );
                },
                child: const Text('Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
