import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart' as rive;
import 'package:wimo/features/auth/presentation/screens/auth_screen.dart';
import 'package:wimo/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:wimo/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:wimo/features/splash/presentation/cubit/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Start animation
    _animationController.forward();

    // Trigger splash check
    context.read<SplashCubit>().checkAndNavigate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToHome) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AuthScreen()),
          );
        } else if (state is SplashNavigateToOnboarding) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Enhanced Gradient Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6C63FF), // Purple
                    Color(0xFF8B5FFF), // Mid Purple
                    Color(0xFF00A8E8), // Blue
                    Color(0xFF0080C8), // Deep Blue
                  ],
                  stops: [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),

            // Decoration Image Overlay with Blend Mode
            Positioned.fill(
              child: Opacity(
                opacity: 0.15,
                child: SvgPicture.asset(
                  'assets/images/decortion_image.svg',
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.overlay,
                  ),
                ),
              ),
            ),

            // Floating Animated Circles for Depth
            Positioned(
              top: -50.h,
              right: -50.w,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: -80.h,
              left: -60.w,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 250.w,
                  height: 250.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo/App Name
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        children: [
                          // Enhanced App Icon/Logo with Glassmorphism
                          Container(
                            width: 140.w,
                            height: 140.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.3),
                                  Colors.white.withValues(alpha: 0.15),
                                ],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 40,
                                  offset: const Offset(0, 15),
                                  spreadRadius: -5,
                                ),
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(-5, -5),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: SizedBox(
                                width: 140.w,
                                height: 140.w,
                                child: rive.RiveAnimation.asset(
                                  'assets/animations/chat_animation.riv',
                                  fit: BoxFit.cover,
                                  onInit: (artboard) {
                                    final controller =
                                        rive.StateMachineController.fromArtboard(
                                          artboard,
                                          artboard.stateMachines.first.name,
                                        );
                                    if (controller != null) {
                                      artboard.addController(controller);
                                      // Ensure the state machine is playing
                                      controller.isActive = true;
                                    } else if (artboard.animations.isNotEmpty) {
                                      // Fallback to first animation if no state machine
                                      artboard.addController(
                                        rive.SimpleAnimation(
                                          artboard.animations.first.name,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 35.h),
                          // Enhanced App Name with Gradient
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withValues(alpha: 0.9),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              'Wimo',
                              style: GoogleFonts.pacifico(
                                fontSize: 64.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    offset: const Offset(0, 5),
                                    blurRadius: 15,
                                  ),
                                  Shadow(
                                    color: const Color(
                                      0xFF6C63FF,
                                    ).withValues(alpha: 0.5),
                                    offset: const Offset(0, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          // Enhanced Tagline with Background
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Stay Connected, Stay Close',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white.withValues(alpha: 0.95),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
