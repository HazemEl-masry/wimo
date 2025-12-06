import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wimo/core/routing/app_router.dart';

import 'package:wimo/core/widgets/overlay_message.dart';
import 'package:wimo/core/services/token_service.dart';
import 'package:wimo/core/di/injection_container.dart';
import 'package:wimo/features/settings/presentation/widgets/settings_list_item.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wimo/features/app/presentation/cubit/app_state_cubit.dart';
import 'package:wimo/features/user/presentation/cubit/profile_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _cachedPhone;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // 1. Refresh profile from API (background)
    context.read<ProfileCubit>().loadProfile();

    // 2. Get cached phone from token (immediate display)
    final phone = await sl<TokenService>().getPhoneFromToken();
    if (mounted && phone != null) {
      setState(() {
        _cachedPhone = phone;
      });
    }
  }

  List<SettingsListItem> getItems(BuildContext context, ProfileState state) {
    String name = 'User';
    String phone = _cachedPhone ?? '';

    if (state is ProfileLoaded) {
      name = state.user.name ?? 'User';
      // API data takes precedence if available
      if (state.user.phone.isNotEmpty) {
        phone = state.user.phone;
      }
    }

    return [
      SettingsListItem(
        leading: const Icon(Icons.person),
        title: name,
        subtitle: phone.isNotEmpty ? phone : 'Loading...',
        onTap: () {},
      ),
      SettingsListItem(
        leading: const Icon(Icons.shield_outlined),
        title: 'Privacy',
        onTap: () {
          // TODO: Navigate to privacy settings
          OverlayMessage.show(
            context: context,
            message: 'Privacy settings coming soon',
            isError: false,
          );
        },
      ),
      SettingsListItem(
        leading: const Icon(Icons.backup),
        title: 'Backup & Restore',
        onTap: () => AppRouter.router.push(AppRouter.backupAndRestore),
      ),
      SettingsListItem(
        leading: const Icon(Icons.logout),
        title: 'Logout',
        onTap: () async {
          await context.read<AppStateCubit>().logout();
          if (context.mounted) {
            OverlayMessage.show(
              context: context,
              message: 'Logged out successfully',
              isError: false,
            );
          }
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final items = getItems(context, state);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return items[index];
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 16.h);
              },
              itemCount: items.length,
            ),
          );
        },
      ),
    );
  }
}
