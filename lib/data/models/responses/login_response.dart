class AuthResponse {
  final bool? success;
  final String? token;
  final String? message;
  final String? role;

  AuthResponse({this.success, this.token, this.message, this.role});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    success: json['success'] ?? (json['token'] != null),
    token: json['token'],
    message: json['message'],
    role: json['role'],
  );
}