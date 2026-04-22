import 'package:dio/dio.dart';
import 'package:library_management_web_front/core/api/api_client.dart';
import 'package:library_management_web_front/data/models/requests/borrowrequest.dart';
import 'package:library_management_web_front/data/models/responses/BorrwingDetailsModel.dart';
import 'package:library_management_web_front/data/models/responses/api_response.dart';

import '../../core/errors/error_handler.dart';

class BorrowingServices {
  Dio? dio;

  Future<void> _initDio() async {
    dio = await ApiClient.getDio();
  }

  Future<ApiResponse<bool>> borrowBook(BorrowRequest request) async {
    await _initDio();
    try {
      final response = await dio!.post(
        "/Borrowing/CreateBorrowing",
        data: {
          "bookId": request.bookId,
          "userId": request.userId,
          "borrowDate": request.borrowDate,
          "returnDate": request.returnDate,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(data: true, statusCode: response.statusCode);
      }

      return ApiResponse(
        data: false,
        statusCode: response.statusCode,
        message: "Failed to process borrowing request",
      );
    } catch (e) {
      return _mapFailureToResponse<bool>(e);
    }
  }

  Future<ApiResponse<List<BorrwingDetailsModel>>> getBorrowingByUserId(
    String id,
  ) async {
    await _initDio();
    try {
      final response = await dio!.get("/Borrowing/GetBorrowingsByUser/$id");
      if (response.statusCode == 200) {
        List data = response.data;
        List<BorrwingDetailsModel> borrowings = data
            .map((e) => BorrwingDetailsModel.fromJson(e))
            .toList();
        return ApiResponse(data: borrowings, statusCode: 200);
      }
      return ApiResponse(statusCode: response.statusCode);
    } catch (e) {
      return _mapFailureToResponse(e);
    }
  }

  Future<bool> updateBorrowingStatus(
    DateTime returnDate,
    int status,
    int id,
  ) async {
    try {
      // نمرر الـ id في الرابط والـ updateData في الـ body
      final response = await dio!.put(
        '/Borrowing/UpdateBorrowing/$id',
        data:  {
            // نستخدم toIso8601String() لحل مشكلة التنسيق
            "returnDate": returnDate.toIso8601String(),
            "status": status,
          
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        // هذه الجملة ستطبع لكِ الرد المفصل من الباك أند (مثلاً: لماذا الـ Enum مرفوض)
        print("❌ Dio Error Status: ${e.response?.statusCode}");
        print("❌ Dio Error Data: ${e.response?.data}");
        print("❌ Dio Error Message: ${e.message}");
      } else {
        print("❌ Unknown Error: $e");
      }
      return false;
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
