import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OverlayMessage {
  static void show({
    required BuildContext context,
    required String message,
    required bool isError,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) =>
          _OverlayMessageWidget(message: message, isError: isError),
    );

    overlay.insert(overlayEntry);

    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }
}

class _OverlayMessageWidget extends StatefulWidget {
  final String message;
  final bool isError;

  const _OverlayMessageWidget({required this.message, required this.isError});

  @override
  State<_OverlayMessageWidget> createState() => _OverlayMessageWidgetState();
}

class _OverlayMessageWidgetState extends State<_OverlayMessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Reverse animation before dismissal
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50.h,
      left: 16.w,
      right: 16.w,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isError
                      ? [const Color(0xFFFF6B6B), const Color(0xFFEE5A6F)]
                      : [const Color(0xFF4CAF50), const Color(0xFF45B649)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: widget.isError
                        ? const Color(0xFFFF6B6B).withValues(alpha: 0.4)
                        : const Color(0xFF4CAF50).withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.isError
                          ? Icons.error_outline
                          : Icons.check_circle_outline,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
