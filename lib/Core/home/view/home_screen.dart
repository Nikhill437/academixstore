import 'dart:developer';

import 'package:academixstore/Core/bookmarks/view/bookmarks_screen.dart';
import 'package:academixstore/Core/home/api/home_api_services.dart';
import 'package:academixstore/Core/home/view/books_details_screen.dart';
import 'package:academixstore/Core/settings/view/settings_screen.dart';
import 'package:academixstore/Core/theme/app_colors.dart';
import 'package:academixstore/Core/theme/theme_provider.dart';
import 'package:academixstore/Core/utils/responsive_extensions.dart';
import 'package:academixstore/enum.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  String? role;
  @override
  void initState() {
    super.initState();
    getAuthToken();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      log("Retrieved auth token: ${prefs.getString('auth_token')}");
      setState(() {
        role = prefs.getString('user_role') ?? 'user';
      });
      return prefs.getString('auth_token');
    } catch (e) {
      log("Error getting auth token: $e");
      return null;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // List of pages - created as getter to access role
  List<Widget> get _pages => [
    HomeTab(userRole: role),
    const MyBookmarksScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Check if user is a student
    final isStudent = role?.toLowerCase() == 'student';
    
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final isDark = themeProvider.isDarkMode;
          return Container(
            decoration: BoxDecoration(
              gradient: AppColors.getPrimaryGradient(isDark),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getShadowDark(isDark),
                  blurRadius: isDark ? 20 : 12,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: _currentIndex,
              selectedItemColor: isDark
                  ? AppColors.primaryGold
                  : AppColors.darkGold,
              unselectedItemColor: AppColors.getTextTertiary(isDark),
              selectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 10.sp,
              ),
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                // Disable "My Books" tab for students
                if (index == 1 && isStudent) {
                  // Show a message that this feature is not available for students
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'My Books is not available for student accounts',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: AppColors.warning,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                
                setState(() {
                  _currentIndex = index;
                });
                _animationController.reset();
                _animationController.forward();
              },
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.library_books_rounded,
                    color: isStudent 
                        ? AppColors.mediumGrey.withValues(alpha: 0.3)
                        : null,
                  ),
                  label: "My Books",
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.settings_rounded),
                  label: "Settings",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  final String? userRole;

  const HomeTab({super.key, this.userRole});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';
  String searchQuery = '';

  final List<String> categories = [
    'All',
    'Computer Science',
    'Algorithms',
    'Programming',
    'Software Engineering',
    'Design',
    'Best Practices',
    'Career Development',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<dynamic> getFilteredBooks(List<dynamic> books) {
    var filtered = books;

    // Filter by category
    if (selectedCategory != 'All') {
      filtered = filtered.where((book) {
        // category is a String in BookModel, not a List
        return book.category != null &&
            book.category.toLowerCase().contains(
              selectedCategory.toLowerCase(),
            );
      }).toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((book) {
        final title = book.name?.toLowerCase() ?? '';
        final author = book.authorname?.toLowerCase() ?? '';
        final query = searchQuery.toLowerCase();
        return title.contains(query) || author.contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeApiServices>(context, listen: true);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final books = viewModel.allBooks;
    final status = viewModel.booksStatus;

    // Fetch books on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (status == OperationStatus.ideal) {
        viewModel.getBooks();
      }
    });

    final filteredBooks = getFilteredBooks(books);

    // Check if user role is 'user'
    final isUserRole = widget.userRole?.toLowerCase() == 'user';

    return Container(
      decoration: BoxDecoration(gradient: AppColors.getPrimaryGradient(isDark)),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          shape: BoxShape.circle,
                          boxShadow: [AppColors.goldGlowShadow()],
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
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
                              "AcademixStore",
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.getTextPrimary(isDark),
                              ),
                            ),
                            Text(
                              "Explore Academic Books",
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

                  // Show search bar only for user role
                  if (isUserRole) ...[
                    SizedBox(height: 3.h),
                    // Search Bar
                    Container(
                      decoration: AppColors.glassmorphicDecoration(
                        borderRadius: 15,
                        isDark: isDark,
                      ),
                      child: TextField(
                        controller: searchController,
                        style: GoogleFonts.poppins(
                          color: AppColors.getTextPrimary(isDark),
                          fontSize: 14.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search books, authors...',
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.getTextTertiary(isDark),
                            fontSize: 13.sp,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: AppColors.primaryGold,
                            size: 22.sp,
                          ),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear_rounded,
                                    color: AppColors.mediumGrey,
                                    size: 20.sp,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      searchController.clear();
                                      searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ] else
                    SizedBox(height: 3.h),
                ],
              ),
            ),

            // Category Chips (Horizontal Scroll)
            SizedBox(
              height: 6.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;

                  return Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? AppColors.goldGradient
                                : null,
                            color: isSelected
                                ? null
                                : AppColors.getCardBackgroundTransparent(
                                    isDark,
                                  ),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : AppColors.getBorderLight(isDark),
                              width: isSelected ? 0 : (isDark ? 1 : 1.5),
                            ),
                            boxShadow: isSelected
                                ? [AppColors.goldGlowShadow(blurRadius: 10)]
                                : (isDark
                                      ? null
                                      : [
                                          BoxShadow(
                                            color: AppColors.getShadowLight(
                                              isDark,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]),
                          ),
                          child: Center(
                            child: Text(
                              category,
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.primaryBlack
                                    : AppColors.getTextSecondary(isDark),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 2.h),

            // Books List
            Expanded(
              child: Builder(
                builder: (context) {
                  if (status == OperationStatus.loading) {
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
                            "Loading books...",
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextSecondary(isDark),
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (status == OperationStatus.failure) {
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
                            "Please try again later",
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextSecondary(isDark),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (filteredBooks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.library_books_outlined,
                            color: AppColors.mediumGrey,
                            size: 30.sp,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            searchQuery.isNotEmpty
                                ? "No books found"
                                : "No books in this category",
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextPrimary(isDark),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            searchQuery.isNotEmpty
                                ? "Try a different search"
                                : "Try selecting another category",
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextSecondary(isDark),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        return _BookCard(book: book, index: index);
                      },
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

class _BookCard extends StatefulWidget {
  final dynamic book;
  final int index;

  const _BookCard({required this.book, required this.index});

  @override
  State<_BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<_BookCard>
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
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Stagger animation based on index
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      BooksDetailsScreen(
                        bookTitle: widget.book.name,
                        bookRating: widget.book.rating ?? 0,
                        bookRate: widget.book.rate ?? 0,
                        bookDescription: widget.book.description,
                        bookPdfurl: widget.book.pdfUrl,
                        bookImg: widget.book.coverImageUrl,
                        bookCategory: widget.book.category != null
                            ? [widget.book.category]
                            : [],
                        bookId: widget.book.id,
                        bookAuthor: widget.book.authorname,
                        isPurchased: widget.book.purchased,
                        questionPaperUrl: widget.book.questionPaperUrl,
                      ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
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
                    // Book Cover
                    Hero(
                      tag: 'book_${widget.book.id ?? 'no_id'}',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.borderGold,
                            width: 1,
                          ),
                          boxShadow: [AppColors.goldGlowShadow(blurRadius: 10)],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              widget.book.coverImageUrl != null &&
                                  widget.book.coverImageUrl!.isNotEmpty
                              ? Image.network(
                                  widget.book.coverImageUrl!,
                                  width: 25.w,
                                  height: 35.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _bookPlaceholder(),
                                )
                              : _bookPlaceholder(),
                        ),
                      ),
                    ),

                    SizedBox(width: 4.w),

                    // Book Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.book.name ?? 'Unknown Title',
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
                                  widget.book.authorname ?? 'Unknown Author',
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
                                index < (widget.book.rating ?? 0)
                                    // (double.tryParse(
                                    //       widget.book.rating ?? '0',
                                    //     ) ??
                                    //     0)
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 16.sp,
                                color: AppColors.primaryGold,
                              );
                            }),
                          ),
                          SizedBox(height: 1.h),

                          // Category (single String, not List)
                          if (widget.book.category != null &&
                              widget.book.category!.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.3.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGold.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primaryGold.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                widget.book.category!,
                                style: GoogleFonts.poppins(
                                  color: AppColors.lightGold,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          SizedBox(height: 1.h),

                          // Additional Info (Pages/Year)
                          Row(
                            children: [
                              if (widget.book.pages != null)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.getCardBackgroundTransparent(
                                          isDark,
                                        ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.getBorderLight(isDark),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.description_outlined,
                                        size: 12.sp,
                                        color: AppColors.getTextSecondary(
                                          isDark,
                                        ),
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        "${widget.book.pages} pages",
                                        style: GoogleFonts.poppins(
                                          color: AppColors.getTextSecondary(
                                            isDark,
                                          ),
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.primaryGold,
                                size: 16.sp,
                              ),
                            ],
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
