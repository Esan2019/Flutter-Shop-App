import 'package:flutter/material.dart';

class GestureBackground extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color backgroundColor;
  final Alignment alignment;

  GestureBackground({
    @required this.icon,
    @required this.label,
    @required this.color,
    @required this.backgroundColor,
    @required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: backgroundColor,
      alignment: alignment,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: color),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          )
        ],
      ),
    );
  }
}
