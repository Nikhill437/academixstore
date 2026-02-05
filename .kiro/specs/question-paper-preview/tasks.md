# Implementation Plan: Question Paper Preview

## Overview

This implementation plan breaks down the question paper preview feature into discrete, incremental coding tasks. Each task builds on previous work, with testing integrated throughout to catch errors early. The implementation follows the existing architecture patterns in the AcademixStore Flutter app.

## Tasks

- [ ] 1. Extend BookModel with question paper fields
  - Add `questionPaperUrl` and `questionPaperAccessUrl` nullable String fields to BookModel class
  - Update constructor to include new parameters
  - Update `fromJson` method to parse `question_paper_url` and `question_paper_access_url` from API response
  - Update `toJson` method to include question paper fields in serialization
  - Ensure null safety for all new fields
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 8.1, 8.2, 8.3, 8.4, 8.5_

- [ ]* 1.1 Write property test for JSON round trip
  - **Property 1: JSON Parsing Round Trip**
  - **Validates: Requirements 1.3, 1.4, 8.1**

- [ ]* 1.2 Write property test for null handling
  - **Property 2: Null Handling Resilience**
  - **Validates: Requirements 1.5, 8.2, 8.3, 8.4**

- [ ] 2. Add question paper preview state to BooksDetailsScreen
  - Add `_questionPaperFirstPageImage` state variable (PdfPageImage?)
  - Add `_loadingQuestionPaper` state variable (bool, default true)
  - Add `bookQuestionPaperUrl` parameter to BooksDetailsScreen constructor
  - Pass question paper URL from widget parameters to state
  - _Requirements: 2.6_

- [ ]* 2.1 Write property test for loading state independence
  - **Property 4: Loading State Independence**
  - **Validates: Requirements 2.6**

- [ ] 3. Implement question paper preview loading method
  - Create `_loadQuestionPaperFirstPage(String pdfUrl)` async method
  - Check if URL is empty/null and skip loading if so
  - Trim whitespace from URL using `replaceAll(RegExp(r'\s+'), '')`
  - Fetch PDF using http.get with error handling
  - Open PDF document using PdfDocument.openData
  - Render first page with dimensions 800x1200 in PNG format
  - Update state with rendered image and set loading to false
  - Handle all errors gracefully with logging and state updates
  - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 5.2, 5.6, 7.3, 7.5_

- [ ]* 3.1 Write property test for URL whitespace trimming
  - **Property 5: URL Whitespace Trimming**
  - **Validates: Requirements 5.2**

- [ ]* 3.2 Write property test for loading state finalization
  - **Property 6: Loading State Finalization**
  - **Validates: Requirements 5.6**

- [ ]* 3.3 Write property test for malformed URL resilience
  - **Property 7: Malformed URL Resilience**
  - **Validates: Requirements 7.5**

- [ ]* 3.4 Write unit test for render dimensions
  - **Example 1: Render Dimensions**
  - **Validates: Requirements 2.3**

- [ ] 4. Call question paper loading in initState
  - Add call to `_loadQuestionPaperFirstPage(widget.bookQuestionPaperUrl ?? '')` in initState
  - Ensure it runs in parallel with book preview loading
  - _Requirements: 2.1_

- [ ] 5. Implement question paper preview UI widget
  - Create `_buildQuestionPaperPreview(bool isDark)` method
  - Return SizedBox.shrink() if question paper URL is null or empty
  - Display "Question Paper Preview" section title with primaryGold color
  - Wrap preview in GestureDetector with onTap calling `_openQuestionPaperViewer`
  - Show loading indicator with "Loading question paper preview..." text when loading
  - Display first page image using Image.memory when loaded
  - Show "Preview not available" with quiz icon when load fails
  - Overlay "PREVIEW ONLY" watermark with 0.3 opacity and -0.5 rotation
  - Apply glassmorphic decoration with 16px border radius and 4.w padding
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 7.1_

- [ ]* 5.1 Write property test for conditional preview display
  - **Property 3: Conditional Preview Display**
  - **Validates: Requirements 3.1, 3.6**

- [ ]* 5.2 Write unit test for preview section ordering
  - **Example 2: Preview Section Ordering**
  - **Validates: Requirements 3.2**

- [ ]* 5.3 Write unit test for loading state UI
  - **Example 3: Loading State UI**
  - **Validates: Requirements 3.3**

- [ ]* 5.4 Write unit test for success state UI
  - **Example 4: Success State UI**
  - **Validates: Requirements 3.4**

- [ ]* 5.5 Write unit test for watermark overlay
  - **Example 5: Watermark Overlay**
  - **Validates: Requirements 3.5**

- [ ]* 5.6 Write unit test for styling consistency
  - **Example 6: Styling Consistency**
  - **Validates: Requirements 3.7, 6.2, 6.3**

- [ ]* 5.7 Write unit test for watermark styling consistency
  - **Example 7: Watermark Styling Consistency**
  - **Validates: Requirements 6.4**

- [ ]* 5.8 Write unit test for loading indicator consistency
  - **Example 8: Loading Indicator Consistency**
  - **Validates: Requirements 6.5**

- [ ]* 5.9 Write unit test for error message consistency
  - **Example 9: Error Message Consistency**
  - **Validates: Requirements 6.6**

- [ ]* 5.10 Write unit test for failed load error message
  - **Example 12: Failed Load Error Message**
  - **Validates: Requirements 7.1**

- [ ] 6. Integrate question paper preview into build method
  - Add call to `_buildQuestionPaperPreview(isDark)` in the build method's Column
  - Place it after the book PDF preview section and before the security notice
  - Ensure proper spacing with SizedBox(height: 3.h) after the section
  - _Requirements: 3.2_

- [ ] 7. Implement question paper viewer opening method
  - Create `_openQuestionPaperViewer()` async method
  - Get question paper URL from widget.bookQuestionPaperUrl
  - Check if URL is empty/null and show error dialog if so
  - Log the opening action with book ID
  - Navigate to SecurePDFScreen with question paper URL and userId watermark
  - Use PageRouteBuilder with FadeTransition (300ms duration)
  - Handle errors with try-catch and show error dialog
  - _Requirements: 4.1, 4.2, 4.7, 7.2_

- [ ]* 7.1 Write property test for secure viewer URL propagation
  - **Property 8: Secure Viewer URL Propagation**
  - **Validates: Requirements 4.2**

- [ ]* 7.2 Write unit test for tap navigation
  - **Example 10: Tap Navigation**
  - **Validates: Requirements 4.1**

- [ ]* 7.3 Write unit test for empty URL error dialog
  - **Example 11: Empty URL Error Dialog**
  - **Validates: Requirements 4.7**

- [ ] 8. Update navigation calls to pass question paper URL
  - Find all places where BooksDetailsScreen is instantiated (HomeScreen, BookmarksScreen, etc.)
  - Add `bookQuestionPaperUrl: book.questionPaperAccessUrl` parameter to each navigation call
  - Ensure backward compatibility by handling null values
  - _Requirements: 8.4_

- [ ] 9. Checkpoint - Ensure all tests pass
  - Run all unit tests and property tests
  - Verify no regressions in existing book preview functionality
  - Test with books that have question papers and books that don't
  - Test error scenarios (invalid URLs, network failures)
  - Ask the user if questions arise

- [ ]* 10. Write integration tests for complete flows
  - Test full flow: Load book details → See question paper preview → Tap preview → View in secure viewer
  - Test parallel loading of book and question paper previews
  - Test error recovery when question paper fails but book preview works
  - Test navigation from different screens with question paper data
  - _Requirements: All_

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Property tests validate universal correctness properties with 100+ iterations
- Unit tests validate specific examples and edge cases
- Integration tests ensure end-to-end functionality
- The implementation reuses existing SecurePDFScreen without modifications
- All question paper fields are nullable to maintain backward compatibility
- Error handling ensures the app never crashes due to question paper issues
