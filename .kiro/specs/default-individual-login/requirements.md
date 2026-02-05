# Requirements Document

## Introduction

This feature changes the default login type on the signin screen from "Student" mode to "Individual" mode. Currently, when users open the signin screen, they see the Student login form by default (requiring College ID and College Email). After this change, users will see the Individual login form by default (requiring only Email Address), improving the user experience for the majority of users who are individuals rather than students.

## Glossary

- **Login_Screen**: The authentication screen component that allows users to sign in to the application
- **Login_Type**: The mode of authentication, either "Student" or "Individual"
- **Student_Mode**: Login mode requiring College ID and College Email fields
- **Individual_Mode**: Login mode requiring only Email Address field
- **isStudent_State**: Boolean state variable controlling which login form is displayed

## Requirements

### Requirement 1: Default Login Type

**User Story:** As a user opening the signin screen, I want to see the Individual login form by default, so that I can quickly access the most commonly used login method without needing to toggle modes.

#### Acceptance Criteria

1. WHEN the Login_Screen initializes, THE isStudent_State SHALL be set to false
2. WHEN the Login_Screen renders for the first time, THE Login_Screen SHALL display the Individual login form
3. WHEN the Login_Screen displays the Individual login form, THE Login_Screen SHALL show only the Email Address input field (not College ID or College Email)
4. WHEN the Login_Screen displays the Individual login form, THE Login_Screen SHALL highlight the "Individual" toggle button with the gold gradient
5. WHEN the Login_Screen displays the Individual login form, THE Login_Screen SHALL show the "Sign Up" link below the login form

### Requirement 2: Toggle Functionality Preservation

**User Story:** As a student user, I want to be able to switch to Student mode, so that I can still access the student login form when needed.

#### Acceptance Criteria

1. WHEN a user taps the "Student" toggle button, THE Login_Screen SHALL switch to Student_Mode
2. WHEN the Login_Screen switches to Student_Mode, THE Login_Screen SHALL display College ID and College Email input fields
3. WHEN a user taps the "Individual" toggle button from Student_Mode, THE Login_Screen SHALL switch back to Individual_Mode
4. WHEN the Login_Screen switches between modes, THE Login_Screen SHALL preserve the animation behavior for smooth transitions

### Requirement 3: State Consistency

**User Story:** As a developer, I want the state initialization to be consistent and maintainable, so that the default behavior is clear and predictable.

#### Acceptance Criteria

1. THE isStudent_State SHALL be initialized in the _LoginScreenState class
2. WHEN the _LoginScreenState initializes, THE isStudent_State SHALL have a value of false
3. THE isStudent_State initialization SHALL occur before any UI rendering
