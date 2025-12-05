import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wimo/features/chat/presentation/cubit/chat_list_cubit.dart';
import 'package:wimo/features/chat/presentation/widgets/chat_tile.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    // Load chats when screen is first opened
    context.read<ChatListCubit>().loadChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Implement more options
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatListCubit, ChatListState>(
        builder: (context, state) {
          if (state is ChatListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    'Error loading chats',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ChatListCubit>().loadChats();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ChatListSuccess) {
            if (state.chats.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64.sp,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No chats yet',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Start a conversation',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<ChatListCubit>().refreshChats();
              },
              child: ListView.separated(
                itemCount: state.chats.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, indent: 72.w, endIndent: 16.w),
                itemBuilder: (context, index) {
                  final chat = state.chats[index];
                  return ChatTile(
                    chat: chat,
                    onTap: () {
                      // TODO: Navigate to chat screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Chat screen not implemented yet'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to new chat screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New chat feature coming soon'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}
