import 'package:flutter/material.dart';

/// AcademixStore App Color Palette
/// Professional Black, White, and Golden theme with Dark/Light mode support
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors - Dark Mode
  static const Color primaryBlack = Color(0xFF0A0A0A); // Deep black
  static const Color secondaryBlack = Color(0xFF1A1A1A); // Lighter black
  static const Color tertiaryBlack = Color(0xFF2D2D2D); // Card background

  // Primary Colors - Light Mode
  static const Color primaryWhite = Color(0xFFFFFFFF); // Pure white
  static const Color secondaryWhite = Color(0xFFF8F9FA); // Light grey white
  static const Color tertiaryWhite = Color(0xFFF0F0F0); // Card background light

  static const Color primaryGold = Color(0xFFD4AF37); // Classic gold
  static const Color lightGold = Color(0xFFE8C547); // Bright gold
  static const Color darkGold = Color(0xFFB8941E); // Deep gold
  static const Color paleGold = Color(0xFFF5E6C8); // Pale gold for accents

  static const Color pureWhite = Color(0xFFFFFFFF); // Pure white
  static const Color offWhite = Color(0xFFF5F5F5); // Off white
  static const Color lightGrey = Color(0xFFE0E0E0); // Light grey
  static const Color mediumGrey = Color(0xFF9E9E9E); // Medium grey
  static const Color darkGrey = Color(0xFF424242); // Dark grey
  static const Color pureBlack = Color(0xFF000000); // Pure black

  // Dynamic colors based on theme
  static Color getBackgroundColor(bool isDark) =>
      isDark ? primaryBlack : primaryWhite;
  static Color getSecondaryBackground(bool isDark) =>
      isDark ? secondaryBlack : secondaryWhite;
  static Color getCardBackground(bool isDark) =>
      isDark ? tertiaryBlack : tertiaryWhite;
  static Color getTextPrimary(bool isDark) =>
      isDark ? pureWhite : pureBlack;
  static Color getTextSecondary(bool isDark) =>
      isDark ? lightGrey : darkGrey;
  static Color getTextTertiary(bool isDark) =>
      isDark ? mediumGrey : mediumGrey;

  // Gradient Combinations - Dark Mode
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A0A0A), // Deep black
      Color(0xFF1A1A1A), // Secondary black
      Color(0xFF2D2D2D), // Tertiary black
    ],
  );

  // Gradient Combinations - Light Mode
  static const LinearGradient primaryGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF), // Pure white
      Color(0xFFF8F9FA), // Light grey white
      Color(0xFFF0F0F0), // Tertiary white
    ],
  );

  // Dynamic gradient based on theme
  static LinearGradient getPrimaryGradient(bool isDark) =>
      isDark ? primaryGradient : primaryGradientLight;

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE8C547), // Light gold
      Color(0xFFD4AF37), // Primary gold
      Color(0xFFB8941E), // Dark gold
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFD4AF37), // Primary gold
      Color(0xFFE8C547), // Light gold
      Color(0xFFD4AF37), // Primary gold
    ],
  );

  // Radial Gradients for backgrounds
  static RadialGradient backgroundRadialGradient = RadialGradient(
    center: Alignment.topRight,
    radius: 1.5,
    colors: [
      primaryGold.withValues(alpha: 0.1),
      Colors.transparent,
    ],
  );

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color error = Color(0xFFE53935); // Red
  static const Color warning = Color(0xFFFFA726); // Orange
  static const Color info = Color(0xFF29B6F6); // Blue

  // Text Colors - Legacy (for backward compatibility)
  static const Color textPrimary = pureWhite;
  static const Color textSecondary = lightGrey;
  static const Color textTertiary = mediumGrey;
  static const Color textOnGold = primaryBlack;
  static const Color textOnWhite = primaryBlack;
  
  // Icon Colors - Legacy
  static const Color iconPrimary = pureWhite;
  static const Color iconSecondary = lightGrey;
  static const Color iconGold = primaryGold;
  static const Color iconDisabled = darkGrey;

  // Component Colors - Dynamic
  static Color getCardBackgroundTransparent(bool isDark) =>
      isDark ? pureWhite.withValues(alpha: 0.05) : pureWhite.withValues(alpha: 0.9);
  static Color getOverlayBackground(bool isDark) =>
      isDark ? primaryBlack.withValues(alpha: 0.8) : pureWhite.withValues(alpha: 0.95);
  
  static Color getDivider(bool isDark) =>
      isDark ? darkGrey : Color(0xFFE0E0E0);
  static Color getDividerLight(bool isDark) =>
      isDark ? pureWhite.withValues(alpha: 0.1) : pureBlack.withValues(alpha: 0.08);
  
  static Color getBorder(bool isDark) =>
      isDark ? darkGrey : Color(0xFFE0E0E0);
  static Color getBorderLight(bool isDark) =>
      isDark ? pureWhite.withValues(alpha: 0.2) : pureBlack.withValues(alpha: 0.1);
  static Color getBorderGold(bool isDark) =>
      primaryGold.withValues(alpha: isDark ? 0.5 : 0.7);

  // Legacy static colors (for backward compatibility)
  static const Color cardBackground = tertiaryBlack;
  static Color cardBackgroundTransparent = pureWhite.withValues(alpha: 0.05);
  static Color overlayBackground = primaryBlack.withValues(alpha: 0.8);
  
  static const Color divider = darkGrey;
  static Color dividerLight = pureWhite.withValues(alpha: 0.1);
  
  static const Color border = darkGrey;
  static Color borderLight = pureWhite.withValues(alpha: 0.2);
  static Color borderGold = primaryGold.withValues(alpha: 0.5);

  // Button Colors
  static const Color buttonPrimary = primaryGold;
  static const Color buttonSecondary = tertiaryBlack;
  static const Color buttonDisabled = darkGrey;
  static const Color buttonTextPrimary = primaryBlack;
  static const Color buttonTextSecondary = pureWhite;

  // Input Field Colors
  static Color inputFill = pureWhite.withValues(alpha: 0.05);
  static Color inputFillFocused = pureWhite.withValues(alpha: 0.1);
  static const Color inputBorder = darkGrey;
  static Color inputBorderFocused = primaryGold;
  static const Color inputText = pureWhite;
  static const Color inputLabel = lightGrey;
  static const Color inputHint = mediumGrey;

  // Shadow Colors
  static Color shadowLight = primaryBlack.withValues(alpha: 0.2);
  static Color shadowMedium = primaryBlack.withValues(alpha: 0.4);
  static Color shadowDark = primaryBlack.withValues(alpha: 0.6);
  static Color goldGlow = primaryGold.withValues(alpha: 0.3);
  static Color goldGlowStrong = primaryGold.withValues(alpha: 0.5);
  
  // Dynamic Shadow Colors
  static Color getShadowLight(bool isDark) =>
      primaryBlack.withValues(alpha: isDark ? 0.2 : 0.1);
  static Color getShadowMedium(bool isDark) =>
      primaryBlack.withValues(alpha: isDark ? 0.4 : 0.15);
  static Color getShadowDark(bool isDark) =>
      primaryBlack.withValues(alpha: isDark ? 0.6 : 0.2);

  // Dynamic Icon Colors
  static Color getIconPrimary(bool isDark) =>
      isDark ? pureWhite : pureBlack;
  static Color getIconSecondary(bool isDark) =>
      isDark ? lightGrey : darkGrey;

  // Status Bar & Navigation
  static const Color statusBarColor = Colors.transparent;
  static const Brightness statusBarIconBrightness = Brightness.light;
  static const Color navigationBarColor = primaryBlack;

  // Shimmer Effect Colors (for loading states)
  static Color shimmerBase = darkGrey;
  static Color shimmerHighlight = mediumGrey;

  // Premium/VIP Colors
  static const Color premiumGold = Color(0xFFFFD700); // Bright gold
  static const Color vipGold = Color(0xFFFFC107); // Amber gold

  // Helper Methods
  
  /// Returns a BoxShadow with gold glow effect
  static BoxShadow goldGlowShadow({double blurRadius = 20, double spreadRadius = 5}) {
    return BoxShadow(
      color: goldGlow,
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    );
  }

  /// Returns a BoxShadow with strong gold glow effect
  static BoxShadow goldGlowStrongShadow({double blurRadius = 30, double spreadRadius = 10}) {
    return BoxShadow(
      color: goldGlowStrong,
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    );
  }

  /// Returns a BoxShadow for elevated cards
  static BoxShadow cardShadow({double blurRadius = 20, Offset offset = const Offset(0, 10), bool isDark = true}) {
    return BoxShadow(
      color: getShadowMedium(isDark),
      blurRadius: blurRadius,
      offset: offset,
    );
  }

  /// Returns a BoxShadow for buttons
  static BoxShadow buttonShadow({double blurRadius = 15, Offset offset = const Offset(0, 5), bool isDark = true}) {
    return BoxShadow(
      color: getShadowLight(isDark),
      blurRadius: blurRadius,
      offset: offset,
    );
  }

  /// Returns a BoxDecoration for glassmorphic effect
  static BoxDecoration glassmorphicDecoration({
    double borderRadius = 20,
    Color? backgroundColor,
    Border? border,
    bool isDark = true,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? getCardBackgroundTransparent(isDark),
      borderRadius: BorderRadius.circular(borderRadius),
      border: border ?? Border.all(
        color: getBorderLight(isDark),
        width: isDark ? 1 : 1.5,
      ),
      boxShadow: [
        cardShadow(
          isDark: isDark,
          blurRadius: isDark ? 20 : 12,
          offset: isDark ? const Offset(0, 10) : const Offset(0, 4),
        ),
      ],
    );
  }

  /// Returns a BoxDecoration for glassmorphic effect (legacy - dark mode)
  static BoxDecoration glassmorphicDecorationDark({
    double borderRadius = 20,
    Color? backgroundColor,
    Border? border,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? cardBackgroundTransparent,
      borderRadius: BorderRadius.circular(borderRadius),
      border: border ?? Border.all(color: borderLight),
      boxShadow: [cardShadow()],
    );
  }

  /// Returns a BoxDecoration for gold accent containers
  static BoxDecoration goldAccentDecoration({
    double borderRadius = 20,
    bool withShadow = true,
  }) {
    return BoxDecoration(
      gradient: goldGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: withShadow ? [goldGlowShadow()] : null,
    );
  }

  /// Returns a BoxDecoration for primary containers
  static BoxDecoration primaryContainerDecoration({
    double borderRadius = 20,
    bool withBorder = true,
  }) {
    return BoxDecoration(
      color: cardBackground,
      borderRadius: BorderRadius.circular(borderRadius),
      border: withBorder ? Border.all(color: borderGold) : null,
      boxShadow: [cardShadow()],
    );
  }
}

/// Text Styles using App Colors
class AppTextStyles {
  AppTextStyles._();

  // Headings
  static const TextStyle h1 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.0,
  );

  static const TextStyle h3 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );

  static const TextStyle h4 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyMedium = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodySmall = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // Special Text
  static const TextStyle goldAccent = TextStyle(
    color: AppColors.primaryGold,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.0,
  );

  static const TextStyle buttonText = TextStyle(
    color: AppColors.buttonTextPrimary,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.0,
  );

  static const TextStyle caption = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 11,
    fontWeight: FontWeight.w300,
  );
}
