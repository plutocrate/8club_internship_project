import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';

class WaveformVisualizerWidget extends StatelessWidget {
  final List<double> amplitudes;
  final bool isRecording;

  const WaveformVisualizerWidget({
    super.key,
    required this.amplitudes,
    required this.isRecording,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        // Each bar is 3px wide with 3px spacing -> 6px total width per bar
        const itemWidth = 6.0;
        final count = (availableWidth / itemWidth).floor().clamp(6, 28);

        final bars = amplitudes.isEmpty
            ? List.generate(count, (i) => 0.15 + (i % 5) * 0.1)
            : amplitudes.take(count).toList();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(bars.length, (index) {
            final heightFactor = bars[index];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 3.0,
              height: 28 * heightFactor.clamp(0.1, 1.0),
              decoration: BoxDecoration(
                color: isRecording ? AppColors.accentPurpleLight : AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}
