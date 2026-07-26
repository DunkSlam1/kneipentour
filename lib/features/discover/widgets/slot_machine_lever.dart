import 'dart:async';

import 'package:flutter/material.dart';

class SlotMachineLever extends StatefulWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const SlotMachineLever({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  @override
  State<SlotMachineLever> createState() => _SlotMachineLeverState();
}

class _SlotMachineLeverState extends State<SlotMachineLever>
    with SingleTickerProviderStateMixin {
  bool _isPulling = false;

  late AnimationController _controller;
  late Animation<double> _rotation;

  static const double startAngle = 0.15;
  static const double pullAngle = 1.5;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _rotation = Tween<double>(
      begin: startAngle,
      end: pullAngle,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _pullLever() async {
    if (!widget.enabled || _isPulling) return;

    _isPulling = true;

    await Future.delayed(const Duration(milliseconds: 150));

    widget.onPressed();

    await _controller.forward();

    await Future.delayed(const Duration(milliseconds: 120));

    await _controller.reverse();

    setState(() {
      _isPulling = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pullLever,

      child: SizedBox(
        width: 270,
        height: 80,

        child: AnimatedBuilder(
          animation: _rotation,

          builder: (context, child) {
            return Stack(
              clipBehavior: Clip.none,

              children: [
                Positioned(
                  left: 130,
                  top: -15,

                  child: Transform.rotate(
                    angle: _rotation.value,

                    alignment: Alignment.centerLeft,

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Container(
                          width: 95,
                          height: 8,

                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,

                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),

                        const SizedBox(width: 4),

                        Container(
                          width: 32,
                          height: 32,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            color: Colors.red,

                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4,
                                offset: Offset(0, 2),
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
