class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;

  const ApiResponse({required this.success, this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJson) {
    return ApiResponse<T>(
      success: json['success'] == true,
      message: json['message'] as String?,
      data: json['data'] != null && fromJson != null ? fromJson(json['data']) : json['data'],
    );
  }

  Map<String, dynamic> toJson() => {'success': success, 'message': message, 'data': data};
}
