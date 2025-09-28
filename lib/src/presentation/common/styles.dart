import 'package:flutter/material.dart';

/// Common UI styles used across presentation widgets.
class AppStyles {
  // Spacing
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 12.0;
  static const double largeSpacing = 16.0;

  // Image sizes
  static const double productImageSize = 60.0;
  static const double cartImageSize = 56.0;

  // Card
  static final ShapeBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );

  // Text styles
  static TextStyle productTitle(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium ?? const TextStyle(fontSize: 16);

  static TextStyle productSubtitle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall ?? const TextStyle(fontSize: 14, color: Colors.black87);

  // Icon sizes
  static const double defaultIconSize = 24.0;
}
