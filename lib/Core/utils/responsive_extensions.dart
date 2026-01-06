import 'package:flutter/material.dart';
import 'package:respix/respix.dart' as respix;

// Re-export respix so it's available when importing this file
export 'package:respix/respix.dart';

/// Extension methods to make respix work seamlessly like responsive_sizer
/// Respix already provides .w and .h getters on num type
/// We just need to wrap .sp() to work without explicit context
extension ResponsiveIntExtension on int {
  /// Get responsive font size
  /// Usage: 16.sp returns scaled font size
  /// This wraps respix's sp(context) method to work without explicit context
  double get sp {
    final context = _getContext();
    if (context == null) return toDouble();
    // Call respix's sp method with context
    return respix.ResponsiveNum(this).sp(context);
  }
}

extension ResponsiveDoubleExtension on double {
  /// Get responsive font size
  /// Usage: 16.0.sp returns scaled font size
  /// This wraps respix's sp(context) method to work without explicit context
  double get sp {
    final context = _getContext();
    if (context == null) return this;
    // Call respix's sp method with context
    return respix.ResponsiveNum(this).sp(context);
  }
}

/// Global navigator key to access context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Helper to get current context
BuildContext? _getContext() {
  return navigatorKey.currentContext;
}
