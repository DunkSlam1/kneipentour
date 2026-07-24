import 'package:flutter/material.dart';

import '../../bars/models/bar.dart';
import '../../bars/pages/bar_detail_page.dart';
import '../models/discover_card_state.dart';

class RollingBarCard extends StatelessWidget {
  final List<String> names;
  final Bar? selectedBar;
  final DiscoverCardState cardState;

  const RollingBarCard({
    super.key,
    required this.names,
    required this.cardState,
    this.selectedBar,
  });

  @override
  Widget build(BuildContext context) {
    switch (cardState) {
      case DiscoverCardState.idle:
        return _buildIdleCard();

      case DiscoverCardState.rolling:
        return _buildRollingCard();

      case DiscoverCardState.winner:
        return _buildWinnerCard(context);
    }
  }

  Widget _buildIdleCard() {
    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final titleSize = (constraints.maxHeight * 0.18).clamp(14.0, 30.0);

          final textSize = (constraints.maxHeight * 0.10).clamp(10.0, 18.0);

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: textSize),
                  ),
                  const Divider(height: 8),
                  Text(
                    'Kneipe ziehen 🍻',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 8),
                  Text(
                    '...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: textSize),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRollingCard() {
    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final titleSize = (constraints.maxHeight * 0.18).clamp(14.0, 30.0);

          final textSize = (constraints.maxHeight * 0.10).clamp(10.0, 18.0);

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    names.isNotEmpty ? names[0] : '...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: textSize),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    names.length > 1 ? names[1] : 'Kneipe wird gezogen...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    names.length > 2 ? names[2] : '...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: textSize),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWinnerCard(BuildContext context) {
    if (selectedBar == null) {
      return _buildIdleCard();
    }

    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final titleSize = (constraints.maxHeight * 0.14).clamp(14.0, 24.0);

          final iconSize = (constraints.maxHeight * 0.15).clamp(20.0, 40.0);
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.local_bar, size: iconSize),

                  Flexible(
                    child: Text(
                      selectedBar!.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Center(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('Details'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                BarDetailPage(barId: selectedBar!.id),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
