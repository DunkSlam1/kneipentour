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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ==========================
        // Hauptauswahl
        // ==========================
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              context,
              icon: Icons.casino,
              label: 'Alle',
              active: selectedFilter == BarPickFilter.all,
              onTap: () {
                onFilterChanged(BarPickFilter.all);
              },
            ),

            const SizedBox(width: 8),

            _buildButton(
              context,
              icon: Icons.schedule,
              label: 'Offen',
              active: selectedFilter == BarPickFilter.openNow,
              onTap: () {
                onFilterChanged(BarPickFilter.openNow);
              },
            ),

            const SizedBox(width: 8),

            _buildButton(
              context,
              icon: Icons.today,
              label: 'Heute',
              active: selectedFilter == BarPickFilter.openToday,
              onTap: () {
                onFilterChanged(BarPickFilter.openToday);
              },
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ==========================
        // Trennung
        // ==========================
        Container(
          width: 170,
          height: 1,
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
        ),

        const SizedBox(height: 12),

        // ==========================
        // Kippschalter
        // ==========================
        _buildToggle(context),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: disabled ? null : onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        height: 38,

        padding: const EdgeInsets.symmetric(horizontal: 12),

        decoration: BoxDecoration(
          color: active
              ? Colors.amber.shade700
              : scheme.surfaceContainerHighest,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: active ? Colors.amber : scheme.outline,

            width: 1.2,
          ),

          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.6),

                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(icon, size: 17, color: active ? Colors.black : null),

            const SizedBox(width: 5),

            Text(
              label,

              style: TextStyle(
                fontSize: 13,

                fontWeight: active ? FontWeight.bold : FontWeight.normal,

                color: active ? Colors.black : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 160,
      height: 38,

      padding: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: scheme.outline, width: 1.2),
      ),

      child: Row(
        children: [
          // =====================
          // ALLE
          // =====================
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,

              onTap: () {
                onUnvisitedChanged(false);
              },

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: !onlyUnvisited
                      ? Colors.amber.shade700
                      : Colors.transparent,

                  borderRadius: BorderRadius.circular(18),

                  boxShadow: !onlyUnvisited
                      ? [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.6),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),

                child: Text(
                  'Alle',

                  style: TextStyle(
                    fontSize: 13,

                    fontWeight: !onlyUnvisited
                        ? FontWeight.bold
                        : FontWeight.normal,

                    color: !onlyUnvisited ? Colors.black : null,
                  ),
                ),
              ),
            ),
          ),

          // =====================
          // UNBESUCHT
          // =====================
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,

              onTap: () {
                onUnvisitedChanged(true);
              },

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: onlyUnvisited
                      ? Colors.amber.shade700
                      : Colors.transparent,

                  borderRadius: BorderRadius.circular(18),

                  boxShadow: onlyUnvisited
                      ? [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.6),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),

                child: Text(
                  'Unbesucht',

                  style: TextStyle(
                    fontSize: 13,

                    fontWeight: onlyUnvisited
                        ? FontWeight.bold
                        : FontWeight.normal,

                    color: onlyUnvisited ? Colors.black : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
