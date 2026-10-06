import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';
import '../../data/models/experience.model.dart';

class ExperienceStampWidget extends StatefulWidget {
  final Experience experience;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const ExperienceStampWidget({
    super.key,
    required this.experience,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<ExperienceStampWidget> createState() => _ExperienceStampWidgetState();
}

class _ExperienceStampWidgetState extends State<ExperienceStampWidget> {
  bool _isPressed = false;

  // Standard greyscale transformation matrix
  static const ColorFilter _greyscaleFilter = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0,      0,      0,      1, 0,
  ]);

  static const ColorFilter _identityFilter =
      ColorFilter.mode(Colors.transparent, BlendMode.dst);

  @override
  Widget build(BuildContext context) {
    // Unselected = straight (0.0 rad), Selected = tilted alternating left (-0.07 rad) / right (0.07 rad)
    final bool isLeft = widget.index % 2 == 0;
    final double targetAngle = widget.isSelected
        ? (isLeft ? -0.07 : 0.07)
        : 0.0;

    final String stampImage = widget.experience.imageUrl.isNotEmpty
        ? widget.experience.imageUrl
        : widget.experience.iconUrl;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedRotation(
        turns: targetAngle / (2 * math.pi),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: AnimatedScale(
          scale: _isPressed ? 0.94 : (widget.isSelected ? 1.06 : 1.0),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: SizedBox(
            width: 120,
            height: 140,
            child: ColorFiltered(
              colorFilter: widget.isSelected ? _identityFilter : _greyscaleFilter,
              child: CachedNetworkImage(
                imageUrl: stampImage,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accentPurple,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => CachedNetworkImage(
                  imageUrl: widget.experience.iconUrl,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => const Icon(
                    Icons.local_activity,
                    color: AppColors.textSecondary,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
