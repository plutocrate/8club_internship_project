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

  Color _getSelectedColor(String name) {
    switch (name.toLowerCase()) {
      case 'party':
        return const Color(0xFF9E3B24); // Figma terracotta red
      case 'brunch':
        return const Color(0xFF2B5B84); // Figma teal blue
      case 'dinner':
        return const Color(0xFF3E4A3E); // Figma dark green/grey
      case 'fitness':
        return const Color(0xFF2E6F40); // Vibrant green
      case 'music':
        return const Color(0xFF6B3A82); // Deep purple
      case 'travel':
        return const Color(0xFF8A5A20); // Amber brown
      case 'picnic':
        return const Color(0xFF386B52); // Sage green
      case 'games':
        return const Color(0xFF8C3256); // Crimson rose
      default:
        return AppColors.accentPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedBgColor = _getSelectedColor(widget.experience.name);

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
            color: widget.isSelected ? selectedBgColor : AppColors.surfacePrimary,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: widget.isSelected
                    ? selectedBgColor.withValues(alpha: 0.9)
                    : AppColors.borderSubtle,
                width: widget.isSelected ? 2.0 : 1.0,
              ),
            ),
            shadows: widget.isSelected
                ? [
                    BoxShadow(
                      color: selectedBgColor.withValues(alpha: 0.5),
                      blurRadius: 16,
                      spreadRadius: 2,
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
