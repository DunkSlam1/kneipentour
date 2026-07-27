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
                      offset: Offset(0, layout.height * 0.025),
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
                  color: scheme.surfaceContainerHighest,

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

                child: Center(
                  child: Icon(
                    Icons.local_activity,
                    size: layout.width * 0.07,
                    color: scheme.primary,
                  ),
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
              height: layout.height * 0.50,

              child: child,
            ),
          ],
        );
      },
    );
  }
}
