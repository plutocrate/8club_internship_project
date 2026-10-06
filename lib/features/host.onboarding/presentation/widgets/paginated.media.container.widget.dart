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
  bool _hadVideo = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = widget.state.audioPhase == AudioRecordingPhase.recording;
    final hasRecordedAudio = widget.state.audioPhase == AudioRecordingPhase.recorded;
    final hasVideo = widget.state.videoPath != null;

    final List<Widget> pages = [];

    // Recording audio takes top priority while active
    if (isRecording) {
      return AudioRecorderBarWidget(
        duration: widget.state.recordingDuration,
        amplitudes: widget.state.waveformAmplitudes,
        onStop: widget.viewModel.stopAudioRecording,
      );
    }

    if (hasRecordedAudio) {
      pages.add(
        AudioPlayerBarWidget(
          durationText: widget.state.formattedDuration,
          isPlaying: widget.state.isPlayingAudio,
          onPlayToggle: () {
            if (widget.state.isPlayingAudio) {
              widget.viewModel.stopAudioPlayback();
            } else {
              widget.viewModel.playAudioRecording();
            }
          },
          onDelete: widget.viewModel.deleteAudioRecording,
        ),
      );
    }

    if (hasVideo) {
      pages.add(
        VideoPlayerBarWidget(
          videoPath: widget.state.videoPath,
          onDelete: widget.viewModel.deleteVideoRecording,
        ),
      );
    }

    if (pages.isEmpty) return const SizedBox.shrink();

    // Auto-scroll to newly recorded video if video was just added
    if (hasVideo && !_hadVideo && pages.length > 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
    _hadVideo = hasVideo;

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
