# Design Document: Default Individual Login

## Overview

This design document describes the implementation approach for changing the default login type from "Student" to "Individual" on the signin screen. The change is minimal and focused, involving only a single state initialization modification in the `_LoginScreenState` class.

The current implementation uses a boolean state variable `isStudent` to control which login form is displayed. By changing its initial value from `true` to `false`, the screen will default to Individual mode instead of Student mode.

## Architecture

The signin screen follows Flutter's StatefulWidget pattern with the following structure:

```
LoginScreen (StatefulWidget)
  └── _LoginScreenState (State)
      ├── State Variables
      │   ├── isStudent: bool (controls login type)
      │   ├── Controllers (email, password, etc.)
      │   └── Animation Controllers
      └── UI Components
          ├── Login Type Toggle (Student/Individual)
          ├── Conditional Form Fields
          └── Login Button
```

The `isStudent` state variable is the single source of truth for determining which login form to display. When `isStudent` is `true`, the Student form is shown (College ID + College Email). When `isStudent` is `false`, the Individual form is shown (Email Address only).

## Components and Interfaces

### Modified Component: _LoginScreenState

**Location:** `lib/Core/auth/view/signin_screen.dart`

**Current State Initialization:**
```dart
class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // ... other state variables ...
  bool isStudent = true; // Current default
  // ... rest of class ...
}
```

**New State Initialization:**
```dart
class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // ... other state variables ...
  bool isStudent = false; // New default - Individual mode
  // ... rest of class ...
}
```

### Affected UI Components

**Login Type Toggle:**
- The toggle buttons use the `isStudent` state to determine which button is highlighted
- When `isStudent = false`, the "Individual" button will have the gold gradient
- When `isStudent = true`, the "Student" button will have the gold gradient

**Conditional Form Fields:**
- The form fields are conditionally rendered based on `isStudent`
- When `isStudent = false`: Shows single Email Address field
- When `isStudent = true`: Shows College ID and College Email fields

**Sign Up Link:**
- Only displayed when `isStudent = false` (Individual mode)
- Will be visible by default after the change

## Data Models

No data model changes are required. The existing state structure remains unchanged:

- `isStudent`: `bool` - Controls login type display
- `studentEmailController`: `TextEditingController` - For student email input
- `individualEmailController`: `TextEditingController` - For individual email input
- `collegeIdController`: `TextEditingController` - For college ID input
- `passwordController`: `TextEditingController` - For password input


## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Individual Mode UI Completeness
*For any* Login_Screen instance where isStudent is false, the rendered UI should display exactly the Individual login form components: a single Email Address input field (not College ID or College Email fields), the "Individual" toggle button with gold gradient styling, and the "Sign Up" link.

**Validates: Requirements 1.2, 1.3, 1.4, 1.5**

### Property 2: Student Mode UI Completeness
*For any* Login_Screen instance where isStudent is true, the rendered UI should display exactly the Student login form components: College ID input field, College Email input field (not the Individual Email field), the "Student" toggle button with gold gradient styling, and no "Sign Up" link.

**Validates: Requirements 2.2**

### Property 3: Toggle State Transitions
*For any* Login_Screen instance, tapping the "Student" toggle button should set isStudent to true, and tapping the "Individual" toggle button should set isStudent to false, regardless of the current state.

**Validates: Requirements 2.1, 2.3**

## Error Handling

No error handling changes are required for this feature. The change is a simple state initialization modification that does not introduce new error conditions. Existing error handling for authentication remains unchanged:

- Invalid credentials handling (existing)
- Network error handling (existing)
- Input validation (existing)

## Testing Strategy

This feature requires both unit tests and widget tests to ensure the state initialization change works correctly and doesn't break existing functionality.

### Unit Tests

Unit tests should verify specific examples and edge cases:

1. **Initial State Test**: Verify that `isStudent` is initialized to `false` in a new `_LoginScreenState` instance
2. **Toggle State Test**: Verify that toggling between modes updates the `isStudent` state correctly

### Widget Tests (Property-Based Testing)

Widget tests should verify the universal properties across different states:

1. **Property 1 Test**: For any widget state where `isStudent = false`, verify all Individual mode UI components are present and Student mode components are absent
2. **Property 2 Test**: For any widget state where `isStudent = true`, verify all Student mode UI components are present and Individual mode components are absent  
3. **Property 3 Test**: For any initial state, verify that tapping toggle buttons correctly transitions between modes

**Testing Configuration:**
- Use Flutter's widget testing framework
- Each property test should verify the property holds across multiple widget rebuilds
- Minimum 100 iterations per property test (where applicable for stateful testing)
- Tag format: **Feature: default-individual-login, Property {number}: {property_text}**

### Manual Testing Checklist

1. Open the app and verify Individual login form is displayed by default
2. Verify "Individual" toggle button has gold gradient
3. Verify only Email Address field is shown (not College ID or College Email)
4. Verify "Sign Up" link is visible
5. Tap "Student" toggle and verify Student form appears
6. Verify College ID and College Email fields are shown
7. Verify "Sign Up" link is hidden in Student mode
8. Tap "Individual" toggle and verify Individual form reappears
9. Verify animations work smoothly during transitions
