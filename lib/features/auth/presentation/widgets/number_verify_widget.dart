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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Phone Number",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Text("Verify your phone number", style: TextStyle(fontSize: 16.sp)),
            SizedBox(height: 24.h),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                hintText: "+1 xxx xxx xxx",
                hintStyle: TextStyle(fontSize: 16.sp),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}
