import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add authentication token from shared preferences if available
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add any custom headers here
    options.headers['X-App-Version'] = '1.0.0';
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // Handle successful responses
    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle errors globally
    if (err.response?.statusCode == 401) {
      // Handle unauthorized - clear token and redirect to login
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      // You can add navigation logic here if needed
    }

    super.onError(err, handler);
  }
}
