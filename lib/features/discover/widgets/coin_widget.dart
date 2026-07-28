import 'dart:math';

import 'package:flutter/material.dart';

class CoinWidget extends StatelessWidget {
  final bool showBeerSide;
  final Animation<double> animation;

  const CoinWidget({
    super.key,
    required this.showBeerSide,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final angle = animation.value * (10 * pi);

        return CustomPaint(
          size: const Size(120, 120),
          painter: CoinPainter(angle: angle, beerSide: showBeerSide),
        );
      },
    );
  }
}

class CoinPainter extends CustomPainter {
  final double angle;
  final bool beerSide;

  CoinPainter({required this.angle, required this.beerSide});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2;

    // 3D Y-Rotation simulieren
    final scaleX = cos(angle).abs();

    // sichtbare Seite
    final front = cos(angle) >= 0 ? beerSide : !beerSide;

    canvas.save();

    // Perspektive
    canvas.translate(center.dx, center.dy);

    canvas.scale(scaleX == 0 ? 0.05 : scaleX, 1);

    canvas.translate(-center.dx, -center.dy);

    // Schatten
    final shadowPaint = Paint()
      ..color = Colors.black26
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(center.translate(0, 6), radius, shadowPaint);

    // Münzdicke (seitlicher Metallrand)
    final thicknessPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amber.shade600, Colors.amber.shade800],
          ).createShader(
            Rect.fromCircle(center: center.translate(0, 7), radius: radius),
          );

    canvas.drawCircle(center.translate(0, 7), radius, thicknessPaint);

    // Goldfläche
    final coinPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          Colors.amber.shade200,
          Colors.amber.shade500,
          Colors.amber.shade600,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, coinPaint);

    // äußerer Rand
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..color = Colors.amber.shade600;

    canvas.drawCircle(center, radius - 3, edgePaint);

    final shineEdgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.amber.shade200;

    canvas.drawCircle(center.translate(0, -1), radius - 7, shineEdgePaint);

    // innerer Prägebereich
    final innerEdgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.amber.shade200;

    canvas.drawCircle(center, radius - 15, innerEdgePaint);

    // Prägung
    if (front) {
      _drawBeerStamp(canvas, center);
    } else {
      _drawCocktailStamp(canvas, center);
    }

    canvas.restore();
  }

  void _drawBeerStamp(Canvas canvas, Offset center) {
    final shadow = Paint()
      ..color = Colors.brown.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final highlight = Paint()
      ..color = Colors.amber.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    _drawBeerShape(canvas, center.translate(0, 1), shadow);

    _drawBeerShape(canvas, center.translate(0, -1), highlight);
  }

  void _drawBeerShape(Canvas canvas, Offset center, Paint paint) {
    // Glas
    canvas.drawRect(
      Rect.fromCenter(center: center.translate(0, 8), width: 30, height: 40),
      paint,
    );

    // Henkel
    canvas.drawArc(
      Rect.fromCenter(center: center.translate(20, 8), width: 20, height: 28),
      -pi / 2,
      pi,
      false,
      paint,
    );

    // Schaum
    canvas.drawCircle(center.translate(-10, -18), 5, paint);

    canvas.drawCircle(center.translate(0, -22), 6, paint);

    canvas.drawCircle(center.translate(10, -18), 5, paint);
  }

  void _drawCocktailStamp(Canvas canvas, Offset center) {
    final shadow = Paint()
      ..color = Colors.brown.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final highlight = Paint()
      ..color = Colors.amber.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    _drawCocktailShape(canvas, center.translate(0, 1), shadow);

    _drawCocktailShape(canvas, center.translate(0, -1), highlight);
  }

  void _drawCocktailShape(Canvas canvas, Offset center, Paint paint) {
    final glass = Path();

    glass.moveTo(center.dx - 20, center.dy - 15);

    glass.lineTo(center.dx + 20, center.dy - 15);

    glass.lineTo(center.dx, center.dy + 18);

    glass.close();

    canvas.drawPath(glass, paint);

    // Stiel
    canvas.drawLine(center.translate(0, 18), center.translate(0, 35), paint);

    // Fuß
    canvas.drawLine(center.translate(-15, 35), center.translate(15, 35), paint);

    // Strohhalm
    canvas.drawLine(center.translate(5, -15), center.translate(15, -35), paint);
  }

  @override
  bool shouldRepaint(covariant CoinPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.beerSide != beerSide;
  }
}
