import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wimo/core/di/injection_container.dart';
import 'package:wimo/features/chat/presentation/cubit/messages_cubit.dart';
import 'package:wimo/features/chat/presentation/cubit/messages_state.dart';
import 'package:wimo/features/chat/presentation/widgets/date_separator.dart';
import 'package:wimo/features/chat/presentation/widgets/message_bubble.dart';
import 'package:wimo/features/chat/presentation/widgets/message_input_with_typing.dart';
import 'package:wimo/features/chat/presentation/widgets/typing_bubble.dart';
import 'package:wimo/features/app/presentation/cubit/app_state_cubit.dart';

/// Individual chat room screen
class ChatRoomScreen extends StatelessWidget {
  final String chatId;
  final String chatName;
  final String? chatAvatar;
  final bool isOnline;

  const ChatRoomScreen({
    super.key,
    required this.chatId,
    required this.chatName,
    this.chatAvatar,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MessagesCubit>()..loadMessages(chatId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            Expanded(child: _buildMessagesList()),
            MessageInputWithTyping(chatId: chatId),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: const Color(0xFF667EEA),
                child: Text(
                  chatName[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF38EF7D),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (isOnline)
                  Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF38EF7D),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          onPressed: () {
            // Show options menu
          },
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        if (state is MessagesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MessagesError) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<MessagesCubit>().loadMessages(chatId);
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64.w, color: Colors.red),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load messages',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        state.errorMessage,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<MessagesCubit>().loadMessages(chatId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is MessagesLoaded) {
          if (state.messages.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<MessagesCubit>().loadMessages(chatId);
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: Center(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 80.w,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No messages yet',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Start the conversation!',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<MessagesCubit>().loadMessages(chatId);
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                final currentUserId =
                    context.read<AppStateCubit>().state.currentUserId ?? '';
                final isMe = message.senderId == currentUserId;

                // Show date separator if needed
                final previousMessage = index < state.messages.length - 1
                    ? state.messages[index + 1]
                    : null;
                final showDateSeparator =
                    previousMessage == null ||
                    !_isSameDay(message.createdAt, previousMessage.createdAt);

                return Column(
                  children: [
                    if (showDateSeparator)
                      DateSeparator(date: message.createdAt),
                    MessageBubble(message: message, isMe: isMe),
                  ],
                );
              },
            ),
          );
        } else if (state is UserTyping) {
          // Show typing indicator with existing messages
          final messages = state.messages;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<MessagesCubit>().loadMessages(chatId);
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              itemCount: messages.length + 1, // +1 for typing indicator
              itemBuilder: (context, index) {
                // Show typing bubble at the top (index 0 in reversed list)
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                    child: Row(children: [const TypingBubble(isMe: false)]),
                  );
                }

                // Show messages (offset by 1 because of typing indicator)
                final message = messages[index - 1];
                final currentUserId =
                    context.read<AppStateCubit>().state.currentUserId ?? '';
                final isMe = message.senderId == currentUserId;

                final previousMessage = index - 1 < messages.length
                    ? messages[index]
                    : null;
                final showDateSeparator =
                    previousMessage == null ||
                    !_isSameDay(message.createdAt, previousMessage.createdAt);

                return Column(
                  children: [
                    if (showDateSeparator)
                      DateSeparator(date: message.createdAt),
                    MessageBubble(message: message, isMe: isMe),
                  ],
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
