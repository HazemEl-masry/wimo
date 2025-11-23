import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberVerifyWidget extends StatelessWidget {
  const NumberVerifyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height / 7,
          left: 16.w,
          right: 16.w,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 250.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned(
                    left: 10,
                    child: CircleAvatar(
                      radius: 35.r,
                      backgroundColor: const Color(0xFFA4D6FF),
                    ),
                  ),
                  Positioned(
                    left: 75.r,
                    top: 50.r,
                    child: CircleAvatar(
                      radius: 25.r,
                      backgroundColor: const Color(0xFFA4D6FF),
                    ),
                  ),
                ],
              ),
              Text(
                "Phone Number",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                "Enter your phone number to verify",
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
