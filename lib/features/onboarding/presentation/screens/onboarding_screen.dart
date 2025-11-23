import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wimo/core/utils/color_utils.dart';
import 'package:wimo/features/home/presentation/screens/home_screen.dart';
import 'package:wimo/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:wimo/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:wimo/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:wimo/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:wimo/features/onboarding/presentation/widgets/onboarding_page_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OnboardingBloc(repository: OnboardingRepositoryImpl())
            ..add(OnboardingStarted()),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state.isCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
        // Check if PageController is attached and has clients before accessing page
        if (_pageController.hasClients) {
          final currentPageIndex = _pageController.page?.round() ?? 0;
          if (state.currentPage != currentPageIndex) {
            _pageController.animateToPage(
              state.currentPage,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        }
      },
      builder: (context, state) {
        if (state.items.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        context.read<OnboardingBloc>().add(
                          OnboardingSkipPressed(),
                        );
                      },
                      child: Text(
                        'Skip',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      context.read<OnboardingBloc>().add(
                        OnboardingPageChanged(index),
                      );
                    },
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      return OnboardingPageWidget(item: state.items[index]);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: state.items.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: ColorUtils.hexToColor(
                            state.items[state.currentPage].colorHex,
                          ),
                          dotColor: Colors.grey.shade300,
                          dotHeight: 8.h,
                          dotWidth: 8.w,
                          expansionFactor: 4,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 45.h,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<OnboardingBloc>().add(
                              OnboardingNextPressed(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorUtils.hexToColor(
                              state.items[state.currentPage].colorHex,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            state.isLastPage ? 'Get Started' : 'Next',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  fontSize: 22.sp,
                                  color: Colors.white,
                                ),
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
      },
    );
  }
}
