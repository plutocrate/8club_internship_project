import 'package:flutter/material.dart';
import '../../../../core/constants/app.colors.dart';

class StampScrollIndicatorWidget extends StatefulWidget {
  final ScrollController scrollController;

  const StampScrollIndicatorWidget({
    super.key,
    required this.scrollController,
  });

  @override
  State<StampScrollIndicatorWidget> createState() =>
      _StampScrollIndicatorWidgetState();
}

class _StampScrollIndicatorWidgetState
    extends State<StampScrollIndicatorWidget> {
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;
    final currentScroll = widget.scrollController.offset.clamp(0.0, maxScroll);
    setState(() {
      _scrollProgress = currentScroll / maxScroll;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double trackWidth = 44.0;
    const double thumbWidth = 14.0;
    const double maxThumbOffset = trackWidth - thumbWidth;
    final double thumbPosition = _scrollProgress * maxThumbOffset;

    return Center(
      child: Container(
        width: trackWidth,
        height: 3,
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 50),
              left: thumbPosition,
              child: Container(
                width: thumbWidth,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.accentPurpleLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
