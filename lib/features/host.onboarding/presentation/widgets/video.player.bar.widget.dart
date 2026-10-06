import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.gradients.dart';
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
                  VideoSnapshotWidget(videoPath: videoPath!)
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

class VideoSnapshotWidget extends StatefulWidget {
  final String videoPath;

  const VideoSnapshotWidget({super.key, required this.videoPath});

  @override
  State<VideoSnapshotWidget> createState() => _VideoSnapshotWidgetState();
}

class _VideoSnapshotWidgetState extends State<VideoSnapshotWidget> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final file = File(widget.videoPath);
    if (!await file.exists()) return;
    try {
      _controller = VideoPlayerController.file(file);
      await _controller!.initialize();
      await _controller!.seekTo(Duration.zero);
      await _controller!.pause();
      if (mounted) {
        setState(() => _initialized = true);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _controller == null) {
      return Container(
        color: AppColors.surfaceElevated,
        child: const Icon(Icons.videocam, color: AppColors.textSecondary),
      );
    }
    return SizedBox(
      width: 48,
      height: 48,
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }
}
