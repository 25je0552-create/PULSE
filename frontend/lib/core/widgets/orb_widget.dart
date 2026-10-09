import 'dart:math';
import 'package:flutter/material.dart';

enum OrbState { idle, listening, thinking, speaking, error }

class OrbWidget extends StatefulWidget {
  final OrbState state;
  final double level;
  final double size;

  const OrbWidget({
    super.key,
    this.state = OrbState.idle,
    this.level = 0.0,
    this.size = 200,
  });

  @override
  State<OrbWidget> createState() => _OrbWidgetState();
}

class _OrbWidgetState extends State<OrbWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _OrbPainter(
              state: widget.state,
              level: widget.level,
              progress: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  final OrbState state;
  final double level;
  final double progress;

  _OrbPainter({
    required this.state,
    required this.level,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.32;

    final Color color1;
    final Color color2;
    final Color glowColor;

    switch (state) {
      case OrbState.idle:
        color1 = const Color(0xFF00685F);
        color2 = const Color(0xFF00B4D8);
        glowColor = const Color(0xFF00685F).withValues(alpha: 0.35);
        break;
      case OrbState.listening:
        color1 = const Color(0xFF00B4D8);
        color2 = const Color(0xFF10B981);
        glowColor = const Color(0xFF10B981).withValues(alpha: 0.40);
        break;
      case OrbState.thinking:
        color1 = const Color(0xFF4648D4);
        color2 = const Color(0xFF818CF8);
        glowColor = const Color(0xFF4648D4).withValues(alpha: 0.35);
        break;
      case OrbState.speaking:
        color1 = const Color(0xFF00685F);
        color2 = const Color(0xFF6366F1);
        glowColor = const Color(0xFF00685F).withValues(alpha: 0.40);
        break;
      case OrbState.error:
        color1 = const Color(0xFFBA1A1A);
        color2 = const Color(0xFFFF5252);
        glowColor = const Color(0xFFBA1A1A).withValues(alpha: 0.30);
        break;
    }

    final glowPaint = Paint()
      ..color = glowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
    canvas.drawCircle(center, baseRadius * 1.15, glowPaint);

    final haloPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 1; i <= 2; i++) {
      final ringScale = 1.0 + (i * 0.16) + (sin(progress * 2 * pi + i) * 0.03);
      haloPaint.color = color2.withValues(alpha: 0.18 / i);
      canvas.drawCircle(center, baseRadius * ringScale, haloPaint);
    }

    if (state == OrbState.listening) {
      const rippleCount = 3;
      final ripplePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      for (int i = 0; i < rippleCount; i++) {
        final phase = (progress + (i / rippleCount)) % 1.0;
        final rippleRadius = baseRadius * (1.1 + phase * (0.6 + level * 0.5));
        final opacity = (1.0 - phase) * (0.3 + level * 0.5);
        ripplePaint.color = const Color(0xFF00B4D8).withValues(alpha: opacity.clamp(0.0, 1.0));
        canvas.drawCircle(center, rippleRadius, ripplePaint);
      }
    } else if (state == OrbState.thinking) {
      final particlePaint = Paint()..style = PaintingStyle.fill;
      const numParticles = 7;
      for (int i = 0; i < numParticles; i++) {
        final pAngle = (progress * 2 * pi) + (i * (2 * pi / numParticles));
        final px = center.dx + cos(pAngle) * (baseRadius * 1.35);
        final py = center.dy + sin(pAngle) * (baseRadius * 0.85);
        particlePaint.color = const Color(0xFFFCD34D).withValues(alpha: 0.7);
        canvas.drawCircle(Offset(px, py), 3.5, particlePaint);
      }
    } else if (state == OrbState.speaking) {
      const barCount = 48;
      final barPaint = Paint()
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < barCount; i++) {
        final barAngle = (i / barCount) * 2 * pi;
        final envelope = (sin(barAngle * 6 + progress * 10 * pi) * 0.5 +
                cos(barAngle * 3 - progress * 8 * pi) * 0.5)
            .abs();
        final barLength = 6.0 + envelope * 24.0;
        final startR = baseRadius * 1.08;
        final endR = startR + barLength;

        final p1 = Offset(
          center.dx + cos(barAngle) * startR,
          center.dy + sin(barAngle) * startR,
        );
        final p2 = Offset(
          center.dx + cos(barAngle) * endR,
          center.dy + sin(barAngle) * endR,
        );

        barPaint.color = color1.withValues(alpha: 0.6 + envelope * 0.4);
        canvas.drawLine(p1, p2, barPaint);
      }
    }

    double scale = 1.0;
    if (state == OrbState.idle) {
      scale = 0.96 + (sin(progress * 2 * pi) * 0.04);
    } else if (state == OrbState.listening) {
      scale = 1.0 + (level * 0.12);
    } else if (state == OrbState.speaking) {
      scale = 1.0 + (sin(progress * 6 * pi).abs() * 0.08);
    } else if (state == OrbState.error) {
      scale = 0.98 + (sin(progress * pi) * 0.01);
    }

    final currentRadius = baseRadius * scale;
    final driftX = center.dx + cos(progress * 2 * pi) * 8;
    final driftY = center.dy + sin(progress * 2 * pi) * 8;

    final spherePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          (driftX - center.dx) / currentRadius,
          (driftY - center.dy) / currentRadius - 0.2,
        ),
        radius: 0.95,
        colors: [color2, color1],
        stops: const [0.1, 0.9],
      ).createShader(Rect.fromCircle(center: center, radius: currentRadius));

    canvas.drawCircle(center, currentRadius, spherePaint);

    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.4),
        radius: 0.4,
        colors: [
          Colors.white.withValues(alpha: 0.65),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: currentRadius));

    canvas.drawCircle(center, currentRadius, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.state != state ||
        oldDelegate.level != level;
  }
}
