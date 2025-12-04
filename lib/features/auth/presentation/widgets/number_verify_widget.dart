import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wimo/features/auth/presentation/cubit/auth_phone_cubit/auth_phone_cubit.dart';
import 'package:wimo/features/auth/presentation/cubit/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:wimo/features/auth/presentation/widgets/overlay_message.dart';
import 'package:wimo/features/auth/presentation/widgets/otp_input_bottom_sheet.dart';

class NumberVerifyWidget extends StatefulWidget {
  const NumberVerifyWidget({super.key});

  @override
  State<NumberVerifyWidget> createState() => _NumberVerifyWidgetState();
}

class _NumberVerifyWidgetState extends State<NumberVerifyWidget> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthPhoneCubit, AuthPhoneState>(
      listener: (context, state) {
        if (state is AuthPhoneSuccess) {
          // Show success message
          OverlayMessage.show(
            context: context,
            message: 'OTP sent to ${state.phone}',
            isError: false,
          );

          // Wait for 2 seconds before opening bottom sheet
          Future.delayed(const Duration(seconds: 3), () {
            if (context.mounted) {
              // Show OTP input bottom sheet
              final verifyOtpCubit = context.read<VerifyOtpCubit>();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => BlocProvider.value(
                  value: verifyOtpCubit,
                  child: OtpInputBottomSheet(phoneNumber: state.phone),
                ),
              );
            }
          });
        } else if (state is AuthPhoneError) {
          OverlayMessage.show(
            context: context,
            message: state.errorMessage,
            isError: true,
          );
        }
      },
      child: BlocBuilder<AuthPhoneCubit, AuthPhoneState>(
        builder: (context, state) {
          return Padding(
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
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Verify your phone number",
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(height: 24.h),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    hintText: "+1 xxx xxx xxx",
                    hintStyle: TextStyle(fontSize: 16.sp),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  enabled: state is! AuthPhoneLoading,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      context.read<AuthPhoneCubit>().sendOtp(phone: value);
                    }
                  },
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: 200.w,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: state is AuthPhoneLoading
                        ? null
                        : () {
                            final phone = _phoneController.text.trim();
                            if (phone.isNotEmpty) {
                              context.read<AuthPhoneCubit>().sendOtp(
                                phone: phone,
                              );
                            } else {
                              OverlayMessage.show(
                                context: context,
                                message: 'Please enter a phone number',
                                isError: true,
                              );
                            }
                          },
                    child: state is AuthPhoneLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text("Next", style: TextStyle(fontSize: 16.sp)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
