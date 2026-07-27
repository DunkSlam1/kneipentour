import 'package:flutter/material.dart';

import 'slot_machine_layout.dart';

class SlotMachineFrame extends StatelessWidget {
  final Widget child;

  const SlotMachineFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = SlotMachineLayout(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
        );

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // ==========================
            // Füße (hinter dem Gehäuse)
            // ==========================
            Positioned(
              bottom: -layout.height * 0.025,
              left: layout.width * 0.18,

              child: _buildFoot(layout, scheme),
            ),

            Positioned(
              bottom: -layout.height * 0.035,
              right: layout.width * 0.18,

              child: _buildFoot(layout, scheme),
            ),

            // ==========================
            // Hauptgehäuse
            // ==========================
            Positioned(
              top: layout.height * 0.13,
              left: 0,
              right: 0,
              bottom: 0,

              child: Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,

                  borderRadius: BorderRadius.circular(layout.borderRadius),

                  border: Border.all(
                    width: layout.outerBorder * 0.75,
                    color: scheme.outline,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: layout.width * 0.035,
                      offset: Offset(0, layout.height * 0.035),
                    ),
                  ],
                ),
              ),
            ),

            // ==========================
            // Aufgesetzter Deckel
            // ==========================
            Positioned(
              top: 0,
              left: layout.width * 0.08,
              right: layout.width * 0.08,
              height: layout.height * 0.15,

              child: Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.85),

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(layout.borderRadius),
                    topRight: Radius.circular(layout.borderRadius),
                    bottomLeft: Radius.circular(layout.borderRadius * 0.35),
                    bottomRight: Radius.circular(layout.borderRadius * 0.35),
                  ),

                  border: Border.all(
                    width: layout.outerBorder * 0.75,
                    color: scheme.outline,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: layout.width * 0.02,
                      offset: Offset(0, layout.height * 0.015),
                    ),
                  ],
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sports_bar,
                      size: layout.width * 0.045,
                      color: Colors.amber.shade700,
                    ),

                    SizedBox(width: layout.width * 0.025),

                    Text(
                      'KNEIPENTOUR',
                      style: TextStyle(
                        fontSize: (layout.width * 0.04).clamp(16.0, 28.0),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.amber.shade700,
                      ),
                    ),

                    SizedBox(width: layout.width * 0.025),

                    Icon(
                      Icons.local_bar,
                      size: layout.width * 0.045,
                      color: Colors.amber.shade700,
                    ),
                  ],
                ),
              ),
            ),

            // ==========================
            // Innenraum
            // ==========================
            Positioned(
              top: layout.height * 0.17,
              left: layout.innerPadding,
              right: layout.innerPadding,
              bottom: layout.innerPadding,

              child: Container(
                decoration: BoxDecoration(
                  color: scheme.surface,

                  borderRadius: BorderRadius.circular(
                    layout.borderRadius * 0.8,
                  ),
                ),
              ),
            ),

            // ==========================
            // Inhalt
            // ==========================
            Positioned(
              top: layout.height * 0.16,
              left: layout.innerPadding * 1.5,
              right: layout.innerPadding * 1.5,
              height: layout.height * 0.76,

              child: child,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFoot(SlotMachineLayout layout, ColorScheme scheme) {
    return Container(
      width: layout.width * 0.14,
      height: layout.height * 0.05,

      decoration: BoxDecoration(
        color: scheme.surfaceContainer,

        borderRadius: BorderRadius.circular(layout.borderRadius * 0.3),

        border: Border.all(color: scheme.outline, width: 1),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}
