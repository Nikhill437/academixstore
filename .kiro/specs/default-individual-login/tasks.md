# Implementation Plan: Default Individual Login

## Overview

This implementation plan outlines the steps to change the default login type from "Student" to "Individual" on the signin screen. The change is minimal and focused on modifying a single state initialization value in the `_LoginScreenState` class.

## Tasks

- [x] 1. Update state initialization in signin_screen.dart
  - Change `bool isStudent = true;` to `bool isStudent = false;` in the `_LoginScreenState` class
  - Verify the change is in the correct location (line 27 of the file)
  - _Requirements: 1.1, 3.2_

- [ ]* 2. Write widget tests for Individual mode UI
  - **Property 1: Individual Mode UI Completeness**
  - **Validates: Requirements 1.2, 1.3, 1.4, 1.5**
  - Create widget test that verifies when isStudent is false, the UI displays:
    - Single Email Address input field
    - No College ID or College Email fields
    - "Individual" toggle button with gold gradient
    - "Sign Up" link is visible
  - _Requirements: 1.2, 1.3, 1.4, 1.5_

- [ ]* 3. Write widget tests for Student mode UI
  - **Property 2: Student Mode UI Completeness**
  - **Validates: Requirements 2.2**
  - Create widget test that verifies when isStudent is true, the UI displays:
    - College ID input field
    - College Email input field
    - No Individual Email field
    - "Student" toggle button with gold gradient
    - No "Sign Up" link
  - _Requirements: 2.2_

- [ ]* 4. Write widget tests for toggle functionality
  - **Property 3: Toggle State Transitions**
  - **Validates: Requirements 2.1, 2.3**
  - Create widget test that verifies:
    - Tapping "Student" toggle sets isStudent to true
    - Tapping "Individual" toggle sets isStudent to false
    - Transitions work from both initial states
  - _Requirements: 2.1, 2.3_

- [ ]* 5. Write unit test for initial state
  - Create unit test that verifies isStudent is initialized to false
  - Test should check the initial value immediately after state creation
  - _Requirements: 1.1, 3.2_

- [ ] 6. Checkpoint - Ensure all tests pass
  - Run all widget tests and unit tests
  - Verify no regressions in existing functionality
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster implementation
- The core change is minimal (single line modification)
- Tests ensure the change doesn't break existing toggle functionality
- Manual testing should verify smooth animations and visual appearance
