import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.text.styles.dart';
import '../../data/models/experience.model.dart';

class ExperienceStampWidget extends StatelessWidget {
  final Experience experience;
  final bool isSelected;
  final VoidCallback onTap;

  const ExperienceStampWidget({
    super.key,
    required this.experience,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 105,
        height: 125,
        decoration: ShapeDecoration(
          color: isSelected
              ? AppColors.surfaceElevated
              : AppColors.surfacePrimary,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: isSelected
                  ? AppColors.accentPurple
                  : AppColors.borderSubtle,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          shadows: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentPurple.withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: experience.iconUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accentPurple,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.local_activity,
                    color: isSelected
                        ? AppColors.accentPurpleLight
                        : AppColors.textSecondary,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                experience.name,
                style: AppTextStyles.s1Bold.copyWith(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
