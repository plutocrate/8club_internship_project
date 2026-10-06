import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.text.styles.dart';
import '../viewmodels/host.motivation.viewmodel.dart';
import '../widgets/audio.player.bar.widget.dart';
import '../widgets/audio.recorder.bar.widget.dart';
import '../widgets/continuous.button.widget.dart';
import '../widgets/focused.text.field.container.widget.dart';
import '../widgets/onboarding.progress.bar.widget.dart';
import '../widgets/video.player.bar.widget.dart';
import 'onboarding.completion.page.dart';

class HostMotivationPage extends ConsumerWidget {
  const HostMotivationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final motivationState = ref.watch(hostMotivationViewModelProvider);
    final viewModel = ref.read(hostMotivationViewModelProvider.notifier);
    final isRecording = motivationState.audioPhase == AudioRecordingPhase.recording;

    // Progress starts at 0.5 (Screen 2), fills to 1.0 when motivation response is provided
    final double progress = motivationState.canProceed ? 1.0 : 0.5;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: OnboardingProgressBarWidget(progress: progress),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '02',
                style: AppTextStyles.s1Regular.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: 4),
              Text(
                'Why do you want to host with us?',
                style: AppTextStyles.h1Bold.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Tell us about your intent and what motivates you to create experiences.',
                style: AppTextStyles.b2Regular.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FocusedTextFieldContainerWidget(
                  hintText: '/ Start typing here',
                  onChanged: viewModel.updateMotivationText,
                ),
              ),
              const SizedBox(height: 16),
              // Media Status Box ABOVE bottom buttons
              if (isRecording)
                AudioRecorderBarWidget(
                  duration: motivationState.recordingDuration,
                  amplitudes: motivationState.waveformAmplitudes,
                  onStop: viewModel.stopAudioRecording,
                )
              else if (motivationState.audioPhase == AudioRecordingPhase.recorded)
                AudioPlayerBarWidget(
                  durationText: motivationState.formattedDuration,
                  isPlaying: motivationState.isPlayingAudio,
                  onPlayToggle: () {
                    if (motivationState.isPlayingAudio) {
                      viewModel.stopAudioPlayback();
                    } else {
                      viewModel.playAudioRecording();
                    }
                  },
                  onDelete: viewModel.deleteAudioRecording,
                )
              else if (motivationState.videoPath != null)
                VideoPlayerBarWidget(
                  videoPath: motivationState.videoPath,
                  onDelete: viewModel.deleteVideoRecording,
                ),

              const SizedBox(height: 16),

              // Bottom Action Bar
              Row(
                children: [
                  Container(
                    height: 54,
                    decoration: ShapeDecoration(
                      color: AppColors.surfaceSecondary,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                        side: const BorderSide(color: AppColors.borderSubtle),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Mic Button with whitish/grey gradient during recording (matching enabled theme)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: isRecording
                              ? ShapeDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF4A4A4C),
                                      Color(0xFF28282A),
                                    ],
                                  ),
                                  shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    side: const BorderSide(
                                      color: Color(0xFF6E6E70),
                                      width: 1.2,
                                    ),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                    )
                                  ],
                                )
                              : null,
                          child: IconButton(
                            onPressed: isRecording
                                ? viewModel.stopAudioRecording
                                : viewModel.startAudioRecording,
                            icon: Icon(
                              isRecording ? Icons.mic : Icons.mic_none,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(width: 1, height: 24, color: AppColors.borderSubtle),
                        IconButton(
                          onPressed: viewModel.recordVideo,
                          icon: const Icon(
                            Icons.videocam_outlined,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ContinuousButtonWidget(
                      label: 'Next',
                      icon: Icons.subdirectory_arrow_left,
                      isEnabled: motivationState.canProceed,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const OnboardingCompletionPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
