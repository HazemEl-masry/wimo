import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wimo/features/home/presentation/widgets/profile_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.dark_mode)),
          const ProfileWidget(),
        ],
      ),
    );
  }
}
