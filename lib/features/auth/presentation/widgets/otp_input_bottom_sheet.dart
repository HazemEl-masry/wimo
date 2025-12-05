import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wimo/features/auth/presentation/cubit/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:wimo/features/auth/presentation/widgets/overlay_message.dart';

class OtpInputBottomSheet extends StatefulWidget {
  final String phoneNumber;

  const OtpInputBottomSheet({super.key, required this.phoneNumber});

  @override
  State<OtpInputBottomSheet> createState() => _OtpInputBottomSheetState();
}

class _OtpInputBottomSheetState extends State<OtpInputBottomSheet> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus on text field when sheet opens
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _verifyOtp(BuildContext context) {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      OverlayMessage.show(
        context: context,
        message: 'Please enter OTP code',
        isError: true,
      );
      return;
    }

    if (otp.length != 6) {
      OverlayMessage.show(
        context: context,
        message: 'OTP must be 6 digits',
        isError: true,
      );
      return;
    }

    context.read<VerifyOtpCubit>().verifyOtp(
      phone: widget.phoneNumber,
      otp: otp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyOtpCubit, VerifyOtpState>(
      listener: (context, state) {
        if (state is VerifyOtpSuccess) {
          OverlayMessage.show(
            context: context,
            message: 'OTP verified successfully!',
            isError: false,
          );

          // Wait for 2 seconds before closing
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              // Close bottom sheet
              Navigator.of(context).pop();

              // Navigate to home screen
              context.go('/home');
            }
          });
        } else if (state is VerifyOtpError) {
          OverlayMessage.show(
            context: context,
            message: state.errorMessage,
            isError: true,
          );
        }
      },
      child: BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
        builder: (context, state) {
          final isLoading = state is VerifyOtpLoading;

          return Container(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 24.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Title
                Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  'Enter the 6-digit code sent to',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.phoneNumber,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),

                // OTP Input Field
                TextField(
                  controller: _otpController,
                  focusNode: _focusNode,
                  enabled: !isLoading,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8.w,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '000000',
                    hintStyle: TextStyle(
                      color: Colors.grey[300],
                      letterSpacing: 8.w,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 20.h,
                    ),
                  ),
                  onSubmitted: (_) => _verifyOtp(context),
                ),
                SizedBox(height: 24.h),

                // Verify Button
                SizedBox(
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => _verifyOtp(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Verify OTP',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Resend OTP option
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          // TODO: Implement resend OTP
                          OverlayMessage.show(
                            context: context,
                            message: 'Resend OTP feature coming soon',
                            isError: false,
                          );
                        },
                  child: Text(
                    'Didn\'t receive code? Resend',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).primaryColor,
                    ),
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
