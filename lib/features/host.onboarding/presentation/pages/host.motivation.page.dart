import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.gradients.dart';
import '../../../../core/constants/app.text.styles.dart';
import '../viewmodels/host.motivation.viewmodel.dart';
import '../widgets/continuous.button.widget.dart';
import '../widgets/focused.text.field.container.widget.dart';
import '../widgets/onboarding.progress.bar.widget.dart';
import '../widgets/paginated.media.container.widget.dart';
import 'onboarding.completion.page.dart';

class HostMotivationPage extends ConsumerStatefulWidget {
  const HostMotivationPage({super.key});

  @override
  ConsumerState<HostMotivationPage> createState() => _HostMotivationPageState();
}

class _HostMotivationPageState extends ConsumerState<HostMotivationPage> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: ref.read(hostMotivationViewModelProvider).motivationText,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onCancelPressed() {
    _textController.clear();
    ref.read(hostMotivationViewModelProvider.notifier).resetMotivation();
  }

  @override
  Widget build(BuildContext context) {
    final motivationState = ref.watch(hostMotivationViewModelProvider);
    final viewModel = ref.read(hostMotivationViewModelProvider.notifier);

    // Keep _textController in sync with motivationState.motivationText (e.g., when resetMotivation is called)
    if (_textController.text != motivationState.motivationText) {
      _textController.value = TextEditingValue(
        text: motivationState.motivationText,
        selection: TextSelection.collapsed(offset: motivationState.motivationText.length),
      );
    }

    final isRecording = motivationState.audioPhase == AudioRecordingPhase.recording;
    final hasAudioRecorded = motivationState.audioPhase == AudioRecordingPhase.recorded;
    final hasVideoRecorded = motivationState.videoPath != null;

    final double progress = motivationState.canProceed ? 1.0 : 0.5;
    final bool hasSelection = motivationState.motivationText.trim().isNotEmpty || motivationState.hasAudio || motivationState.hasVideo;
    final Color headingColor = hasSelection ? AppColors.textSecondary : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Top Header with lighter gradient background
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: ShapeDecoration(
                  gradient: AppGradients.topHeaderLight,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(color: AppColors.borderSubtle),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: OnboardingProgressBarWidget(progress: progress),
                      ),
                    ),
                    IconButton(
                      onPressed: _onCancelPressed,
                      icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '02',
                style: AppTextStyles.s1Regular.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: AppTextStyles.h1DynamicBold(context, color: headingColor),
                child: const Text(
                  'Why do you want to host with us?',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tell us about your intent and what motivates you to create experiences.',
                style: AppTextStyles.b2Regular.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FocusedTextFieldContainerWidget(
                  controller: _textController,
                  hintText: '/ Start typing here',
                  onChanged: viewModel.updateMotivationText,
                ),
              ),
              const SizedBox(height: 16),

              // Paginated Media Container ABOVE bottom buttons
              PaginatedMediaContainerWidget(
                state: motivationState,
                viewModel: viewModel,
              ),

              const SizedBox(height: 16),

              // Bottom Action Bar
              Row(
                children: [
                  // Icon Holder with transparent background & subtle border
                  Container(
                    height: 54,
                    decoration: ShapeDecoration(
                      color: Colors.transparent,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                        side: const BorderSide(color: AppColors.borderSubtle),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Mic Button: active recording sheen, or disabled when audio already recorded
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: isRecording
                              ? ShapeDecoration(
                                  gradient: AppGradients.micActiveSpotlight,
                                  shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    side: const BorderSide(
                                      color: Color(0xFF5A5A5E),
                                      width: 1.0,
                                    ),
                                  ),
                                )
                              : null,
                          child: IconButton(
                            onPressed: isRecording
                                ? viewModel.stopAudioRecording
                                : (hasAudioRecorded ? null : viewModel.startAudioRecording),
                            icon: SvgPicture.asset(
                              'assets/icons/mic.svg',
                              width: 16,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                isRecording
                                    ? AppColors.textPrimary
                                    : (hasAudioRecorded
                                        ? AppColors.textTertiary.withValues(alpha: 0.3)
                                        : AppColors.textSecondary),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        Container(width: 1, height: 24, color: AppColors.borderSubtle),
                        // Video Button: disabled when video already recorded
                        IconButton(
                          onPressed: hasVideoRecorded ? null : viewModel.recordVideo,
                          icon: SvgPicture.asset(
                            'assets/icons/recorder.svg',
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              hasVideoRecorded
                                  ? AppColors.textTertiary.withValues(alpha: 0.3)
                                  : AppColors.textSecondary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ContinuousButtonWidget(
                      label: 'Next',
                      svgIconPath: 'assets/icons/next.svg',
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
