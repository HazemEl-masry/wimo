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
          return GestureDetector(
            onTap: () {
              // TODO: Navigate to profile screen
            },
            child: CircleAvatar(
              radius: 24.r,
              child: hasAvatar
                  ? CachedNetworkImage(
                      imageUrl: state.user.avatar!,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Icon(
                        Icons.person,
                        size: MediaQuery.of(context).size.width * 0.07,
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: MediaQuery.of(context).size.width * 0.07,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.width * 0.07,
                    ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
