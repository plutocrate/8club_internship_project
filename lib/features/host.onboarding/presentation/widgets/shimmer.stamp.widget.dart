import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app.colors.dart';

class ShimmerStampWidget extends StatelessWidget {
  const ShimmerStampWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfacePrimary,
      highlightColor: AppColors.surfaceSecondary,
      child: Container(
        width: 105,
        height: 125,
        decoration: ShapeDecoration(
          color: AppColors.surfacePrimary,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: AppColors.borderSubtle),
          ),
        ),
      ),
    );
  }
}
