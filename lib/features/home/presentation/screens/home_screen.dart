import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wimo/features/home/presentation/cubit/chat_list_cubit.dart';
import 'package:wimo/features/home/presentation/widgets/chat_tile.dart';
import 'package:wimo/features/home/presentation/widgets/profile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Start listening to chat stream when screen is first opened
    context.read<ChatListCubit>().startListening();
  }

  @override
  void dispose() {
    // Stop listening when screen is disposed
    context.read<ChatListCubit>().stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 10.w),
        title: TextButton(
          onLongPress: () {},
          onPressed: () {},
          child: Text(
            "Wimo",
            style: GoogleFonts.pacifico(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).push('/settings');
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.dark_mode)),
          const ProfileWidget(),
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
                      context.read<ChatListCubit>().forceRefresh();
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
                context.read<ChatListCubit>().forceRefresh();
                // Give it a moment to reload
                await Future.delayed(const Duration(milliseconds: 500));
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
                      // TODO: Navigate to individual chat screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Chat screen not implemented yet'),
                          duration: Duration(seconds: 2),
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
          GoRouter.of(context).push('/contacts');
        },
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}
