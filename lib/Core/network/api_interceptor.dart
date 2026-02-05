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
      // Handle unauthorized - but DON'T automatically clear token
      // Let the app handle this based on context
      // Only clear if it's a token validation endpoint
      final requestPath = err.requestOptions.path;
      
      // Only clear token if it's explicitly an auth validation failure
      if (requestPath.contains('auth/validate') || 
          requestPath.contains('auth/verify-token')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
      }
      // For other 401 errors, just pass them through
      // The app can decide what to do
    }

    super.onError(err, handler);
  }
}
