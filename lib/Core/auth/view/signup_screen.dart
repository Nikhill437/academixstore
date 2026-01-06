// COMMENTED FOR STATIC APP
// import 'package:academixstore/Appwrite/appwrite_services.dart'
//     show AppwriteService;
import 'package:academixstore/Core/auth/api/auth_api_services.dart';
import 'package:academixstore/Core/auth/view/signin_screen.dart';
import 'package:academixstore/Core/theme/app_colors.dart';
import 'package:academixstore/Core/theme/theme_provider.dart';
import 'package:academixstore/Core/utils/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final AuthApiServices _authController = AuthApiServices();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  bool isChecked = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String? passwordErrorText;
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
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  // STATIC APP - Simulate signup without API
  Future<void> signUp() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      setState(() {
        passwordErrorText = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      passwordErrorText = null;
    });

    // Simulate network delay
    await _authController.register(
      email: emailController.text.trim(),
      fullName: nameController.text.trim(),
      mobile: mobileController.text.trim(),
      password: password,
    );

    // STATIC APP - Always succeed
    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Signup Successful! Please login."),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }

    // COMMENTED FOR STATIC APP
    // try {
    //   await AppwriteService.instance.onRegister(
    //     email: emailController.text,
    //     password: passwordController.text,
    //     name: nameController.text,
    //   );
    //   showDialog(
    //     context: context,
    //     builder: (_) => AlertDialog(
    //       content: const Text("Signup Successful! Please login."),
    //     ),
    //   );
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (_) => const LoginScreen()),
    //   );
    // } catch (e) {
    //   showDialog(
    //     context: context,
    //     builder: (_) => AlertDialog(content: Text("Signup Failed: $e")),
    //   );
    // }
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
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryGold,
                        size: 22.sp,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Create Account",
                      style: GoogleFonts.poppins(
                        color: AppColors.getTextPrimary(isDark),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(5.w),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          // Logo
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
                                height: 20.w,
                                width: 20.w,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),

                          Text(
                            "Join AcademixStore",
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextPrimary(isDark),
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "For Individual Learners",
                            style: GoogleFonts.poppins(
                              color: isDark
                                  ? AppColors.paleGold
                                  : AppColors.darkGold,
                              fontSize: 13.sp,
                              fontWeight: isDark
                                  ? FontWeight.normal
                                  : FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 3.h),

                          // Form Card
                          Container(
                            padding: EdgeInsets.all(5.w),
                            decoration: AppColors.glassmorphicDecoration(
                              borderRadius: 20,
                              isDark: isDark,
                            ),
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: nameController,
                                  label: 'Full Name',
                                  icon: Icons.person_outline,
                                ),
                                SizedBox(height: 2.h),
                                _buildTextField(
                                  controller: emailController,
                                  label: 'Email Address',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: 2.h),
                                _buildTextField(
                                  controller: mobileController,
                                  label: 'Mobile Number',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                ),
                                SizedBox(height: 2.h),
                                _buildTextField(
                                  controller: passwordController,
                                  label: 'Password',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  isPasswordVisible: isPasswordVisible,
                                  onTogglePassword: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                                SizedBox(height: 1.h),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "• At least 8 characters\n• Mix of letters and numbers recommended",
                                    style: GoogleFonts.poppins(
                                      color: AppColors.getTextTertiary(isDark),
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                _buildTextField(
                                  controller: confirmPasswordController,
                                  label: 'Confirm Password',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  isPasswordVisible: isConfirmPasswordVisible,
                                  onTogglePassword: () {
                                    setState(() {
                                      isConfirmPasswordVisible =
                                          !isConfirmPasswordVisible;
                                    });
                                  },
                                  errorText: passwordErrorText,
                                ),
                                SizedBox(height: 2.h),

                                // Terms Checkbox
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 5.w,
                                      width: 5.w,
                                      child: Checkbox(
                                        value: isChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            isChecked = value ?? false;
                                          });
                                        },
                                        side: BorderSide(
                                          color: AppColors.borderGold,
                                          width: 2,
                                        ),
                                        checkColor: AppColors.primaryBlack,
                                        fillColor: WidgetStateProperty.all(
                                          isChecked
                                              ? AppColors.primaryGold
                                              : Colors.transparent,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        "I agree to the Terms & Conditions and Privacy Policy",
                                        style: GoogleFonts.poppins(
                                          color: AppColors.getTextSecondary(
                                            isDark,
                                          ),
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.h),

                                // Sign Up Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 7.h,
                                  child: Container(
                                    decoration: isChecked
                                        ? AppColors.goldAccentDecoration(
                                            borderRadius: 16,
                                          )
                                        : BoxDecoration(
                                            color: AppColors.buttonDisabled,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                    child: ElevatedButton(
                                      onPressed: isChecked ? signUp : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: isChecked
                                            ? AppColors.primaryBlack
                                            : AppColors.mediumGrey,
                                        disabledBackgroundColor:
                                            Colors.transparent,
                                        disabledForegroundColor:
                                            AppColors.mediumGrey,
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Create Account",
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

                          // Login Link
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  color: AppColors.getTextSecondary(isDark),
                                  fontSize: 13.sp,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Already have an account? ",
                                  ),
                                  TextSpan(
                                    text: "Sign In",
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
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
                onPressed: onTogglePassword,
              )
            : null,
        errorText: errorText,
        errorStyle: GoogleFonts.poppins(
          color: AppColors.error,
          fontSize: 11.sp,
        ),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }
}
