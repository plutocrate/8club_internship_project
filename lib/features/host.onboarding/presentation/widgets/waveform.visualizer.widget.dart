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
    final bars = amplitudes.isEmpty
        ? List.generate(24, (i) => 0.15 + (i % 5) * 0.1)
        : amplitudes;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(bars.length, (index) {
        final heightFactor = bars[index];
        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          width: 3.5,
          height: 32 * heightFactor.clamp(0.1, 1.0),
          decoration: BoxDecoration(
            color: isRecording ? AppColors.accentPurpleLight : AppColors.textSecondary,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
