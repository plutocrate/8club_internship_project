import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.text.styles.dart';

class VideoPlayerBarWidget extends StatelessWidget {
  final String? videoPath;
  final VoidCallback onDelete;

  const VideoPlayerBarWidget({
    super.key,
    this.videoPath,
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
          Container(
            width: 48,
            height: 48,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: AppColors.surfaceElevated,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (videoPath != null && File(videoPath!).existsSync())
                  Image.file(
                    File(videoPath!),
                    fit: BoxFit.cover,
                    width: 48,
                    height: 48,
                    errorBuilder: (context, error, stack) => Container(
                      color: AppColors.surfaceElevated,
                      child: const Icon(Icons.videocam, color: AppColors.textSecondary),
                    ),
                  )
                else
                  Container(
                    color: AppColors.surfaceElevated,
                    child: const Icon(Icons.videocam, color: AppColors.textSecondary),
                  ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Video Recorded',
                  style: AppTextStyles.b2Bold.copyWith(color: AppColors.textPrimary),
                ),
                Text(
                  'Tap to preview',
                  style: AppTextStyles.s1Regular.copyWith(color: AppColors.textSecondary),
                ),
              ],
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
