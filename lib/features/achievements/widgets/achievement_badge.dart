import 'package:flutter/material.dart';

class AchievementBadge extends StatelessWidget {
  final String icon;
  final bool unlocked;
  final double size;

  const AchievementBadge({
    super.key,
    required this.icon,
    required this.unlocked,
    this.size = 60,
  });

  bool get isNumber => int.tryParse(icon) != null;

  @override
  Widget build(BuildContext context) {
    if (!isNumber) {
      return _buildBadge(
        child: Text(icon, style: const TextStyle(fontSize: 26)),
      );
    }

    return _buildBadge(
      child: Text(
        icon,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: unlocked ? Colors.white : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildBadge({required Widget child}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,

        gradient: unlocked
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.amber.shade200,
                  Colors.amber.shade700,
                  Colors.orange.shade800,
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.grey.shade300, Colors.grey.shade500],
              ),

        border: Border.all(
          color: unlocked ? Colors.amber.shade100 : Colors.grey.shade400,
          width: 3,
        ),

        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),

      child: Stack(
        alignment: Alignment.center,
        children: [
          // kleiner innerer Prägestreifen
          if (unlocked)
            Container(
              width: size * 0.77,
              height: size * 0.77,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.amber.shade100.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
            ),

          child,
        ],
      ),
    );
  }
}
