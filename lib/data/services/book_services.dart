import 'package:dio/dio.dart';
import 'package:library_management_web_front/core/api/api_client.dart';
import 'package:library_management_web_front/data/models/responses/SimpleBook.dart';
import 'package:library_management_web_front/data/models/responses/api_response.dart';
import 'package:library_management_web_front/data/models/responses/bookdetails.dart';

import '../../core/errors/error_handler.dart';
import '../models/requests/AddBookRequest.dart';

class BookServices {
  Dio? dio;

  Future<void> _initDio() async {
    dio = await ApiClient.getDio();
  }


  Future<ApiResponse<List<SimpleBook>>> getAllBooks() async {
    await _initDio();
    try {
      final response = await dio!.get("/Book/GetAllBooks");
      if (response.statusCode == 200) {
        List data = response.data;
        List<SimpleBook> books = data.map((e) => SimpleBook.fromJson(e)).toList();
        return ApiResponse(data: books, statusCode: 200);
      }
      return ApiResponse(statusCode: response.statusCode);
    } catch (e) {
      return _mapFailureToResponse(e);
    }
  }
  Future<ApiResponse<BookDetailsModel>> getBookById(int id) async {
    await _initDio();
    try {
      final response = await dio!.get("/Book/GetBookById/$id");
      if (response.statusCode == 200) {
        return ApiResponse(
            data: BookDetailsModel.fromJson(response.data),
            statusCode: 200);
      }
      return ApiResponse(statusCode: response.statusCode);
    } catch (e) {
      return _mapFailureToResponse(e);
    }
  }

 Future<Response> addBook(AddBookRequest bookData) async {
  await _initDio();
  try {
    Map<String, dynamic> formDataMap = {
      "Title": bookData.title,
      "Description": bookData.description,
      "ISBN": bookData.isbn,
      "AuthorId": bookData.authorId,
      "PageNumber": bookData.pageNumber,
      "Language": bookData.language,
      "PublishDate": bookData.publishDate,
    };

    // ✅ إرسال الصورة كـ MultipartFile باسم "ImageFile"
    if (bookData.imageUrl != null) {
      final bytes = await bookData.imageUrl!.readAsBytes();
      formDataMap["ImageFile"] = MultipartFile.fromBytes(
        bytes,
        filename: bookData.imageUrl!.name,
      );
    }

    if (bookData.categoryIds.isNotEmpty) {
      formDataMap["CategoryIds"] = bookData.categoryIds;
    }

    FormData formData = FormData.fromMap(
      formDataMap,
      ListFormat.multiCompatible,
    );

    final response = await dio!.post('/Book/AddBook', data: formData);
    return response;

  } on DioException catch (e) {
    rethrow;
  }
}
// دالة حذف كتاب بواسطة المعرف (ID)
Future<Response> deleteBook(int id) async {
  try {
    // نمرر الـ id في الرابط كما هو مطلوب في الـ API
    final response = await dio!.delete(
      '/Book/DeleteBook/$id',
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