import 'dart:math';

import 'package:flutter/material.dart';

class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final random = Random();

  late final List<_ConfettiPiece> pieces;

  @override
  void initState() {
    super.initState();

    pieces = List.generate(
      45,
      (_) => _ConfettiPiece(
        x: random.nextDouble(),
        delay: random.nextDouble(),
        size: 5 + random.nextDouble() * 7,
        rotation: random.nextDouble() * pi,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,

        builder: (context, child) {
          return CustomPaint(
            painter: _ConfettiPainter(
              pieces: pieces,
              progress: _controller.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ConfettiPiece {
  final double x;
  final double delay;
  final double size;
  final double rotation;

  _ConfettiPiece({
    required this.x,
    required this.delay,
    required this.size,
    required this.rotation,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  final double progress;

  _ConfettiPainter({required this.pieces, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final piece in pieces) {
      final localProgress = ((progress - piece.delay * 0.3) / 0.7).clamp(
        0.0,
        1.0,
      );

      final x = piece.x * size.width;

      final y = localProgress * size.height * 0.8;

      final opacity = 1 - localProgress;

      paint.color = Colors
          .primaries[(piece.x * Colors.primaries.length).floor()]
          .withValues(alpha: opacity);

      canvas.save();

      canvas.translate(x, y);

      canvas.rotate(piece.rotation + progress * pi);

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: piece.size,
          height: piece.size * 0.6,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
