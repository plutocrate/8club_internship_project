import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';

class OnboardingProgressBarWidget extends StatelessWidget {
  final double progress; // 0.0 to 1.0

  const OnboardingProgressBarWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: progress),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, child) {
        return CustomPaint(
          size: const Size(double.infinity, 12),
          painter: HanddrawnSquigglyWavePainter(
            progress: animatedProgress,
            activeColor: AppColors.accentPurpleLight,
            inactiveColor: AppColors.borderMedium,
          ),
        );
      },
    );
  }
}

class HanddrawnSquigglyWavePainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  HanddrawnSquigglyWavePainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final activeWidth = size.width * progress.clamp(0.0, 1.0);
    const waveLength = 26.0; // Wider pitch length for handdrawn feel
    const amplitude = 2.2;   // Gentle, subtle peaks
    final midY = size.height / 2;

    Path createWavePath(double startX, double endX) {
      final path = Path();
      bool first = true;
      for (double x = startX; x <= endX; x += 1.0) {
        // Subtle handdrawn harmonic modulation
        final mod = 1.0 + 0.1 * math.sin(x * 0.05);
        final y = midY + amplitude * mod * math.sin((x / waveLength) * 2 * math.pi);
        if (first) {
          path.moveTo(x, y);
          first = false;
        } else {
          path.lineTo(x, y);
        }
      }
      return path;
    }

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    if (activeWidth < size.width) {
      canvas.drawPath(createWavePath(activeWidth, size.width), inactivePaint);
    }

    if (activeWidth > 0) {
      canvas.drawPath(createWavePath(0, activeWidth), activePaint);
    }
  }

  @override
  bool shouldRepaint(covariant HanddrawnSquigglyWavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
