import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A typing indicator bubble widget with animated dots
///
/// Displays three dots that bounce up and down in sequence to indicate
/// that someone is typing. The appearance can be customized based on
/// whether it represents the current user or another user.
class TypingBubble extends StatefulWidget {
  /// Whether this typing bubble represents the current user
  final bool isMe;

  const TypingBubble({super.key, required this.isMe});

  @override
  State<TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<TypingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim1;
  late Animation<double> _anim2;
  late Animation<double> _anim3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _anim1 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    );
    _anim2 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.9, curve: Curves.easeInOut),
    );
    _anim3 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    );
  }

  Widget _buildDot(Animation<double> anim) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, child) {
        final translateY = -7 * anim.value;
        final scale = 0.6 + anim.value * 0.3;
        return Transform.translate(
          offset: Offset(0, translateY),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Container(
        width: 9.w,
        height: 18.h,
        decoration: BoxDecoration(
          color: widget.isMe ? Colors.white : Colors.grey.shade700,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor = widget.isMe ? Colors.blue : Colors.grey.shade300;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomLeft: Radius.circular(widget.isMe ? 16.r : 0),
          bottomRight: Radius.circular(widget.isMe ? 0 : 16.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(_anim1),
          SizedBox(width: 5.w),
          _buildDot(_anim2),
          SizedBox(width: 5.w),
          _buildDot(_anim3),
        ],
      ),
    );
  }
}
