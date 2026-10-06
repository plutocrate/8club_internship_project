import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';

class OnboardingProgressBarWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgressBarWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return CustomPaint(
      size: const Size(double.infinity, 12),
      painter: SquigglyWavePainter(
        progress: progress,
        activeColor: AppColors.accentPurpleLight,
        inactiveColor: AppColors.borderMedium,
      ),
    );
  }
}

class SquigglyWavePainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  SquigglyWavePainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final activeWidth = size.width * progress.clamp(0.0, 1.0);
    const waveLength = 14.0;
    final amplitude = size.height / 2.5;
    final midY = size.height / 2;

    Path createWavePath(double startX, double endX) {
      final path = Path();
      bool first = true;
      for (double x = startX; x <= endX; x += 1.0) {
        final y = midY + amplitude * math.sin((x / waveLength) * 2 * math.pi);
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
  bool shouldRepaint(covariant SquigglyWavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
