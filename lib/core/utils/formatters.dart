import 'package:flutter/services.dart';

/// Text input formatters
class Formatters {
  Formatters._();

  /// Phone number formatter - allows only + and digits
  static final phoneFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[+0-9]'),
  );

  /// Digits only formatter
  static final digitsOnlyFormatter = FilteringTextInputFormatter.digitsOnly;

  /// Letters only formatter
  static final lettersOnlyFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z\s]'),
  );

  /// Email formatter - allows alphanumeric, @, dot, underscore, hyphen
  static final emailFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9@._-]'),
  );

  /// OTP formatter - 6 digits only
  static final otpFormatter = LengthLimitingTextInputFormatter(6);

  /// No spaces formatter
  static final noSpacesFormatter = FilteringTextInputFormatter.deny(
    RegExp(r'\s'),
  );

  /// Format phone number for display (e.g., +1234567890 → +123 456 7890)
  static String formatPhoneDisplay(String phone) {
    if (phone.isEmpty) return phone;

    // Remove all spaces first
    final cleaned = phone.replaceAll(' ', '');

    if (!cleaned.startsWith('+')) return phone;

    if (cleaned.length < 5) return cleaned;

    // Format as: +CC XXX XXX XXXX
    final countryCode = cleaned.substring(0, min(cleaned.length, 3));
    final remaining = cleaned.substring(min(cleaned.length, 3));

    if (remaining.isEmpty) return countryCode;

    final formatted = StringBuffer(countryCode);
    formatted.write(' ');

    // Split remaining into groups of 3
    for (int i = 0; i < remaining.length; i += 3) {
      final end = min(i + 3, remaining.length);
      formatted.write(remaining.substring(i, end));
      if (end < remaining.length) formatted.write(' ');
    }

    return formatted.toString();
  }

  /// Get T min value
  static T min<T extends Comparable>(T a, T b) => a.compareTo(b) < 0 ? a : b;
}
