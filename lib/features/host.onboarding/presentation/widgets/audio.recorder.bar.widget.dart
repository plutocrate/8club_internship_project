import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.gradients.dart';
import '../../../../core/constants/app.text.styles.dart';
import 'waveform.visualizer.widget.dart';

class AudioRecorderBarWidget extends StatelessWidget {
  final Duration duration;
  final List<double> amplitudes;
  final VoidCallback onStop;

  const AudioRecorderBarWidget({
    super.key,
    required this.duration,
    required this.amplitudes,
    required this.onStop,
  });

  String get formattedDuration {
    final m = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: ShapeDecoration(
        gradient: AppGradients.cardSheen,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFF323236)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Recording Audio...',
            style: AppTextStyles.s1Regular.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              GestureDetector(
                onTap: onStop,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.accentPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WaveformVisualizerWidget(
                  amplitudes: amplitudes,
                  isRecording: true,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                formattedDuration,
                style: AppTextStyles.b2Regular.copyWith(color: AppColors.accentPurpleLight),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
