import 'package:flutter/material.dart';

import '../../bars/models/bar.dart';
import '../../bars/pages/bar_detail_page.dart';

class LastVisitedSection extends StatelessWidget {
  final Bar? lastVisited;

  const LastVisitedSection({super.key, required this.lastVisited});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.history, size: 28),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Letzte besuchte Bar',
                    textAlign: TextAlign.center,
                  ),

                  Text(
                    lastVisited != null
                        ? lastVisited!.name
                        : 'Noch keine Bar besucht',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            if (lastVisited != null)
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.open_in_new),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BarDetailPage(barId: lastVisited!.id),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
