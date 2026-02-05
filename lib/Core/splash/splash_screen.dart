import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:academixstore/Core/utils/responsive_extensions.dart';
import 'package:academixstore/Core/auth/view/signin_screen.dart';
import 'package:academixstore/Core/auth/api/auth_api_services.dart';
import 'package:academixstore/Core/home/view/home_screen.dart';
import 'package:academixstore/Core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  final AuthApiServices _authApiServices = AuthApiServices();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();

    // Check authentication and navigate after animation
    _checkAuthAndNavigate();
  }

  /// Check if user is logged in and navigate to appropriate screen
  Future<void> _checkAuthAndNavigate() async {
    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 3500));

    if (!mounted) return;

    try {
      // Check if user is logged in
      final isLoggedIn = await _authApiServices.isLoggedIn();

      if (!mounted) return;

      // Navigate based on authentication status
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              isLoggedIn ? const HomeScreen() : const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    } catch (e) {
      // If there's an error checking auth, navigate to login screen
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get system brightness for splash screen
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    final isDark = brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getPrimaryGradient(isDark),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated background circles
              Positioned(
                top: -20.h,
                right: -20.w,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primaryGold.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -15.h,
                left: -15.w,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primaryGold.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with animation
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              AppColors.goldGlowStrongShadow(
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                AppColors.goldGlowShadow(
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/icon/ic_launcher.webp',
                              width: 30.w,
                              height: 30.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // App name with slide animation
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              "AcademixStore",
                              style: GoogleFonts.poppins(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.getTextPrimary(isDark),
                                letterSpacing: 2,
                                shadows: [
                                  Shadow(
                                    color: AppColors.primaryGold.withValues(
                                      alpha: isDark ? 0.5 : 0.3,
                                    ),
                                    offset: const Offset(0, 4),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              "Your Gateway to Knowledge",
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: isDark
                                    ? FontWeight.w300
                                    : FontWeight.w500,
                                color: isDark
                                    ? AppColors.paleGold
                                    : AppColors.darkGold,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Container(
                              width: 20.w,
                              height: 0.3.h,
                              decoration: BoxDecoration(
                                gradient: AppColors.accentGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Loading indicator
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 10.w,
                            height: 10.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 0.5.w,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primaryGold,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Loading...",
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: AppColors.getTextSecondary(isDark),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom branding
              Positioned(
                bottom: 4.h,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school,
                            color: AppColors.primaryGold,
                            size: 18.sp,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            "Empowering Education",
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              color: AppColors.getTextSecondary(isDark),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Version 1.0.0",
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          color: AppColors.getTextTertiary(isDark),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
