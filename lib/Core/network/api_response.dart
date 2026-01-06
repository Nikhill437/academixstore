class ApiResponse<T> {
  final T? data;
  final String message;
  final bool isSuccess;
  final int? statusCode;

  ApiResponse({
    this.data,
    required this.message,
    required this.isSuccess,
    this.statusCode,
  });

  factory ApiResponse.success({
    T? data,
    required String message,
    int? statusCode,
  }) {
    return ApiResponse(
      data: data,
      message: message,
      isSuccess: true,
      statusCode: statusCode ?? 200,
    );
  }

  factory ApiResponse.error({
    required String message,
    int? statusCode,
  }) {
    return ApiResponse(
      data: null,
      message: message,
      isSuccess: false,
      statusCode: statusCode,
    );
  }
}
