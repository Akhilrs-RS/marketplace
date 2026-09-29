class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? meta;
  final String? error;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.meta,
    this.error,
  });

  factory ApiResponse.success({
    required T data,
    String? message,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
      meta: meta,
    );
  }

  factory ApiResponse.error({
    required String error,
    String? message,
  }) {
    return ApiResponse(
      success: false,
      error: error,
      message: message ?? error,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (data != null) 'data': toJsonT(data as T),
      if (meta != null) 'meta': meta,
      if (error != null) 'error': error,
    };
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      meta: json['meta'] as Map<String, dynamic>?,
      error: json['error'] as String?,
    );
  }
}
