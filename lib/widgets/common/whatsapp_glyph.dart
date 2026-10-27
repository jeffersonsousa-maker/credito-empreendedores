import 'package:flutter/material.dart';

/// Ícone de conversa por telefone (balão + fone), desenhado no próprio app
/// para não depender de pacotes de ícones de terceiros.
class WhatsAppGlyph extends StatelessWidget {
  const WhatsAppGlyph({super.key, this.size = 24, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color ?? Colors.white;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _BubblePainter(c)),
            ),
            Positioned(
              left: size * 0.29,
              top: size * 0.24,
              child: Icon(Icons.call, size: size * 0.46, color: c),
            ),
          ],
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  _BubblePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.085
      ..isAntiAlias = true;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final center = Offset(s * 0.52, s * 0.47);
    canvas.drawCircle(center, s * 0.39, stroke);

    final tail = Path()
      ..moveTo(s * 0.17, s * 0.66)
      ..lineTo(s * 0.07, s * 0.94)
      ..lineTo(s * 0.37, s * 0.85)
      ..close();
    canvas.drawPath(tail, fill);
  }

  @override
  bool shouldRepaint(_BubblePainter oldDelegate) => oldDelegate.color != color;
}
