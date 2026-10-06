import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.gradients.dart';
import '../../../../core/constants/app.text.styles.dart';
import '../providers/experiences.provider.dart';
import '../viewmodels/experience.selection.viewmodel.dart';
import '../widgets/continuous.button.widget.dart';
import '../widgets/experience.stamp.widget.dart';
import '../widgets/focused.text.field.container.widget.dart';
import '../widgets/onboarding.progress.bar.widget.dart';
import '../widgets/shimmer.stamp.widget.dart';
import '../widgets/stamp.scroll.indicator.widget.dart';
import 'host.motivation.page.dart';

class ExperienceSelectionPage extends ConsumerStatefulWidget {
  const ExperienceSelectionPage({super.key});

  @override
  ConsumerState<ExperienceSelectionPage> createState() =>
      _ExperienceSelectionPageState();
}

class _ExperienceSelectionPageState
    extends ConsumerState<ExperienceSelectionPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onCancelPressed() {
    _textController.clear();
    ref.read(experienceSelectionViewModelProvider.notifier).resetSelection();
  }

  @override
  Widget build(BuildContext context) {
    final experiencesAsync = ref.watch(experiencesProvider);
    final selectionState = ref.watch(experienceSelectionViewModelProvider);
    final viewModel = ref.read(experienceSelectionViewModelProvider.notifier);

    final double progress = selectionState.canProceed ? 0.5 : 0.0;

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
                      onPressed: null,
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.textTertiary.withValues(alpha: 0.3),
                      ),
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
                '01',
                style: AppTextStyles.s1Regular.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: 4),
              Text(
                'What kind of hotspots do you want to host?',
                style: AppTextStyles.h1Bold.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 145,
                child: experiencesAsync.when(
                  data: (experiences) {
                    return ListView.separated(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: experiences.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final item = experiences[index];
                        final isSelected = selectionState.selectedIds.contains(item.id);
                        return ExperienceStampWidget(
                          experience: item,
                          index: index,
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
              const SizedBox(height: 10),

              // Subtle horizontal scrollbar indicator
              StampScrollIndicatorWidget(scrollController: _scrollController),

              const SizedBox(height: 16),
              Expanded(
                child: FocusedTextFieldContainerWidget(
                  controller: _textController,
                  hintText: '/ Describe your perfect hotspot',
                  onChanged: viewModel.updateDescription,
                ),
              ),
              const SizedBox(height: 16),
              ContinuousButtonWidget(
                label: 'Next',
                svgIconPath: 'assets/icons/next.svg',
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
