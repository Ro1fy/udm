import 'package:flutter/material.dart';

import '../constants.dart';

class UdmurtPattern extends StatelessWidget {
  const UdmurtPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 14,
      child: CustomPaint(painter: _UdmurtPatternPainter()),
    );
  }
}

class _UdmurtPatternPainter extends CustomPainter {
  const _UdmurtPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final redPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    final blackPaint = Paint()
      ..color = AppColors.black
      ..style = PaintingStyle.fill;

    for (var x = 7.0; x < size.width; x += 24) {
      final diamond = Path()
        ..moveTo(x, 1)
        ..lineTo(x + 6, size.height / 2)
        ..lineTo(x, size.height - 1)
        ..lineTo(x - 6, size.height / 2)
        ..close();
      canvas.drawPath(diamond, redPaint);

      final center = Path()
        ..moveTo(x, size.height / 2 - 3)
        ..lineTo(x + 3, size.height / 2)
        ..lineTo(x, size.height / 2 + 3)
        ..lineTo(x - 3, size.height / 2)
        ..close();
      canvas.drawPath(center, blackPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _UdmurtPatternPainter oldDelegate) => false;
}
