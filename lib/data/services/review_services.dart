import 'package:dio/dio.dart';
import 'package:library_management_web_front/core/api/api_client.dart';
import 'package:library_management_web_front/data/models/responses/api_response.dart';
import 'package:library_management_web_front/data/models/responses/reviews.dart';
import '../../core/errors/error_handler.dart';

class ReviewServices {
  Dio? dio;

  Future<void> _initDio() async {
    dio = await ApiClient.getDio();
  }

  // --- جلب جميع المراجعات ---
  Future<ApiResponse<List<ReviewsModel>>> getAllReviews() async {
    await _initDio();
    try {
      final response = await dio!.get("/Review/GetAllReviews");
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = response.data;
        List<ReviewsModel> reviews = data
            .map((e) => ReviewsModel.fromJson(e))
            .toList();
        return ApiResponse(data: reviews, statusCode: 200);
      }
      return ApiResponse(statusCode: response.statusCode);
    } catch (e) {
      return _mapFailureToResponse(e);
    }
  }

  // --- إنشاء مراجعة جديدة (الإضافة الجديدة) ---
  Future<ApiResponse<void>> createReview({
    required int bookId,
    required String userId,
    required String comment,
    required int rating,
  }) async {
    await _initDio();
    try {
      // تجهيز الـ Body بناءً على المثال الذي أرفقته
      final Map<String, dynamic> reviewData = {
        "bookId": bookId,
        "userId": userId,
        "comment": comment,
        "rating": rating,
      };

      final response = await dio!.post(
        "/Review/CreateReview",
        data: reviewData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          statusCode: response.statusCode,
          message: "Review created successfully",
        );
      }
      return ApiResponse(
        statusCode: response.statusCode,
        message: "Failed to create review",
      );
    } catch (e) {
      return _mapFailureToResponse(e);
    }
  }

  Future<ApiResponse<List<ReviewsModel>>> getReviewsByBookId(int bookId) async {
    try {
      final response = await dio!.get('/Review/GetReviewsByBookId/$bookId');
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<ReviewsModel> reviews = (response.data as List)
            .map((item) => ReviewsModel.fromJson(item))
            .toList();
        return ApiResponse(statusCode: 200, data: reviews);
      }
      return ApiResponse(
        statusCode: response.statusCode,
        message: "Failed to load reviews",
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, message: e.toString());
    }
  }


  Future<ApiResponse<List<ReviewsModel>>> getReviewsByUserId(String userId) async {
    try {
      // استدعاء الرابط بناءً على التوثيق اللي أرفقته
      final response = await dio!.get('/Review/GetReviewsByUserId/$userId');

      if (response.statusCode == 200) {
         List<ReviewsModel> reviews = (response.data as List)
            .map((item) => ReviewsModel.fromJson(item))
            .toList();
        return ApiResponse(statusCode: 200, data: reviews);
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      return ApiResponse(statusCode: 500, message: e.toString());
    }
  }



  ApiResponse<T> _mapFailureToResponse<T>(dynamic e) {
    final failure = ErrorHandler.handle(e);
    return ApiResponse(
      statusCode: failure.statusCode ?? 0,
      message: failure.message,
    );
  }
}
