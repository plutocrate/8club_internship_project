import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.text.styles.dart';
import '../providers/experiences.provider.dart';
import '../viewmodels/experience.selection.viewmodel.dart';
import '../widgets/continuous.button.widget.dart';
import '../widgets/experience.stamp.widget.dart';
import '../widgets/focused.text.field.container.widget.dart';
import '../widgets/onboarding.progress.bar.widget.dart';
import '../widgets/shimmer.stamp.widget.dart';
import 'host.motivation.page.dart';

class ExperienceSelectionPage extends ConsumerWidget {
  const ExperienceSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiencesAsync = ref.watch(experiencesProvider);
    final selectionState = ref.watch(experienceSelectionViewModelProvider);
    final viewModel = ref.read(experienceSelectionViewModelProvider.notifier);

    // Progress starts at 0.0, fills to 0.5 when at least 1 card is selected
    final double progress = selectionState.canProceed ? 0.5 : 0.0;

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
                  // Back button disabled on screen 1
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.textTertiary.withValues(alpha: 0.3),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: OnboardingProgressBarWidget(progress: progress),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '01',
                style: AppTextStyles.s1Regular.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: 4),
              Text(
                'What kind of experiences do you want to host?',
                style: AppTextStyles.h1Bold.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 130,
                child: experiencesAsync.when(
                  data: (experiences) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: experiences.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final item = experiences[index];
                        final isSelected = selectionState.selectedIds.contains(item.id);
                        return ExperienceStampWidget(
                          experience: item,
                          isSelected: isSelected,
                          onTap: () => viewModel.toggleExperience(item.id),
                        );
                      },
                    );
                  },
                  loading: () => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => const ShimmerStampWidget(),
                  ),
                  error: (err, stack) => Center(
                    child: Text(
                      'Failed to load experiences',
                      style: AppTextStyles.b2Regular.copyWith(color: AppColors.accentRed),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FocusedTextFieldContainerWidget(
                  hintText: '/ Describe your perfect hotspot',
                  onChanged: viewModel.updateDescription,
                ),
              ),
              const SizedBox(height: 16),
              ContinuousButtonWidget(
                label: 'Next',
                icon: Icons.subdirectory_arrow_left,
                isEnabled: selectionState.canProceed,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HostMotivationPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
