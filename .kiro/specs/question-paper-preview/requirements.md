# Requirements Document

## Introduction

This document specifies the requirements for adding question paper preview functionality to the AcademixStore Flutter application. The feature will extend the existing book preview system to support question papers associated with books, allowing users to preview and view question papers with the same security measures applied to book PDFs.

## Glossary

- **System**: The AcademixStore Flutter application
- **Book**: A digital textbook or educational resource available in the application
- **Question_Paper**: A PDF document containing practice questions or exam papers associated with a book
- **Preview**: A rendered image of the first page of a PDF document displayed in the book details screen
- **Secure_PDF_Viewer**: A protected PDF viewing component that prevents screenshots and applies watermarks
- **Book_Model**: The data structure representing a book and its associated metadata
- **API**: The backend service that provides book and question paper data
- **User**: An individual using the AcademixStore application

## Requirements

### Requirement 1: Question Paper Data Model

**User Story:** As a developer, I want to extend the book data model to include question paper information, so that question papers can be associated with books.

#### Acceptance Criteria

1. THE Book_Model SHALL include a questionPaperUrl field to store the question paper PDF URL
2. THE Book_Model SHALL include a questionPaperAccessUrl field to store the authenticated access URL
3. WHEN parsing JSON from the API, THE System SHALL extract question_paper_url and question_paper_access_url fields
4. WHEN serializing to JSON, THE System SHALL include question paper fields in the output
5. THE System SHALL handle null or missing question paper URLs gracefully

### Requirement 2: Question Paper Preview Loading

**User Story:** As a user, I want to see a preview of the question paper's first page, so that I can understand what the question paper contains before viewing it.

#### Acceptance Criteria

1. WHEN a book has a valid questionPaperAccessUrl, THE System SHALL fetch the question paper PDF
2. WHEN the question paper PDF is fetched, THE System SHALL render the first page as an image
3. WHEN rendering the first page, THE System SHALL use dimensions of 800x1200 pixels in PNG format
4. IF the question paper URL is empty or null, THE System SHALL skip loading and display a "not available" message
5. WHEN the question paper fails to load, THE System SHALL log the error and display an appropriate message
6. THE System SHALL maintain separate loading states for book preview and question paper preview

### Requirement 3: Question Paper Preview Display

**User Story:** As a user, I want to see the question paper preview section in the book details screen, so that I can view question paper information alongside book information.

#### Acceptance Criteria

1. WHEN a book has a question paper available, THE System SHALL display a "Question Paper Preview" section
2. THE Question_Paper_Preview_Section SHALL appear after the book PDF preview section
3. WHEN the question paper is loading, THE System SHALL display a loading indicator with the text "Loading question paper preview..."
4. WHEN the question paper preview loads successfully, THE System SHALL display the first page image
5. WHEN the question paper preview is displayed, THE System SHALL overlay "PREVIEW ONLY" watermark text
6. WHEN no question paper is available, THE System SHALL not display the question paper preview section
7. THE System SHALL apply the same glassmorphic styling to the question paper preview as the book preview

### Requirement 4: Question Paper Secure Viewing

**User Story:** As a user, I want to view the full question paper with security protections, so that I can study the questions while the content remains protected.

#### Acceptance Criteria

1. WHEN a user taps on the question paper preview, THE System SHALL open the Secure_PDF_Viewer
2. THE Secure_PDF_Viewer SHALL load the question paper using the questionPaperAccessUrl
3. THE Secure_PDF_Viewer SHALL apply a watermark using the user's ID
4. THE Secure_PDF_Viewer SHALL prevent screenshots and screen recording
5. THE Secure_PDF_Viewer SHALL enable secure mode on Android devices
6. THE Secure_PDF_Viewer SHALL detect screen capture on iOS devices
7. IF the question paper URL is empty or null, THE System SHALL display an error dialog with the message "Question paper URL not available"

### Requirement 5: PDF Preview Reliability

**User Story:** As a user, I want the book PDF preview to display reliably when a PDF exists, so that I can always see a preview of the book content.

#### Acceptance Criteria

1. WHEN a book has a valid pdfAccessUrl, THE System SHALL fetch and display the PDF preview
2. THE System SHALL trim whitespace from PDF URLs before fetching
3. WHEN the PDF fetch returns status code 200, THE System SHALL render the first page
4. WHEN the PDF fetch fails, THE System SHALL log the HTTP status code
5. WHEN PDF rendering encounters an error, THE System SHALL log the error details
6. THE System SHALL set loading state to false after preview loading completes or fails

### Requirement 6: User Interface Consistency

**User Story:** As a user, I want the question paper preview to match the visual style of the book preview, so that the interface feels cohesive and professional.

#### Acceptance Criteria

1. THE Question_Paper_Preview_Section SHALL use the same container styling as the book preview
2. THE Question_Paper_Preview_Section SHALL use the same border radius (16 pixels) as the book preview
3. THE Question_Paper_Preview_Section SHALL use the same padding (4% of screen width) as the book preview
4. THE Question_Paper_Preview_Section SHALL display the same "PREVIEW ONLY" watermark styling
5. THE Question_Paper_Preview_Section SHALL use the same loading indicator styling
6. THE Question_Paper_Preview_Section SHALL use the same error message styling
7. THE Question_Paper_Preview_Section SHALL include the same security notice about screenshot protection

### Requirement 7: Error Handling

**User Story:** As a user, I want clear error messages when question papers fail to load, so that I understand what went wrong.

#### Acceptance Criteria

1. WHEN a question paper PDF fails to fetch, THE System SHALL display "Preview not available" message
2. WHEN opening a question paper with an invalid URL, THE System SHALL display an error dialog
3. WHEN a network error occurs during question paper loading, THE System SHALL log the error
4. THE System SHALL continue functioning normally even if question paper loading fails
5. THE System SHALL not crash or freeze when question paper URLs are malformed

### Requirement 8: API Integration

**User Story:** As a developer, I want the system to properly parse question paper data from the API, so that question papers are correctly associated with books.

#### Acceptance Criteria

1. WHEN the API returns book data, THE System SHALL parse the question_paper_access_url field
2. THE System SHALL handle API responses where question_paper_access_url is null
3. THE System SHALL handle API responses where question_paper_access_url is missing
4. THE System SHALL maintain backward compatibility with existing API responses that lack question paper fields
5. THE System SHALL not fail when question paper fields are absent from API responses
