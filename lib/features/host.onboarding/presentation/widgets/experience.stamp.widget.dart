import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.text.styles.dart';
import '../../data/models/experience.model.dart';

class ExperienceStampWidget extends StatefulWidget {
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
  State<ExperienceStampWidget> createState() => _ExperienceStampWidgetState();
}

class _ExperienceStampWidgetState extends State<ExperienceStampWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : (widget.isSelected ? 1.04 : 1.0),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 105,
          height: 125,
          decoration: ShapeDecoration(
            color: widget.isSelected
                ? AppColors.surfaceElevated
                : AppColors.surfacePrimary,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: widget.isSelected
                    ? AppColors.accentPurpleLight
                    : AppColors.borderSubtle,
                width: widget.isSelected ? 1.5 : 1.0,
              ),
            ),
            shadows: widget.isSelected
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
                    imageUrl: widget.isSelected && widget.experience.imageUrl.isNotEmpty
                        ? widget.experience.imageUrl
                        : widget.experience.iconUrl,
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
                    errorWidget: (context, url, error) => CachedNetworkImage(
                      imageUrl: widget.experience.iconUrl,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Icon(
                        Icons.local_activity,
                        color: widget.isSelected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        size: 36,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.experience.name,
                  style: AppTextStyles.s1Bold.copyWith(
                    color: widget.isSelected
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
      ),
    );
  }
}
