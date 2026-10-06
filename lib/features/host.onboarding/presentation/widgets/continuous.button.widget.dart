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
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            decoration: ShapeDecoration(
              gradient: isEnabled
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF444446),
                        Color(0xFF222224),
                      ],
                    )
                  : null,
              color: isEnabled ? null : AppColors.surfacePrimary,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(32),
                side: BorderSide(
                  color: isEnabled
                      ? const Color(0xFF5A5A5C)
                      : AppColors.borderSubtle,
                  width: isEnabled ? 1.2 : 1.0,
                ),
              ),
              shadows: isEnabled
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, -1),
                      ),
                    ]
                  : null,
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
