import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.text.styles.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: AppColors.surfaceSecondary,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.borderSubtle),
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
            child: Text(
              'Audio Recorded • $durationText',
              style: AppTextStyles.b2Regular.copyWith(color: AppColors.textPrimary),
            ),
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
