import 'package:academixstore/Core/auth/api/auth_api_services.dart';
import 'package:academixstore/Core/auth/view/signup_screen.dart';
import 'package:academixstore/Core/theme/app_colors.dart';
import 'package:academixstore/Core/theme/theme_provider.dart';
import 'package:academixstore/Core/utils/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final studentEmailController = TextEditingController();
  final individualEmailController = TextEditingController();
  final collegeIdController = TextEditingController();
  final passwordController = TextEditingController();
  AuthApiServices authApiServices = AuthApiServices();
  bool isPasswordVisible = false;
  bool isStudent = true; // Toggle between student and individual
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    studentEmailController.dispose();
    individualEmailController.dispose();
    collegeIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getPrimaryGradient(isDark),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(5.w),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with animation
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold.withValues(
                              alpha: 0.15,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [AppColors.goldGlowShadow()],
                          ),
                          child: Image.asset(
                            'assets/icon/ic_launcher.webp',
                            height: 25.w,
                            width: 25.w,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Title
                      Text(
                        "AcademixStore",
                        style: GoogleFonts.poppins(
                          color: AppColors.getTextPrimary(isDark),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Your Gateway to Knowledge",
                        style: GoogleFonts.poppins(
                          color: isDark
                              ? AppColors.paleGold
                              : AppColors.darkGold,
                          fontSize: 14.sp,
                          fontWeight: isDark
                              ? FontWeight.w300
                              : FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Login Type Toggle
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBackgroundTransparent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.borderGold),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isStudent = true;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: isStudent
                                        ? AppColors.goldGradient
                                        : null,
                                    color: isStudent
                                        ? null
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.school,
                                        color: isStudent
                                            ? AppColors.primaryBlack
                                            : AppColors.getTextSecondary(
                                                isDark,
                                              ),
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        "Student",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          color: isStudent
                                              ? AppColors.primaryBlack
                                              : AppColors.getTextSecondary(
                                                  isDark,
                                                ),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isStudent = false;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: !isStudent
                                        ? AppColors.goldGradient
                                        : null,
                                    color: !isStudent
                                        ? null
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: !isStudent
                                            ? AppColors.primaryBlack
                                            : AppColors.getTextSecondary(
                                                isDark,
                                              ),
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        "Individual",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          color: !isStudent
                                              ? AppColors.primaryBlack
                                              : AppColors.getTextSecondary(
                                                  isDark,
                                                ),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // Login Form Card
                      Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: AppColors.glassmorphicDecoration(
                          borderRadius: 20,
                          isDark: isDark,
                        ),
                        child: Column(
                          children: [
                            // Student: College ID + Email, Individual: Email only
                            if (isStudent) ...[
                              _buildTextField(
                                controller: collegeIdController,
                                label: 'College ID',
                                icon: Icons.badge,
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 2.h),
                              _buildTextField(
                                controller: studentEmailController,
                                label: 'College Email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ] else
                              _buildTextField(
                                controller: individualEmailController,
                                label: 'Email Address',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            SizedBox(height: 2.h),

                            // Password Field
                            _buildTextField(
                              controller: passwordController,
                              label: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),
                            SizedBox(height: 3.h),

                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 7.h,
                              child: Container(
                                decoration: AppColors.goldAccentDecoration(
                                  borderRadius: 16,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    authApiServices.login(
                                      email: isStudent
                                          ? studentEmailController.text
                                          : individualEmailController.text,
                                      password: passwordController.text,
                                      context: context,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: AppColors.primaryBlack,
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    "Sign In",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // Sign Up Link (Only for Individual)
                      if (!isStudent)
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                color: AppColors.getTextSecondary(isDark),
                                fontSize: 13.sp,
                              ),
                              children: [
                                const TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  text: "Sign Up",
                                  style: GoogleFonts.poppins(
                                    color: isDark
                                        ? AppColors.primaryGold
                                        : AppColors.darkGold,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: isDark
                                        ? AppColors.primaryGold
                                        : AppColors.darkGold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Student Info
                      if (isStudent)
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Text(
                            "Students: Use your college-provided credentials",
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextTertiary(isDark),
                              fontSize: 11.sp,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        color: AppColors.getTextPrimary(isDark),
        fontSize: 15.sp,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: AppColors.getTextSecondary(isDark),
          fontSize: 13.sp,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.getIconSecondary(isDark),
          size: 20.sp,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.getIconSecondary(isDark),
                  size: 20.sp,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: isDark
            ? AppColors.inputFill
            : AppColors.pureWhite.withValues(alpha: 0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.getBorderLight(isDark)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.inputBorderFocused, width: 2),
        ),
      ),
    );
  }
}
