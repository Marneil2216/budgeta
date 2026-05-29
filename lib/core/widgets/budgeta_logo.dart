import 'package:flutter/material.dart';

class BudgetaLogo extends StatelessWidget {
  const BudgetaLogo({
    super.key,
    this.iconSize = 40.0,
    this.textColor = Colors.white,
  });

  final double iconSize;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _BudgetaIcon(size: iconSize),
        SizedBox(width: iconSize * 0.28),
        Text(
          'Budgeta',
          style: TextStyle(
            fontSize: iconSize * 0.52,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }
}

class _BudgetaIcon extends StatelessWidget {
  const _BudgetaIcon({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF1D9E75),
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: CustomPaint(painter: _BarsPainter()),
    );
  }
}

class _BarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final radius = Radius.circular(w * 0.03);

    void drawBar(double x, double y, double width, double height, double opacity) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          x * w, y * h,
          (x + width) * w, (y + height) * h,
          radius,
        ),
        Paint()..color = Colors.white.withOpacity(opacity),
      );
    }

    // Proportions from the HTML SVG (100x100 box)
    drawBar(0.18, 0.52, 0.18, 0.32, 0.30); // left, shortest
    drawBar(0.41, 0.36, 0.18, 0.48, 0.65); // middle
    drawBar(0.64, 0.20, 0.18, 0.64, 1.00); // right, tallest
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
