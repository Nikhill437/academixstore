import 'dart:developer';
import 'package:academixstore/Core/home/view/home_screen.dart';
import 'package:academixstore/Core/network/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiServices {
  final ApiService _apiService = ApiService();

  /// Register a new user
  /// Returns a Map containing success status, message, and user data with token
  Future<Map<String, dynamic>> register({
    required String email,
    required String fullName,
    required String mobile,
    required String password,
    String role = "user",
  }) async {
    try {
      final response = await _apiService.post(
        'auth/register',
        data: {
          "email": email,
          "full_name": fullName,
          "mobile": mobile,
          "password": password,
          "role": role,
          "is_active": true,
          "is_verified": true,
        },
      );

      // ✅ Null safety check
      if (response.data == null) {
        return {
          'success': false,
          'message': 'No response received from server',
          'data': null,
        };
      }

      if (response.data is! Map<String, dynamic>) {
        return {
          'success': false,
          'message': 'Invalid response format',
          'data': null,
        };
      }

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] == true && responseData['data'] != null) {
        final data = responseData['data'] as Map<String, dynamic>;
        log("Registration successful: $data");
        if (data['token'] != null) {
          await _storeAuthToken(data['token'] as String);
        }

        if (data['user'] != null) {
          await _storeUserData(data['user'] as Map<String, dynamic>);
        }
      }

      return responseData;
    } on DioException catch (e) {
      // ✅ Dio specific handling
      log("Dio error: ${e.type}");

      String message = 'Something went wrong';

      if (e.type == DioExceptionType.receiveTimeout) {
        message = 'Server is taking too long to respond';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Connection timeout';
      } else if (e.response != null && e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      }

      return {'success': false, 'message': message, 'data': null};
    } catch (e, stackTrace) {
      log("Error while registering: $e");
      log("StackTrace: $stackTrace");

      return {'success': false, 'message': 'Registration failed', 'data': null};
    }
  }

  /// Login user
  /// Returns a Map containing success status, message, and user data with token
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await _apiService.post(
        'auth/login',
        data: {"email": email, "password": password},
      );

      // Check if response.data is null
      if (response.data == null) {
        return {
          'success': false,
          'message': 'No response from server',
          'data': null,
        };
      }

      final responseData = response.data as Map<String, dynamic>;

      // Check if login was successful
      if (responseData['success'] == true && responseData['data'] != null) {
        final data = responseData['data'] as Map<String, dynamic>;

        // Store the token after successful login
        if (data['token'] != null) {
          await _storeAuthToken(data['token'] as String);
          log("Token stored successfully after login");
        }

        // Store user data
        if (data['user'] != null) {
          await _storeUserData(data['user'] as Map<String, dynamic>);
        }
        
        // Navigate only if context is still mounted
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        }
      }

      return responseData;
    } on DioException catch (e) {
      log("Dio error during login: ${e.type}");
      log("Response: ${e.response?.data}");

      String message = 'Login failed. Please try again.';

      // Extract error message from backend response
      if (e.response?.data != null) {
        if (e.response?.data is Map<String, dynamic>) {
          final errorData = e.response?.data as Map<String, dynamic>;
          message = errorData['message'] ?? message;
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        message = 'Server is taking too long to respond.';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'Unable to connect to server. Please check your internet connection.';
      }

      return {
        'success': false,
        'message': message,
        'data': null,
      };
    } catch (e, stackTrace) {
      log("Error while logging in: $e");
      log("StackTrace: $stackTrace");

      // Return error response
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
        'data': null,
      };
    }
  }

  /// Login user without automatic navigation
  /// Returns a Map containing success status, message, and user data with token
  Future<Map<String, dynamic>> loginWithoutNavigation({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        'auth/login',
        data: {"email": email, "password": password},
      );

      // Check if response.data is null
      if (response.data == null) {
        return {
          'success': false,
          'message': 'No response from server',
          'data': null,
        };
      }

      final responseData = response.data as Map<String, dynamic>;

      // Check if login was successful
      if (responseData['success'] == true && responseData['data'] != null) {
        final data = responseData['data'] as Map<String, dynamic>;

        // Store the token after successful login
        if (data['token'] != null) {
          await _storeAuthToken(data['token'] as String);
          log("Token stored successfully after login");
        }

        // Store user data
        if (data['user'] != null) {
          await _storeUserData(data['user'] as Map<String, dynamic>);
        }
      }

      return responseData;
    } on DioException catch (e) {
      log("Dio error during login: ${e.type}");
      log("Response: ${e.response?.data}");

      String message = 'Login failed. Please try again.';

      // Extract error message from backend response
      if (e.response?.data != null) {
        if (e.response?.data is Map<String, dynamic>) {
          final errorData = e.response?.data as Map<String, dynamic>;
          message = errorData['message'] ?? message;
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        message = 'Server is taking too long to respond.';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'Unable to connect to server. Please check your internet connection.';
      }

      return {
        'success': false,
        'message': message,
        'data': null,
      };
    } catch (e, stackTrace) {
      log("Error while logging in: $e");
      log("StackTrace: $stackTrace");

      // Return error response
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
        'data': null,
      };
    }
  }

  /// Store authentication token in SharedPreferences
  /// This token persists across app restarts and should not be cleared automatically
  Future<void> _storeAuthToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      log("Auth token stored successfully - will persist until explicit logout");
    } catch (e) {
      log("Error storing auth token: $e");
    }
  }

  /// Store user data in SharedPreferences
  Future<void> _storeUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Store individual user fields
      await prefs.setString('user_id', userData['id'] ?? '');
      await prefs.setString('user_email', userData['email'] ?? '');
      await prefs.setString('user_full_name', userData['full_name'] ?? '');
      await prefs.setString('user_role', userData['role'] ?? '');
      await prefs.setString('user_mobile', userData['mobile'] ?? '');
      await prefs.setBool('user_is_verified', userData['is_verified'] ?? false);

      // Store optional fields
      if (userData['profile_image_url'] != null) {
        await prefs.setString(
          'user_profile_image',
          userData['profile_image_url'],
        );
      }
      if (userData['college_id'] != null) {
        await prefs.setString('user_college_id', userData['college_id']);
      }
      if (userData['student_id'] != null) {
        await prefs.setString('user_student_id', userData['student_id']);
      }

      log("User data stored successfully");
    } catch (e) {
      log("Error storing user data: $e");
    }
  }

  /// Get stored authentication token
  Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      log("Error getting auth token: $e");
      return null;
    }
  }

  /// Check if user is logged in (has valid token)
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout user - clear all stored data
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear all auth related data
      await prefs.remove('auth_token');
      await prefs.remove('user_id');
      await prefs.remove('user_email');
      await prefs.remove('user_full_name');
      await prefs.remove('user_role');
      await prefs.remove('user_mobile');
      await prefs.remove('user_is_verified');
      await prefs.remove('user_profile_image');
      await prefs.remove('user_college_id');
      await prefs.remove('user_student_id');

      log("User logged out successfully - all data cleared");
    } catch (e) {
      log("Error during logout: $e");
    }
  }

  /// Get stored user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final userId = prefs.getString('user_id');
      if (userId == null) return null;

      return {
        'id': userId,
        'email': prefs.getString('user_email'),
        'full_name': prefs.getString('user_full_name'),
        'role': prefs.getString('user_role'),
        'mobile': prefs.getString('user_mobile'),
        'is_verified': prefs.getBool('user_is_verified'),
        'profile_image_url': prefs.getString('user_profile_image'),
        'college_id': prefs.getString('user_college_id'),
        'student_id': prefs.getString('user_student_id'),
      };
    } catch (e) {
      log("Error getting user data: $e");
      return null;
    }
  }
}
