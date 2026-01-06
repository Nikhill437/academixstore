import 'package:academixstore/Core/bookmarks/api/purchase_book_api_service.dart';
import 'package:academixstore/Core/home/view/secured_pdf_view.dart';
import 'package:academixstore/Core/theme/app_colors.dart';
import 'package:academixstore/Core/theme/theme_provider.dart';
import 'package:academixstore/Core/utils/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyBookmarksScreen extends StatefulWidget {
  const MyBookmarksScreen({super.key});

  @override
  State<MyBookmarksScreen> createState() => _MyBookmarksScreenState();
}

class _MyBookmarksScreenState extends State<MyBookmarksScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch books using the PurchaseBookApiService
      context.read<PurchaseBookApiService>().fetchPurchasedBooks();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final purchaseService = context.watch<PurchaseBookApiService>();
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    // Extract books from purchases
    final books =
        purchaseService.purchasedBookData?.data?.purchases
            ?.map((purchase) => purchase.book)
            .where((book) => book != null)
            .toList() ??
        [];

    // Determine loading state
    final isLoading = purchaseService.isLoading;
    final hasError = purchaseService.errorMessage != null;

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
                      Icons.library_books_rounded,
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
                          "My Books",
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.getTextPrimary(isDark),
                          ),
                        ),
                        Text(
                          "Your Purchased Collection",
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
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryGold.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      "${books.length}",
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryGold,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Books List
            Expanded(
              child: Builder(
                builder: (context) {
                  if (isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryGold,
                            strokeWidth: 0.8.w,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Loading your books...",
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextSecondary(isDark),
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.error,
                            size: 30.sp,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Failed to load books",
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextPrimary(isDark),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            purchaseService.errorMessage ??
                                "Please try again later",
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextSecondary(isDark),
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2.h),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<PurchaseBookApiService>()
                                  .fetchPurchasedBooks();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGold,
                              foregroundColor: AppColors.primaryBlack,
                            ),
                            child: Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  } else if (books.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGold.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryGold.withValues(
                                  alpha: 0.3,
                                ),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.library_books_outlined,
                              color: AppColors.primaryGold,
                              size: 40.sp,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            "No Books Yet",
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextPrimary(isDark),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "Start exploring and purchase\nyour first book!",
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextSecondary(isDark),
                              fontSize: 13.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      color: AppColors.primaryGold,
                      onRefresh: () async {
                        await context
                            .read<PurchaseBookApiService>()
                            .fetchPurchasedBooks();
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return _PurchasedBookCard(book: book, index: index);
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchasedBookCard extends StatefulWidget {
  final dynamic book;
  final int index;

  const _PurchasedBookCard({required this.book, required this.index});

  @override
  State<_PurchasedBookCard> createState() => _PurchasedBookCardState();
}

class _PurchasedBookCardState extends State<_PurchasedBookCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Replace the _PurchasedBookCard's build method with this fixed version

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    // Use null-safe property access
    final title = widget.book?.title ?? 'Unknown Title';
    final author = widget.book?.author ?? 'Unknown Author';
    final rating = widget.book?.rating ?? 0;
    final coverImageUrl = widget.book?.coverImageUrl;
    final pdfUrl = widget.book?.pdfFileUrl ?? '';

    // Debug prints
    print('Book Title: $title');
    print('Cover URL: $coverImageUrl');
    print('Is URL null: ${coverImageUrl == null}');
    print('Is URL empty: ${coverImageUrl?.isEmpty ?? true}');

    // Check if cover image URL is valid
    final bool hasValidCoverImage =
        coverImageUrl != null &&
        coverImageUrl.isNotEmpty &&
        coverImageUrl.toString().startsWith('http');

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: InkWell(
            onTap: () {
              if (pdfUrl.isNotEmpty) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SecurePDFScreen(pdfUrl: pdfUrl, watermarkText: ''),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: AppColors.glassmorphicDecoration(
                borderRadius: 16,
                isDark: isDark,
              ),
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book Cover with "Owned" Badge
                    Stack(
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
                            child: hasValidCoverImage
                                ? Image.network(
                                    coverImageUrl!,
                                    width: 25.w,
                                    height: 35.w,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 25.w,
                                        height: 35.w,
                                        color: AppColors.cardBackground,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.primaryGold,
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      print('Error loading image: $error');
                                      return _buildPlaceholder();
                                    },
                                  )
                                : _buildPlaceholder(),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              boxShadow: [
                                AppColors.goldGlowShadow(blurRadius: 8),
                              ],
                            ),
                            child: Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primaryBlack,
                              size: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 4.w),

                    // Book Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextPrimary(isDark),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline_rounded,
                                color: AppColors.getTextTertiary(isDark),
                                size: 14.sp,
                              ),
                              SizedBox(width: 1.w),
                              Expanded(
                                child: Text(
                                  author,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.getTextSecondary(isDark),
                                    fontSize: 12.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),

                          // Rating
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < rating
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 16.sp,
                                color: AppColors.primaryGold,
                              );
                            }),
                          ),
                          SizedBox(height: 1.h),

                          // Read Now Button
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGold.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primaryGold.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.menu_book_rounded,
                                  color: AppColors.primaryGold,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  "Read Now",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primaryGold,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.primaryGold,
                                  size: 12.sp,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
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
