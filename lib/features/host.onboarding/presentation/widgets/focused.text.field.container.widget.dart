import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';
import '../../../../core/constants/app.text.styles.dart';

class FocusedTextFieldContainerWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;

  const FocusedTextFieldContainerWidget({
    super.key,
    required this.hintText,
    this.controller,
    required this.onChanged,
  });

  @override
  State<FocusedTextFieldContainerWidget> createState() =>
      _FocusedTextFieldContainerWidgetState();
}

class _FocusedTextFieldContainerWidgetState
    extends State<FocusedTextFieldContainerWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: AppColors.surfacePrimary,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: _isFocused
                ? AppColors.accentPurpleLight
                : AppColors.borderSubtle,
            width: _isFocused ? 1.5 : 1.0,
          ),
        ),
        shadows: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.accentPurple.withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        maxLines: null,
        expands: true,
        style: AppTextStyles.b1Regular.copyWith(color: AppColors.textPrimary),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.b1Regular.copyWith(
            color: AppColors.textPlaceholder,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          fillColor: Colors.transparent,
          filled: false,
        ),
      ),
    );
  }
}
