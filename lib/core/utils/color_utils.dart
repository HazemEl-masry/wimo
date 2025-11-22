import 'package:flutter/material.dart';

/// Utility class for color operations
class ColorUtils {
  ColorUtils._();

  /// Converts a hex color string to a Color object
  ///
  /// Example: hexToColor('#FF5733') returns Color(0xFFFF5733)
  static Color hexToColor(String hex) {
    return Color(int.parse(hex.replaceAll('#', '0xFF')));
  }

  /// Creates a lighter shade of the given color
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Creates a darker shade of the given color
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}
