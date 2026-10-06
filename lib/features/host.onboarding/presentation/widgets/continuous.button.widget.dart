import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.gradients.dart';
import '../../../../core/constants/app.text.styles.dart';

class ContinuousButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final String? svgIconPath;

  const ContinuousButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    this.svgIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          customBorder: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: ShapeDecoration(
              gradient: isEnabled ? AppGradients.buttonEnabled : null,
              color: isEnabled ? null : AppColors.surfacePrimary,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(32),
                side: BorderSide(
                  color: isEnabled
                      ? const Color(0xFF68686C)
                      : AppColors.borderSubtle,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.b1Bold.copyWith(
                    color: isEnabled
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                ),
                if (svgIconPath != null) ...[
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    svgIconPath!,
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      isEnabled
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
