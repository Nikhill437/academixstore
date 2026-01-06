import 'package:academixstore/Appwrite/main_view_model.dart';
import 'package:academixstore/Core/theme/app_colors.dart';
import 'package:academixstore/Core/theme/theme_provider.dart';
import 'package:academixstore/Core/utils/responsive_extensions.dart';
// COMMENTED FOR STATIC APP
// import 'package:academixstore/enum.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartScreen extends StatefulWidget {
  final String? bookTitle;
  final int? bookPrice;
  final int? bookRating;
  final String? bookImg;
  final List<String>? bookCategory;
  final String? bookId;
  final String? bookAuthor;
  const CartScreen({
    super.key,
    this.bookImg,
    this.bookTitle,
    this.bookRating,
    this.bookPrice,
    this.bookId,
    this.bookAuthor,
    this.bookCategory,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // STATIC APP - Simulate payment success
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // STATIC APP - Simulate purchase
    final provider = Provider.of<MainViewModel>(context, listen: false);
    await provider.purchaseBook(widget.bookId!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment successful & book purchased!")),
      );

      Navigator.pop(context);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("External Wallet selected: ${response.walletName}"),
      ),
    );
  }

  // STATIC APP - Simulate payment (Razorpay disabled)
  void _startPayment() async {
    // STATIC APP - Show message that payment is simulated
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Payment gateway disabled in static mode. Simulating purchase...',
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Simulate purchase after delay
      await Future.delayed(const Duration(seconds: 2));

      final provider = Provider.of<MainViewModel>(context, listen: false);
      await provider.purchaseBook(widget.bookId!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Book purchased successfully!")),
        );
        Navigator.pop(context);
      }
    }

    // COMMENTED FOR STATIC APP
    // final provider = Provider.of<MainViewModel>(context, listen: false);

    // // Ensure keys are fetched
    // if (provider.razorpayApiKey == null) {
    //   await provider.getCredentials();
    // }

    // var options = {
    //   'key': provider.razorpayApiKey,
    //   'amount': (widget.bookPrice + 10) * 100, // in paise
    //   'name': 'Book Purchase',
    //   'description': widget.bookTitle,
    //   'prefill': {
    //     'contact': '9876543210', // Replace with actual user contact
    //     'email': 'user@example.com', // Replace with actual user email
    //   },
    //   'currency': 'INR',
    // };

    // try {
    //   _razorpay.open(options);
    // } catch (e) {
    //   debugPrint('Error: $e');
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
              // Custom App Bar
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: AppColors.glassmorphicDecoration(
                          borderRadius: 12,
                          isDark: isDark,
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.primaryGold,
                          size: 22.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Check Out',
                        style: GoogleFonts.poppins(
                          color: AppColors.getTextPrimary(isDark),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Container(
                    decoration: AppColors.glassmorphicDecoration(
                      borderRadius: 16,
                      isDark: isDark,
                    ),
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Summary",
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryGold,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(color: AppColors.getDivider(isDark)),
                        SizedBox(height: 2.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.borderGold,
                                  width: 1,
                                ),
                                boxShadow: [
                                  AppColors.goldGlowShadow(blurRadius: 10),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child:
                                    widget.bookImg != null &&
                                        widget.bookImg!.isNotEmpty
                                    ? Image.network(
                                        widget.bookImg!,
                                        width: 25.w,
                                        height: 35.w,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _bookPlaceholder(),
                                      )
                                    : _bookPlaceholder(),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.bookTitle!,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.getTextPrimary(isDark),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    widget.bookAuthor!,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.getTextSecondary(isDark),
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Row(
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        index < widget.bookRating!
                                            ? Icons.star_rounded
                                            : Icons.star_outline_rounded,
                                        size: 16.sp,
                                        color: AppColors.primaryGold,
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 1.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3.w,
                                      vertical: 0.8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.goldGradient,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        AppColors.goldGlowShadow(blurRadius: 8),
                                      ],
                                    ),
                                    child: Text(
                                      "₹${widget.bookPrice}",
                                      style: GoogleFonts.poppins(
                                        color: AppColors.primaryBlack,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "Order Summary",
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryGold,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(color: AppColors.getDivider(isDark)),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Book Price",
                              style: GoogleFonts.poppins(
                                color: AppColors.getTextSecondary(isDark),
                                fontSize: 13.sp,
                              ),
                            ),
                            Text(
                              "₹${widget.bookPrice}",
                              style: GoogleFonts.poppins(
                                color: AppColors.getTextPrimary(isDark),
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Service Charge",
                              style: GoogleFonts.poppins(
                                color: AppColors.getTextSecondary(isDark),
                                fontSize: 13.sp,
                              ),
                            ),
                            Text(
                              "₹10.0",
                              style: GoogleFonts.poppins(
                                color: AppColors.getTextPrimary(isDark),
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: AppColors.getDivider(isDark)),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: GoogleFonts.poppins(
                                color: AppColors.getTextPrimary(isDark),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${(widget.bookPrice! + 10).toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryGold,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),

                        // Purchase Button
                        SizedBox(
                          width: double.infinity,
                          height: 7.h,
                          child: Container(
                            decoration: AppColors.goldAccentDecoration(
                              borderRadius: 16,
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                _startPayment();
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_checkout_rounded,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    "Complete Purchase",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.poppins(
                                color: AppColors.error,
                                fontSize: 14.sp,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.error,
                              ),
                            ),
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
      ),
    );
  }

  Widget _bookPlaceholder() {
    return Container(
      width: 25.w,
      height: 35.w,
      color: AppColors.cardBackground,
      child: Icon(
        Icons.menu_book_rounded,
        size: 25.sp,
        color: AppColors.primaryGold,
      ),
    );
  }
}
