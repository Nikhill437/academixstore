import 'dart:developer';

import 'package:academixstore/Core/home/api/home_api_services.dart';
import 'package:academixstore/Core/home/view/secured_pdf_view.dart';
import 'package:academixstore/Core/network/api_service.dart';
import 'package:academixstore/Core/theme/app_colors.dart';
import 'package:academixstore/Core/theme/theme_provider.dart';
import 'package:academixstore/Core/utils/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

class BooksDetailsScreen extends StatefulWidget {
  final String? bookTitle;
  final int? bookRating;
  final int? bookRate;
  final String? bookDescription;
  final String? bookPdfurl;
  final String? bookImg;
  final List<String>? bookCategory;
  final String? bookId;
  final String? bookAuthor;
  final int? isPurchased; // ✅ Changed to String to match '0' or '1'

  const BooksDetailsScreen({
    super.key,
    this.bookTitle,
    this.bookRating,
    this.bookRate,
    this.bookDescription,
    this.bookPdfurl,
    this.bookImg,
    this.bookCategory,
    this.bookId,
    this.bookAuthor,
    this.isPurchased,
  });

  @override
  State<BooksDetailsScreen> createState() => _BooksDetailsScreenState();
}

class _BooksDetailsScreenState extends State<BooksDetailsScreen> {
  final ApiService _apiService = ApiService();
  PdfPageImage? _firstPageImage;
  bool _loading = true;
  bool _processingPayment = false;
  String userId = '';
  late Razorpay _razorpay;
  String role = '';
  late int _currentPurchaseStatus;

  @override
  void initState() {
    super.initState();
    _currentPurchaseStatus = widget.isPurchased ?? 0;
    _enableScreenSecurity();
    _loadFirstPage(widget.bookPdfurl ?? '');
    _initializeRazorpay();
    getUserId();
  }

  @override
  void dispose() {
    _disableScreenSecurity();
    _razorpay.clear();
    super.dispose();
  }

  // ============ SECURITY METHODS ============

  void _enableScreenSecurity() {
    try {
      const platform = MethodChannel('com.academixstore.app/security');
      platform.invokeMethod('enableSecureMode');
    } catch (e) {
      log('Error enabling screen security: $e');
    }
  }

  void _disableScreenSecurity() {
    try {
      const platform = MethodChannel('com.academixstore.app/security');
      platform.invokeMethod('disableSecureMode');
    } catch (e) {
      log('Error disabling screen security: $e');
    }
  }

  // ============ EXISTING METHODS ============

  Future<void> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (mounted) {
        setState(() {
          userId = prefs.getString('user_id') ?? 'demo@academixstore.com';
          role = prefs.getString('user_role') ?? 'user';
        });
      }
    } catch (e) {
      log("Error retrieving user data: $e");
    }
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _loadFirstPage(String pdfUrl) async {
    if (pdfUrl.isEmpty) {
      setState(() => _loading = false);
      return;
    }

    final url = pdfUrl.replaceAll(RegExp(r'\s+'), '');

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = await PdfDocument.openData(response.bodyBytes);
        final page = await document.getPage(1);

        final pageImage = await page.render(
          width: 800,
          height: 1200,
          format: PdfPageImageFormat.png,
        );
        await page.close();

        setState(() {
          _firstPageImage = pageImage;
          _loading = false;
        });
      } else {
        print("Failed to load PDF: ${response.statusCode}");
        setState(() => _loading = false);
      }
    } catch (e) {
      print("Error loading PDF preview: $e");
      setState(() => _loading = false);
    }
  }

  // ✅ UPDATED: Open secure PDF viewer directly (like MyBookmarksScreen)
  Future<void> _openSecurePDFViewer() async {
    final pdfUrl = widget.bookPdfurl ?? '';

    if (pdfUrl.isEmpty) {
      _showErrorDialog('PDF URL not available');
      return;
    }

    try {
      log('Opening PDF viewer for book: ${widget.bookId}');

      // Navigate to secure PDF screen with page transition
      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                SecurePDFScreen(pdfUrl: pdfUrl, watermarkText: userId),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      }
    } catch (e) {
      log('Error opening PDF viewer: $e');
      _showErrorDialog('Error loading PDF: $e');
    }
  }

  // Create order on your backend
  Future<Map<String, dynamic>?> _createOrder() async {
    try {
      final response = await _apiService.post(
        'orders/create',
        data: {'book_id': widget.bookId},
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        final data = response.data['data'];

        return {
          'orderId': data['razorpay_order_id'],
          'amount': data['amount'],
          'currency': data['currency'],
          'key': data['razorpay_key'],
        };
      }

      return null;
    } catch (e) {
      debugPrint('Create order error: $e');
      return null;
    }
  }

  // Verify payment on your backend
  Future<bool> _verifyPayment(
    String orderId,
    String paymentId,
    String signature,
  ) async {
    try {
      final response = await _apiService.post(
        'orders/verify-payment',
        data: {
          'razorpay_order_id': orderId,
          'razorpay_payment_id': paymentId,
          'razorpay_signature': signature,
          'book_id': widget.bookId,
        },
      );

      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      log('Verify payment error: $e');
      return false;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (response.orderId == null ||
        response.paymentId == null ||
        response.signature == null) {
      _showErrorDialog('Incomplete payment data received');
      return;
    }

    setState(() => _processingPayment = true);

    final isVerified = await _verifyPayment(
      response.orderId!,
      response.paymentId!,
      response.signature!,
    );

    setState(() => _processingPayment = false);

    if (isVerified) {
      // ✅ Update purchase status immediately
      setState(() {
        _currentPurchaseStatus = 1;
      });

      // ✅ Also refresh the books list in background
      final viewModel = Provider.of<HomeApiServices>(context, listen: false);
      viewModel.getBooks();

      _showSuccessDialog();
    } else {
      _showErrorDialog('Payment verification failed');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() => _processingPayment = false);
    _showErrorDialog('Payment failed: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() => _processingPayment = false);
    _showInfoDialog('External wallet: ${response.walletName}');
  }

  void _openCheckout() async {
    setState(() => _processingPayment = true);

    final orderData = await _createOrder();

    if (orderData == null) {
      setState(() => _processingPayment = false);
      _showErrorDialog('Failed to create order');
      return;
    }

    setState(() => _processingPayment = false);

    var options = {
      'key': orderData['key'],
      'order_id': orderData['orderId'],
      'amount': orderData['amount'],
      'currency': orderData['currency'],
      'name': widget.bookTitle,
      'description': 'Book Purchase',
      'prefill': {'email': userId},
      'theme': {'color': '#C9A24D'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      _showErrorDialog('Unable to open payment gateway');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.primaryGold, width: 2),
        ),
        title: Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
          size: 60.sp,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Payment Successful!',
              style: GoogleFonts.poppins(
                color: AppColors.primaryGold,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Your book has been purchased successfully.',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.primaryGold, width: 2),
        ),
        title: Icon(
          Icons.error_outline_rounded,
          color: Colors.red,
          size: 60.sp,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Error',
              style: GoogleFonts.poppins(
                color: AppColors.primaryGold,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              message,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.primaryGold, width: 2),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13.sp),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                            'Book Details',
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

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Book Cover and Info
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Book Cover
                              Hero(
                                tag: 'book_${widget.bookId ?? 'no_id'}',
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.borderGold,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      AppColors.goldGlowShadow(blurRadius: 15),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child:
                                        widget.bookImg != null &&
                                            widget.bookImg!.isNotEmpty
                                        ? Image.network(
                                            widget.bookImg!,
                                            width: 35.w,
                                            height: 50.w,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                                  width: 35.w,
                                                  height: 50.w,
                                                  color:
                                                      AppColors.cardBackground,
                                                  child: Icon(
                                                    Icons.menu_book_rounded,
                                                    size: 30.sp,
                                                    color:
                                                        AppColors.primaryGold,
                                                  ),
                                                ),
                                          )
                                        : Container(
                                            width: 35.w,
                                            height: 50.w,
                                            color: AppColors.cardBackground,
                                            child: Icon(
                                              Icons.menu_book_rounded,
                                              size: 30.sp,
                                              color: AppColors.primaryGold,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),

                              // Book Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.bookTitle ?? 'Unknown Title',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.getTextPrimary(isDark),
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person_outline_rounded,
                                          color: AppColors.primaryGold,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 1.w),
                                        Expanded(
                                          child: Text(
                                            widget.bookAuthor ??
                                                'Unknown Author',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.getTextSecondary(
                                                isDark,
                                              ),
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.5.h),

                                    // Rating
                                    Row(
                                      children: [
                                        ...List.generate(5, (index) {
                                          return Icon(
                                            index < (widget.bookRating ?? 0)
                                                ? Icons.star_rounded
                                                : Icons.star_outline_rounded,
                                            size: 18.sp,
                                            color: AppColors.primaryGold,
                                          );
                                        }),
                                        SizedBox(width: 2.w),
                                        Text(
                                          (widget.bookRating ?? 0).toString(),
                                          style: GoogleFonts.poppins(
                                            color: AppColors.getTextSecondary(
                                              isDark,
                                            ),
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.5.h),

                                    // Price
                                    if (widget.bookRate != null)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 3.w,
                                          vertical: 1.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryGold
                                              .withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: AppColors.primaryGold,
                                          ),
                                        ),
                                        child: Text(
                                          '₹${widget.bookRate}',
                                          style: GoogleFonts.poppins(
                                            color: AppColors.primaryGold,
                                            fontSize: 18.sp,
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

                          // Categories
                          if (widget.bookCategory != null &&
                              widget.bookCategory!.isNotEmpty) ...[
                            Text(
                              'Categories',
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryGold,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Wrap(
                              spacing: 2.w,
                              runSpacing: 1.h,
                              children: widget.bookCategory!.map((category) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 0.8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGold.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.primaryGold.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    category,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.lightGold,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 3.h),
                          ],

                          // Description
                          if (widget.bookDescription != null &&
                              widget.bookDescription!.isNotEmpty) ...[
                            Text(
                              'Description',
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryGold,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: AppColors.glassmorphicDecoration(
                                borderRadius: 16,
                                isDark: isDark,
                              ),
                              child: Text(
                                widget.bookDescription!,
                                style: GoogleFonts.poppins(
                                  color: AppColors.getTextSecondary(isDark),
                                  fontSize: 13.sp,
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(height: 3.h),
                          ],

                          // Preview Section
                          Text(
                            'Preview',
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryGold,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),

                          AbsorbPointer(
                            absorbing: true,
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: AppColors.glassmorphicDecoration(
                                borderRadius: 16,
                                isDark: isDark,
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: _loading
                                        ? Column(
                                            children: [
                                              CircularProgressIndicator(
                                                color: AppColors.primaryGold,
                                              ),
                                              SizedBox(height: 2.h),
                                              Text(
                                                'Loading PDF preview...',
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      AppColors.getTextSecondary(
                                                        isDark,
                                                      ),
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          )
                                        : _firstPageImage != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.memory(
                                              color: Colors.white,
                                              _firstPageImage!.bytes,
                                              width: double.infinity,
                                              fit: BoxFit.contain,
                                              cacheWidth: null,
                                              cacheHeight: null,
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              Icon(
                                                Icons.picture_as_pdf_rounded,
                                                color: AppColors.primaryGold,
                                                size: 30.sp,
                                              ),
                                              SizedBox(height: 1.h),
                                              Text(
                                                'Preview not available',
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      AppColors.getTextSecondary(
                                                        isDark,
                                                      ),
                                                  fontSize: 12.sp,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                  ),

                                  if (_firstPageImage != null)
                                    Positioned.fill(
                                      child: Center(
                                        child: Opacity(
                                          opacity: 0.3,
                                          child: Transform.rotate(
                                            angle: -0.5,
                                            child: Text(
                                              'PREVIEW ONLY',
                                              style: GoogleFonts.poppins(
                                                fontSize: 24.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryGold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          // Security notice
                          SizedBox(height: 2.h),
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGold.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primaryGold.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.security_rounded,
                                  color: AppColors.primaryGold,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    'Content is protected. Screenshots and screen recording are disabled.',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.getTextSecondary(isDark),
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ✅ Add extra space for floating buttons
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_processingPayment)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryGold),
                    SizedBox(height: 2.h),
                    Text(
                      'Processing payment...',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),

      // ✅ FIXED: Button logic based on role and purchase status
      floatingActionButton: _buildActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ✅ NEW: Method to decide which button to show
  Widget _buildActionButton() {
    // Student role always gets Read Now button
    if (role == 'student') {
      return _buildReadNowButton();
    }

    // User role: show Read Now if purchased, otherwise Buy Now
    if (role == 'user') {
      // ✅ Use the local state instead of widget property
      if (_currentPurchaseStatus == 1) {
        return _buildReadNowButton();
      } else {
        return _buildBuyNowButton();
      }
    }

    // For any other role, show nothing
    return const SizedBox.shrink();
  }

  // ✅ Read Now button for purchased books
  Widget _buildReadNowButton() {
    return Container(
      width: 90.w,
      height: 7.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGold, AppColors.lightGold],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.goldGlowShadow(blurRadius: 20)],
      ),
      child: ElevatedButton(
        onPressed: _processingPayment ? null : _openSecurePDFViewer,
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
            Icon(Icons.menu_book_rounded, size: 20.sp),
            SizedBox(width: 2.w),
            Text(
              "Read Now",
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Buy Now button
  Widget _buildBuyNowButton() {
    return Container(
      width: 90.w,
      height: 7.h,
      decoration: AppColors.goldAccentDecoration(borderRadius: 16),
      child: ElevatedButton(
        onPressed: _processingPayment ? null : _openCheckout,
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
            Icon(Icons.shopping_cart_rounded, size: 20.sp),
            SizedBox(width: 2.w),
            Text(
              "Buy Now",
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
