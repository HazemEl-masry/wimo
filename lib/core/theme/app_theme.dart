// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wimo/core/constants/app_constants.dart';

// /// Application theme configuration
// class AppTheme {
//   AppTheme._();

//   // Color palette
//   static const Color primaryColor = Color(0xFF2D3142);
//   static const Color secondaryColor = Color(0xFF4F5D75);
//   static const Color accentColor = Color(0xFF00A8E8);
//   static const Color backgroundColor = Color(0xFFFAFAFA);
//   static const Color surfaceColor = Color(0xFFFFFFFF);
//   static const Color errorColor = Color(0xFFD32F2F);
//   static const Color successColor = Color(0xFF388E3C);

//   // Text colors
//   static const Color textPrimary = Color(0xFF2D3142);
//   static const Color textSecondary = Color(0xFF757575);
//   static const Color textDisabled = Color(0xFFBDBDBD);
//   static const Color textOnPrimary = Color(0xFFFFFFFF);

//   // Grey shades
//   static const Color grey50 = Color(0xFFFAFAFA);
//   static const Color grey100 = Color(0xFFF5F5F5);
//   static const Color grey200 = Color(0xFFEEEEEE);
//   static const Color grey300 = Color(0xFFE0E0E0);
//   static const Color grey400 = Color(0xFFBDBDBD);
//   static const Color grey600 = Color(0xFF757575);
//   static const Color grey700 = Color(0xFF616161);

//   /// Light theme configuration
//   static ThemeData get lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.light,
//       colorScheme: const ColorScheme.light(
//         primary: primaryColor,
//         secondary: secondaryColor,
//         surface: surfaceColor,
//         error: errorColor,
//       ),
//       scaffoldBackgroundColor: backgroundColor,

//       // App Bar Theme
//       appBarTheme: AppBarTheme(
//         backgroundColor: surfaceColor,
//         foregroundColor: textPrimary,
//         elevation: 0,
//         centerTitle: true,
//         titleTextStyle: TextStyle(
//           color: textPrimary,
//           fontSize: AppConstants.fontSizeLarge,
//           fontWeight: FontWeight.w600,
//         ),
//       ),

//       // Text Theme
//       textTheme: TextTheme(
//         displayLarge: TextStyle(
//           fontSize: AppConstants.fontSizeXXLarge,
//           fontWeight: FontWeight.bold,
//           color: textPrimary,
//           height: 1.2,
//         ),
//         displayMedium: TextStyle(
//           fontSize: AppConstants.fontSizeXLarge + 4,
//           fontWeight: FontWeight.bold,
//           color: textPrimary,
//           height: 1.2,
//         ),
//         displaySmall: TextStyle(
//           fontSize: AppConstants.fontSizeXLarge,
//           fontWeight: FontWeight.bold,
//           color: textPrimary,
//           height: 1.2,
//         ),
//         headlineMedium: TextStyle(
//           fontSize: AppConstants.fontSizeLarge + 2,
//           fontWeight: FontWeight.w600,
//           color: textPrimary,
//         ),
//         titleLarge: TextStyle(
//           fontSize: AppConstants.fontSizeLarge,
//           fontWeight: FontWeight.w600,
//           color: textPrimary,
//         ),
//         titleMedium: TextStyle(
//           fontSize: AppConstants.fontSizeMedium,
//           fontWeight: FontWeight.w500,
//           color: textPrimary,
//         ),
//         bodyLarge: TextStyle(
//           fontSize: AppConstants.fontSizeMedium,
//           color: textPrimary,
//           height: 1.5,
//         ),
//         bodyMedium: TextStyle(
//           fontSize: AppConstants.fontSizeMedium,
//           color: textSecondary,
//           height: 1.6,
//         ),
//         bodySmall: TextStyle(
//           fontSize: AppConstants.fontSizeSmall,
//           color: textSecondary,
//         ),
//         labelLarge: TextStyle(
//           fontSize: AppConstants.fontSizeMedium,
//           fontWeight: FontWeight.w600,
//           color: textOnPrimary,
//         ),
//       ),

//       // Elevated Button Theme
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           foregroundColor: textOnPrimary,
//           backgroundColor: primaryColor,
//           elevation: 0,
//           padding: EdgeInsets.symmetric(
//             horizontal: AppConstants.spacingLarge,
//             vertical: AppConstants.spacingMedium,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
//           ),
//           textStyle: TextStyle(
//             fontSize: AppConstants.fontSizeLarge,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),

//       // Text Button Theme
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: textSecondary,
//           textStyle: TextStyle(
//             fontSize: AppConstants.fontSizeMedium,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),

//       // Input Decoration Theme
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: grey100,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
//           borderSide: BorderSide(color: primaryColor, width: 2.w),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
//           borderSide: BorderSide(color: errorColor, width: 1.w),
//         ),
//         contentPadding: EdgeInsets.symmetric(
//           horizontal: AppConstants.spacingMedium,
//           vertical: AppConstants.spacingMedium,
//         ),
//       ),

//       // Card Theme
//       cardTheme: CardThemeData(
//         elevation: 0,
//         color: surfaceColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
//         ),
//       ),

//       // Divider Theme
//       dividerTheme: const DividerThemeData(
//         color: grey200,
//         thickness: 1,
//         space: 1,
//       ),
//     );
//   }

//   /// Dark theme configuration (for future use)
//   static ThemeData get darkTheme {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.dark,
//       colorScheme: const ColorScheme.dark(
//         primary: accentColor,
//         secondary: secondaryColor,
//         surface: Color(0xFF1E1E1E),
//         error: errorColor,
//       ),
//       scaffoldBackgroundColor: const Color(0xFF121212),
//     );
//   }
// }
