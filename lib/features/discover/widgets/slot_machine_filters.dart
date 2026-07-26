import 'package:flutter/material.dart';

import '../models/bar_pick_filter.dart';

class SlotMachineFilters extends StatelessWidget {
  final BarPickFilter selectedFilter;
  final bool onlyUnvisited;

  final bool disabled;

  final ValueChanged<BarPickFilter> onFilterChanged;
  final ValueChanged<bool> onUnvisitedChanged;

  const SlotMachineFilters({
    super.key,
    required this.selectedFilter,
    required this.onlyUnvisited,
    required this.onFilterChanged,
    required this.onUnvisitedChanged,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                _buildFilterButton(
                  context,
                  icon: Icons.casino,
                  label: 'Alle',
                  selected: selectedFilter == BarPickFilter.all,
                  onTap: () {
                    onFilterChanged(BarPickFilter.all);
                  },
                ),

                const SizedBox(width: 6),

                _buildFilterButton(
                  context,
                  icon: Icons.schedule,
                  label: 'Offen',
                  selected: selectedFilter == BarPickFilter.openNow,
                  onTap: () {
                    onFilterChanged(BarPickFilter.openNow);
                  },
                ),

                const SizedBox(width: 6),

                _buildFilterButton(
                  context,
                  icon: Icons.today,
                  label: 'Heute',
                  selected: selectedFilter == BarPickFilter.openToday,
                  onTap: () {
                    onFilterChanged(BarPickFilter.openToday);
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Divider(),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: _buildFilterButton(
                context,
                icon: Icons.check_circle_outline,
                label: 'Nur unbesuchte',
                selected: onlyUnvisited,
                expanded: false,
                compact: true,
                onTap: () {
                  onUnvisitedChanged(!onlyUnvisited);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
    bool expanded = true,
    bool compact = false,
  }) {
    final button = GestureDetector(
      onTap: disabled ? null : onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        height: compact ? 36 : 46,

        padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 12),

        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,

          borderRadius: BorderRadius.circular(14),
        ),

        child: Row(
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,

          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 18, color: selected ? Colors.black : null),

            const SizedBox(width: 5),

            Text(
              label,

              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,

                color: selected ? Colors.black : null,
              ),
            ),
          ],
        ),
      ),
    );

    if (expanded) {
      return Expanded(child: button);
    }

    return button;
  }
}
