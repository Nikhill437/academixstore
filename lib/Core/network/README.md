# API Network Layer with Dio

This directory contains the complete REST API setup using Dio with interceptors.

## Structure

- `api_client.dart` - Singleton Dio client with base configuration
- `api_interceptor.dart` - Custom interceptor for auth tokens and error handling
- `api_service.dart` - Base service with all HTTP methods (GET, POST, PUT, DELETE, PATCH)
- `api_response.dart` - Standardized response wrapper
- `example_usage.dart` - Examples of how to use the API service

## Setup

1. **Install dependencies** (already added to pubspec.yaml):
   ```bash
   flutter pub get
   ```

2. **Configure base URL** in `api_client.dart`:
   ```dart
   baseUrl: 'https://your-api-base-url.com/api'
   ```

3. **Remove logger in production** - Comment out `PrettyDioLogger` in `api_client.dart`

## Usage

### Basic GET Request
```dart
final apiService = ApiService();
final response = await apiService.get('/books');

if (response.isSuccess) {
  print(response.data);
} else {
  print(response.message);
}
```

### POST Request with Data
```dart
final response = await apiService.post(
  '/auth/login',
  data: {
    'email': 'user@example.com',
    'password': 'password123',
  },
);
```

### With Query Parameters
```dart
final response = await apiService.get(
  '/books',
  queryParameters: {'category': 'fiction', 'limit': 10},
);
```

### With Model Parsing
```dart
final response = await apiService.get<Book>(
  '/books/123',
  fromJson: (data) => Book.fromJson(data),
);
```

## Features

- ✅ Automatic token injection from SharedPreferences
- ✅ Global error handling
- ✅ Request/Response logging (debug mode)
- ✅ Timeout configuration
- ✅ Standardized response format
- ✅ Type-safe responses
- ✅ Easy to extend for each module

## Authentication

The interceptor automatically adds the auth token from SharedPreferences:

```dart
// Save token after login
final prefs = await SharedPreferences.getInstance();
await prefs.setString('auth_token', 'your-token-here');

// Or use ApiClient directly
ApiClient().setAuthToken('your-token-here');
```

## Creating Module-Specific Services

Create a service class for each module:

```dart
class YourModuleService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<YourModel>> getData() async {
    return await _apiService.get('/your-endpoint');
  }
}
```

See `example_usage.dart` for more examples.
