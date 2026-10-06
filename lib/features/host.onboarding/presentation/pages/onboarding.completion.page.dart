import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.text.styles.dart';
import '../widgets/continuous.button.widget.dart';

class OnboardingCompletionPage extends StatelessWidget {
  const OnboardingCompletionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 90,
                height: 90,
                decoration: ShapeDecoration(
                  color: AppColors.surfaceSecondary,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: const BorderSide(color: AppColors.accentPurple, width: 2),
                  ),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.accentPurpleLight,
                  size: 48,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Application Submitted',
                style: AppTextStyles.h1Bold.copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Thank you for applying to host with 8club. Our team will review your application and get back to you shortly.',
                style: AppTextStyles.b1Regular.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ContinuousButtonWidget(
                label: 'Back to Start',
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
