import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_response.dart';

class ApiService {
  final Dio _dio = ApiClient().dio;

  // GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse.success(
        data: fromJson != null ? fromJson(response.data) : response.data,
        message: 'Success',
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse.success(
        data: fromJson != null ? fromJson(response.data) : response.data,
        message: 'Success',
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse.success(
        data: fromJson != null ? fromJson(response.data) : response.data,
        message: 'Success',
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse.success(
        data: fromJson != null ? fromJson(response.data) : response.data,
        message: 'Success',
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse.success(
        data: fromJson != null ? fromJson(response.data) : response.data,
        message: 'Success',
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Handle errors
  ApiResponse<T> _handleError<T>(DioException error) {
    String message = 'Something went wrong';
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please try again.';
        break;
      case DioExceptionType.badResponse:
        message = _handleStatusCode(error.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;
      default:
        message = 'Unexpected error occurred';
    }

    return ApiResponse.error(
      message: message,
      statusCode: error.response?.statusCode,
    );
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Service unavailable';
      default:
        return 'Error occurred';
    }
  }
}
