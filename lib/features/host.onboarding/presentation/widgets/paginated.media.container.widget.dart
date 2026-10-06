import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';
import '../viewmodels/host.motivation.viewmodel.dart';
import 'audio.player.bar.widget.dart';
import 'audio.recorder.bar.widget.dart';
import 'video.player.bar.widget.dart';

class PaginatedMediaContainerWidget extends StatefulWidget {
  final HostMotivationState state;
  final HostMotivationViewModel viewModel;

  const PaginatedMediaContainerWidget({
    super.key,
    required this.state,
    required this.viewModel,
  });

  @override
  State<PaginatedMediaContainerWidget> createState() =>
      _PaginatedMediaContainerWidgetState();
}

class _PaginatedMediaContainerWidgetState
    extends State<PaginatedMediaContainerWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _prevPageCount = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = widget.state.audioPhase == AudioRecordingPhase.recording;
    final List<Widget> pages = [];

    // Page for live audio recording if currently active
    if (isRecording) {
      pages.add(
        AudioRecorderBarWidget(
          duration: widget.state.activeRecordingDuration,
          amplitudes: widget.state.waveformAmplitudes,
          onStop: widget.viewModel.stopAudioRecording,
        ),
      );
    }

    // Pages for all recorded audio clips
    for (final item in widget.state.audioRecordings) {
      final isPlaying = widget.state.playingAudioId == item.id;
      pages.add(
        AudioPlayerBarWidget(
          durationText: item.formattedDuration,
          isPlaying: isPlaying,
          onPlayToggle: () {
            if (isPlaying) {
              widget.viewModel.stopAudioPlayback();
            } else {
              widget.viewModel.playAudioRecording(item.id, item.path);
            }
          },
          onDelete: () => widget.viewModel.deleteAudioRecording(item.id),
        ),
      );
    }

    // Pages for all recorded video clips
    for (final videoPath in widget.state.videoPaths) {
      pages.add(
        VideoPlayerBarWidget(
          videoPath: videoPath,
          onDelete: () => widget.viewModel.deleteVideoRecording(videoPath),
        ),
      );
    }

    if (pages.isEmpty) return const SizedBox.shrink();

    // Auto animate to newest page if items increased
    if (pages.length > _prevPageCount && _prevPageCount > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            pages.length - 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
    _prevPageCount = pages.length;

    if (pages.length == 1) {
      return pages.first;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 94,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: pages,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pages.length, (index) {
            final isSelected = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isSelected ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentPurpleLight
                    : AppColors.borderMedium,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
