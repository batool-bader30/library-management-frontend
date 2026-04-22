import 'package:dio/dio.dart';
import 'package:library_management_web_front/core/api/api_client.dart';
import 'package:library_management_web_front/data/models/responses/SimpleBook.dart';
import 'package:library_management_web_front/data/models/responses/api_response.dart';
import 'package:library_management_web_front/data/models/responses/authormodel.dart';

import '../../core/errors/error_handler.dart';

class AuthorServices {
  Dio? dio;

  Future<void> _initDio() async {
    dio = await ApiClient.getDio();
  }

  Future<ApiResponse<List<AuthorModel>>> getAllAuthors() async {
    await _initDio();
    try {
      final response = await dio!.get("/Author/GetAllAuthors");
      if (response.statusCode == 200) {
        List data = response.data;
        List<AuthorModel> authors = data
            .map((e) => AuthorModel.fromJson(e))
            .toList();
        return ApiResponse(data: authors, statusCode: 200);
      }
      return ApiResponse(statusCode: response.statusCode);
    } catch (e) {
      return _mapFailureToResponse(e);
    }
  }

  Future<Response> addAuhtor({
    String? name,
    String? bio,
    String? imageUrl,
  }) async {
    await _initDio();
    try {
      final response = await dio!.post(
        '/Author/CreateAuthor',
        data: {"name": name, "bio": bio, "imageUrl": imageUrl ?? " "},
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }


Future<Response> deleteAuthor(int id) async {
  try {
    // نمرر الـ id في الرابط كما هو مطلوب في الـ API
    final response = await dio!.delete(
      '/Author/DeleteAuthorById/$id',
      options: Options(
        headers: {
          'accept': '*/*',
        },
      ),
    );

    return response;
  } on DioException catch (e) {
    // طباعة تفاصيل الخطأ في حال فشل الحذف
    rethrow;
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
