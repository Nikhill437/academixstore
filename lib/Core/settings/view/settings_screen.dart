// COMMENTED FOR STATIC APP
import 'dart:developer';
import 'package:academixstore/Core/auth/view/signin_screen.dart';
import 'package:academixstore/Core/theme/app_colors.dart';
import 'package:academixstore/Core/theme/theme_provider.dart';
import 'package:academixstore/Core/utils/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? email;

  // STATIC APP - Get mock email
  Future<void> getEmailId() async {
    // Simulate network delay
    try {
      final prefs = await SharedPreferences.getInstance();

      if (mounted) {
        setState(() {
          email = prefs.getString('user_email') ?? 'demo@academixstore.com';
        });
      }
    } catch (e) {
      log("Error retrieving user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getEmailId();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      decoration: BoxDecoration(gradient: AppColors.getPrimaryGradient(isDark)),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      shape: BoxShape.circle,
                      boxShadow: [AppColors.goldGlowShadow()],
                    ),
                    child: Icon(
                      Icons.settings_rounded,
                      color: AppColors.primaryBlack,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Settings",
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.getTextPrimary(isDark),
                          ),
                        ),
                        Text(
                          "Manage Your Account",
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: isDark
                                ? AppColors.paleGold
                                : AppColors.darkGold,
                            fontWeight: isDark
                                ? FontWeight.w300
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Settings List
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                children: [
                  // Profile Section
                  _buildSectionHeader("Profile", Icons.person_rounded),
                  SizedBox(height: 1.h),
                  _buildProfileCard(),
                  SizedBox(height: 1.h),
                  // _buildSettingItem(
                  //   icon: Icons.lock_outline_rounded,
                  //   title: "Change Password",
                  //   subtitle: "Update your password",
                  //   onTap: () {},
                  // ),
                  // SizedBox(height: 3.h),

                  // Appearance Section
                  _buildSectionHeader("Appearance", Icons.palette_rounded),
                  SizedBox(height: 1.h),
                  _buildThemeToggle(),
                  SizedBox(height: 3.h),

                  // Support Section
                  _buildSectionHeader("Support", Icons.support_agent_rounded),
                  SizedBox(height: 1.h),
                  _buildSettingItem(
                    icon: Icons.bug_report_outlined,
                    title: "Report a Bug",
                    subtitle: "Help us improve",
                    onTap: () async {
                      const url = 'https://academixstore.com/contact-us/';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 1.h),
                  _buildSettingItem(
                    icon: Icons.help_outline_rounded,
                    title: "Help & FAQ",
                    subtitle: "Get answers to your questions",
                    onTap: () {},
                  ),
                  SizedBox(height: 3.h),

                  // Legal Section
                  _buildSectionHeader("Legal", Icons.gavel_rounded),
                  SizedBox(height: 1.h),
                  _buildSettingItem(
                    icon: Icons.policy_outlined,
                    title: "Privacy Policy",
                    subtitle: "How we protect your data",
                    onTap: () async {
                      const url = 'https://academixstore.com/privacy-policy/';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 1.h),
                  _buildSettingItem(
                    icon: Icons.description_outlined,
                    title: "Terms & Conditions",
                    subtitle: "Our terms of service",
                    onTap: () async {
                      const url =
                          'https://academixstore.com/terms-and-conditions/';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 3.h),

                  // Danger Zone
                  _buildSectionHeader("Danger Zone", Icons.warning_rounded),
                  SizedBox(height: 1.h),
                  _buildDangerItem(
                    icon: Icons.logout_rounded,
                    title: "Logout",
                    subtitle: "Sign out of your account",
                    color: AppColors.warning,
                    onTap: () => _showLogoutDialog(),
                  ),
                  SizedBox(height: 1.h),
                  _buildDangerItem(
                    icon: Icons.delete_forever_rounded,
                    title: "Delete Account",
                    subtitle: "Permanently delete your account",
                    color: AppColors.error,
                    onTap: () async {
                      const url =
                          'https://academixstore.com/account-deletion-request-academixstore/';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 4.h),

                  // App Version
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.primaryGold,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'AcademixStore',
                          style: GoogleFonts.poppins(
                            color: AppColors.getTextPrimary(isDark),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Version 1.0.0',
                          style: GoogleFonts.poppins(
                            color: AppColors.getTextTertiary(isDark),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        return Container(
          decoration: AppColors.glassmorphicDecoration(
            borderRadius: 16,
            isDark: isDark,
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.5.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    color: AppColors.primaryGold,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        themeProvider.isDarkMode ? "Dark Mode" : "Light Mode",
                        style: GoogleFonts.poppins(
                          color: AppColors.getTextPrimary(isDark),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.3.h),
                      Text(
                        "Switch between dark and light theme",
                        style: GoogleFonts.poppins(
                          color: AppColors.getTextSecondary(isDark),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeThumbColor: AppColors.primaryGold,
                  activeTrackColor: AppColors.primaryGold.withValues(
                    alpha: 0.5,
                  ),
                  inactiveThumbColor: AppColors.getTextTertiary(isDark),
                  inactiveTrackColor: AppColors.getBorder(isDark),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGold, size: 18.sp),
        SizedBox(width: 2.w),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15.sp,
            color: AppColors.primaryGold,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    return Container(
      decoration: AppColors.glassmorphicDecoration(
        borderRadius: 16,
        isDark: isDark,
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                shape: BoxShape.circle,
                boxShadow: [AppColors.goldGlowShadow(blurRadius: 10)],
              ),
              child: Icon(
                Icons.person_rounded,
                color: AppColors.primaryBlack,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    email ?? 'Loading...',
                    style: GoogleFonts.poppins(
                      color: AppColors.getTextPrimary(isDark),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Your Account Email',
                    style: GoogleFonts.poppins(
                      color: AppColors.getTextSecondary(isDark),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.verified_rounded,
              color: AppColors.primaryGold,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: AppColors.glassmorphicDecoration(
          borderRadius: 16,
          isDark: isDark,
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.5.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryGold, size: 20.sp),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: AppColors.getTextPrimary(isDark),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.3.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: AppColors.getTextSecondary(isDark),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.getTextTertiary(isDark),
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDangerItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.5.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: color,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.3.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: AppColors.getTextSecondary(isDark),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16.sp),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.borderGold),
        ),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.warning, size: 24.sp),
            SizedBox(width: 2.w),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: AppColors.getTextPrimary(true), // Dialog is always dark
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(
            color: AppColors.getTextSecondary(true), // Dialog is always dark
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: AppColors.getTextSecondary(
                  true,
                ), // Dialog is always dark
                fontSize: 14.sp,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Logged out successfully',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
              },
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryBlack,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
