import 'package:flutter/material.dart';
import 'package:wimo/core/constants/app_constants.dart';
import 'package:wimo/core/utils/color_utils.dart';
import 'package:wimo/core/utils/responsive_utils.dart';
import 'package:wimo/features/onboarding/domain/entities/onboarding_item.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPageWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final color = ColorUtils.hexToColor(item.colorHex);

    // Get responsive sizes
    final outerCircleSize = ResponsiveUtils.getResponsiveValue(
      context: context,
      mobile: AppConstants.onboardingCircleLarge,
      tablet: AppConstants.onboardingCircleLarge * 1.2,
      desktop: AppConstants.onboardingCircleLarge * 1.5,
    );

    final innerCircleSize = ResponsiveUtils.getResponsiveValue(
      context: context,
      mobile: AppConstants.onboardingCircleMedium,
      tablet: AppConstants.onboardingCircleMedium * 1.2,
      desktop: AppConstants.onboardingCircleMedium * 1.5,
    );

    final iconSize = ResponsiveUtils.getResponsiveValue(
      context: context,
      mobile: AppConstants.iconSizeXXLarge,
      tablet: AppConstants.iconSizeXXLarge * 1.2,
      desktop: AppConstants.iconSizeXXLarge * 1.5,
    );

    final horizontalPadding = ResponsiveUtils.getResponsiveValue(
      context: context,
      mobile: AppConstants.spacingXXLarge,
      tablet: AppConstants.spacingXXLarge * 1.5,
      desktop: AppConstants.spacingXXLarge * 2,
    );

    final spacingAfterCircle = ResponsiveUtils.getResponsiveValue(
      context: context,
      mobile: AppConstants.spacingXXXLarge,
      tablet: AppConstants.spacingXXXLarge * 1.2,
      desktop: AppConstants.spacingXXXLarge * 1.5,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: outerCircleSize,
            height: outerCircleSize,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: innerCircleSize,
                height: innerCircleSize,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.view_in_ar_rounded,
                  size: iconSize,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: spacingAfterCircle),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context: context,
                baseFontSize: AppConstants.fontSizeXXLarge,
              ),
              color: const Color(0xFF2D3142),
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.getResponsiveValue(
              context: context,
              mobile: AppConstants.spacingLarge,
              tablet: AppConstants.spacingXLarge,
            ),
          ),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context: context,
                baseFontSize: AppConstants.fontSizeMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
