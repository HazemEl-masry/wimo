import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wimo/features/chat/presentation/cubit/messages_cubit.dart';

/// Message input widget with typing indicator support
class MessageInputWithTyping extends StatefulWidget {
  final String chatId;

  const MessageInputWithTyping({super.key, required this.chatId});

  @override
  State<MessageInputWithTyping> createState() => _MessageInputWithTypingState();
}

class _MessageInputWithTypingState extends State<MessageInputWithTyping> {
  final _controller = TextEditingController();
  bool _hasText = false;
  bool _isTyping = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<MessagesCubit>().sendMessage(
        chatId: widget.chatId,
        content: text,
      );
      _controller.clear();
      setState(() {
        _hasText = false;
        _isTyping = false;
      });
    }
  }

  void _handleTyping() {
    if (_controller.text.isNotEmpty && !_isTyping) {
      setState(() => _isTyping = true);
      context.read<MessagesCubit>().sendTyping();
    } else if (_controller.text.isEmpty && _isTyping) {
      setState(() => _isTyping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(fontSize: 15.sp),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 15.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onChanged: (text) {
                  setState(() => _hasText = text.trim().isNotEmpty);
                  _handleTyping();
                },
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            decoration: BoxDecoration(
              gradient: _hasText
                  ? const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    )
                  : null,
              color: _hasText ? null : Colors.grey[300],
              shape: BoxShape.circle,
              boxShadow: _hasText
                  ? [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: IconButton(
              onPressed: _hasText ? _handleSend : null,
              icon: Icon(
                Icons.send,
                color: _hasText ? Colors.white : Colors.grey[500],
                size: 22.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
