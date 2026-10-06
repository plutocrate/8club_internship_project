import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';

class OnboardingProgressBarWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgressBarWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return Container(
      height: 4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.progressInactive,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.progressActive,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
