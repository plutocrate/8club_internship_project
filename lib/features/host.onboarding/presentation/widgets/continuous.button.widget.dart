import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.text.styles.dart';

class ContinuousButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final IconData? icon;

  const ContinuousButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    this.icon,
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
            decoration: ShapeDecoration(
              color: isEnabled
                  ? AppColors.surfaceElevated
                  : AppColors.surfacePrimary,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(32),
                side: BorderSide(
                  color: isEnabled
                      ? AppColors.borderMedium
                      : AppColors.borderSubtle,
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
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    icon,
                    size: 18,
                    color: isEnabled
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
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
