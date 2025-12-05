import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wimo/features/user/presentation/cubit/profile_cubit.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final hasAvatar =
              state.user.avatar != null && state.user.avatar!.isNotEmpty;
          final initial = state.user.name?.isNotEmpty == true
              ? state.user.name![0].toUpperCase()
              : state.user.phone.isNotEmpty
              ? state.user.phone[0]
              : '?';

          return GestureDetector(
            onTap: () {
              // TODO: Navigate to profile screen
            },
            child: CircleAvatar(
              radius: 24.r,
              backgroundImage: hasAvatar
                  ? CachedNetworkImageProvider(state.user.avatar!)
                  : null,
              child: !hasAvatar
                  ? Text(
                      initial,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          );
        }

        // Loading or error state - show default avatar
        return GestureDetector(
          onTap: () {},
          child: CircleAvatar(
            radius: 24.r,
            child: Icon(
              Icons.person,
              size: MediaQuery.of(context).size.width * 0.07,
            ),
          ),
        );
      },
    );
  }
}
