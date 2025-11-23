import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wimo/features/home/presentation/widgets/popup_menu_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: TextButton(
          onPressed: () {},
          child: Text("Wimo", style: TextStyle(fontSize: 24.sp)),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          const PopupMenuWidget(),
        ],
      ),
    );
  }
}
