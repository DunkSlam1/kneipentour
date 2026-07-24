import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../bars/models/bar.dart';
import '../services/bar_picker_service.dart';
import 'rolling_bar_card.dart';
import '../models/bar_pick_filter.dart';
import '../models/discover_card_state.dart';

class RandomBarSection extends StatefulWidget {
  final List<Bar> bars;

  const RandomBarSection({super.key, required this.bars});

  @override
  State<RandomBarSection> createState() => _RandomBarSectionState();
}

class _RandomBarSectionState extends State<RandomBarSection> {
  final BarPickerService barPicker = BarPickerService();

  Bar? selectedBar;

  DiscoverCardState cardState = DiscoverCardState.idle;

  bool isRolling = false;

  List<String> rollingNames = [];

  List<Bar> rollingBars = [];

  int rollingIndex = 0;

  int winnerIndex = 0;

  int counter = 0;

  static const int maxRollSteps = 30;

  Timer? rollingTimer;

  BarPickFilter selectedOpeningFilter = BarPickFilter.all;

  bool onlyUnvisited = false;

  void pickBar() {
    final candidates = barPicker.getCandidates(
      widget.bars,
      selectedOpeningFilter,
      onlyUnvisited: onlyUnvisited,
    );

    if (candidates.isEmpty) {
      return;
    }

    final random = Random();

    final finalBar = candidates[random.nextInt(candidates.length)];

    rollingBars = List<Bar>.from(candidates)..shuffle(random);

    winnerIndex = rollingBars.indexOf(finalBar);

    setState(() {
      isRolling = true;
      selectedBar = null;
      cardState = DiscoverCardState.rolling;
      rollingIndex = 0;
      counter = 0;
    });

    rollingTimer?.cancel();

    void rollStep() {
      if (counter >= maxRollSteps) {
        setState(() {
          rollingNames = [
            rollingBars[(winnerIndex - 1 + rollingBars.length) %
                    rollingBars.length]
                .name,
            rollingBars[winnerIndex].name,
            rollingBars[(winnerIndex + 1) % rollingBars.length].name,
          ];
        });

        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            isRolling = false;
            rollingNames = [];
            selectedBar = finalBar;
            cardState = DiscoverCardState.winner;
          });
        });

        return;
      }

      final first = rollingBars[rollingIndex % rollingBars.length];
      final second = rollingBars[(rollingIndex + 1) % rollingBars.length];
      final third = rollingBars[(rollingIndex + 2) % rollingBars.length];

      setState(() {
        rollingNames = [first.name, second.name, third.name];
      });

      rollingIndex++;

      counter++;

      final progress = counter / maxRollSteps;

      final delay = Duration(
        milliseconds: (40 + (progress * progress * 400)).round(),
      );

      Future.delayed(delay, rollStep);
    }

    rollStep();
  }

  @override
  void dispose() {
    rollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SegmentedButton<BarPickFilter>(
                showSelectedIcon: false,
                emptySelectionAllowed: true,

                segments: const [
                  ButtonSegment(
                    value: BarPickFilter.openNow,
                    icon: Icon(Icons.schedule),
                    label: Text('Geöffnet'),
                  ),

                  ButtonSegment(
                    value: BarPickFilter.openToday,
                    icon: Icon(Icons.today),
                    label: Text('Heute offen'),
                  ),
                ],

                selected: selectedOpeningFilter == BarPickFilter.all
                    ? {}
                    : {selectedOpeningFilter},

                onSelectionChanged: isRolling
                    ? null
                    : (selection) {
                        setState(() {
                          if (selection.isEmpty) {
                            selectedOpeningFilter = BarPickFilter.all;
                          } else {
                            selectedOpeningFilter = selection.first;
                          }
                        });
                      },
              ),
            ),

            const SizedBox(width: 8),

            FilterChip(
              label: const Text('Unbesucht'),
              selected: onlyUnvisited,
              avatar: const Icon(Icons.check_circle_outline, size: 18),

              onSelected: isRolling
                  ? null
                  : (value) {
                      setState(() {
                        onlyUnvisited = value;
                      });
                    },
            ),
          ],
        ),

        const SizedBox(height: 8),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: widget.bars.isEmpty || isRolling ? null : pickBar,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.casino, size: 24),
                SizedBox(width: 12),
                Text(
                  'Kneipe ziehen',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 12),
                Icon(Icons.casino, size: 24),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,

            child: RollingBarCard(
              names: isRolling ? rollingNames : [],
              selectedBar: selectedBar,
              cardState: cardState,
            ),
          ),
        ),
      ],
    );
  }
}
