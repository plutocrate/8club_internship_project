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

class HostMotivationPage extends ConsumerWidget {
  const HostMotivationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final motivationState = ref.watch(hostMotivationViewModelProvider);
    final viewModel = ref.read(hostMotivationViewModelProvider.notifier);
    final isRecording = motivationState.audioPhase == AudioRecordingPhase.recording;

    final double progress = motivationState.canProceed ? 1.0 : 0.5;

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
                      onPressed: () => Navigator.of(context).pop(),
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
                        // Mic Button with spotlight sheen during recording
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
                                : viewModel.startAudioRecording,
                            icon: SvgPicture.asset(
                              'assets/icons/mic.svg',
                              width: 16,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                isRecording
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        Container(width: 1, height: 24, color: AppColors.borderSubtle),
                        IconButton(
                          onPressed: viewModel.recordVideo,
                          icon: SvgPicture.asset(
                            'assets/icons/recorder.svg',
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                              AppColors.textSecondary,
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
