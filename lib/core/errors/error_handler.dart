import 'package:dio/dio.dart';
import 'failure.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return Failure("Connection timeout with the server.");
        case DioExceptionType.badResponse:
          return _handleApiError(error.response?.statusCode, error.response?.data);
        case DioExceptionType.connectionError:
          return Failure("No internet connection. Please check your network.");
        default:
          return Failure("Oops! Something went wrong. Please try again.");
      }
    } else {
      return Failure(error.toString());
    }
  }

  static Failure _handleApiError(int? statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        return Failure("Invalid request. Please check your input.", statusCode: 400);
      case 401:
        return Failure("Unauthorized. Please login again.", statusCode: 401);
      case 404:
        return Failure("The requested resource was not found.", statusCode: 404);
      case 500:
        return Failure("Internal Server Error. Please contact the administrator.", statusCode: 500);
      default:
        return Failure(data['message'] ?? "Unknown error occurred", statusCode: statusCode);
    }
  }
}