import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wimo/features/home/presentation/widgets/popup_menu_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 50.h,
        backgroundColor: Colors.transparent,
        centerTitle: false,
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
          const PopupMenuWidget(),
        ],
      ),
    );
  }
}
