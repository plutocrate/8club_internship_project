import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.gradients.dart';
import '../../../../core/constants/app.text.styles.dart';
import 'waveform.visualizer.widget.dart';

class AudioPlayerBarWidget extends StatelessWidget {
  final String durationText;
  final bool isPlaying;
  final VoidCallback onPlayToggle;
  final VoidCallback onDelete;

  const AudioPlayerBarWidget({
    super.key,
    required this.durationText,
    required this.isPlaying,
    required this.onPlayToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: ShapeDecoration(
        gradient: AppGradients.cardSheen,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFF323236)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPlayToggle,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.accentPurple,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: WaveformVisualizerWidget(
              amplitudes: isPlaying
                  ? List.generate(24, (i) => 0.2 + (i % 5) * 0.16)
                  : List.generate(24, (i) => 0.15),
              isRecording: isPlaying,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            durationText,
            style: AppTextStyles.b2Regular.copyWith(color: AppColors.accentPurpleLight),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
