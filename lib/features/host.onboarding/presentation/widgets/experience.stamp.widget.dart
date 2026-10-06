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

  @override
  Widget build(BuildContext context) {
    final bool isLeft = widget.index % 2 == 0;
    final double baseAngle = isLeft ? -0.06 : 0.06;
    final double selectedExtraAngle = isLeft ? -0.05 : 0.05;
    final double targetAngle =
        widget.isSelected ? (baseAngle + selectedExtraAngle) : baseAngle;

    // Always prefer imageUrl which contains the full stamp artwork & event title
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
    );
  }
}
