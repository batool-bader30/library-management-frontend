// lib/services/auth_services.dart
import 'package:dio/dio.dart';
import 'package:library_management_web_front/core/api/api_client.dart';
import 'package:library_management_web_front/data/models/responses/user.dart';
import 'package:library_management_web_front/data/models/responses/api_response.dart';
import 'package:library_management_web_front/data/models/responses/login_response.dart';
import 'package:library_management_web_front/core/errors/error_handler.dart'; // تأكدي من مسار الـ ErrorHandler

class AuthServices {
  Dio? dio;

  // دالة مساعدة داخلية لجلب Dio وتقليل التكرار
  Future<void> _initDio() async {
    dio = await ApiClient.getDio();
  }

  // 1. تسجيل الدخول (Login)
  Future<ApiResponse<AuthResponse>> login({required String email, required String password}) async {
    await _initDio();
    try {
      final response = await dio!.post("/auth/login", data: {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        AuthResponse authData = AuthResponse.fromJson(response.data);
        return ApiResponse(
            data: authData,
            statusCode: response.statusCode,
            message: authData.message);
      }
      return ApiResponse(statusCode: response.statusCode, message: "Login Failed");
    } catch (e) {
      return _mapFailureToResponse(e);
    }
  }

  // 2. إنشاء حساب جديد (Register)
  Future<ApiResponse<AuthResponse>> register(Map<String, dynamic> userData) async {
    await _initDio();
    try {
      final response = await dio!.post("/auth/register", data: userData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        AuthResponse authData = AuthResponse.fromJson(response.data);
        return ApiResponse(
            data: authData,
            statusCode: response.statusCode,
            message: authData.message ?? "Registered Successfully");
      }
      return ApiResponse(statusCode: response.statusCode, message: "Registration Failed");
    } catch (e) {
      return _mapFailureToResponse(e);
    }
  }

  // 3. جلب جميع المستخدمين (Get All Users)
  Future<ApiResponse<List<UserInfo>>> getAllUsers() async {
    await _initDio();
    try {
      final response = await dio!.get("/User/GetAllUsers");
      if (response.statusCode == 200) {
        List data = response.data;
        List<UserInfo> users = data.map((e) => UserInfo.fromJson(e)).toList();
        return ApiResponse(data: users, statusCode: 200);
      }
      return ApiResponse(statusCode: response.statusCode);
    } catch (e) {
      return _mapFailureToResponse(e);
    }
  }

  // 4. جلب مستخدم بواسطة المعرف (Get User By ID)
  Future<ApiResponse<UserInfo>> getUserById(String id) async {
    await _initDio();
    try {
      final response = await dio!.get("/User/GetUserById/$id");
      if (response.statusCode == 200) {
        return ApiResponse(
            data: UserInfo.fromJson(response.data),
            statusCode: 200);
      }
      return ApiResponse(statusCode: response.statusCode);
    } catch (e) {
      return _mapFailureToResponse(e);
    }
  }

  // 5. تحديث بيانات المستخدم (Update User)
  Future<ApiResponse<bool>> updateUser(String id, Map<String, dynamic> updateData) async {
    await _initDio();
    try {
      final response = await dio!.put("/User/UpdateUser/$id", data: updateData);
      if (response.statusCode == 200) {
        return ApiResponse(data: true, statusCode: 200, message: "User Updated Successfully");
      }
      return ApiResponse(data: false, statusCode: response.statusCode);
    } catch (e) {
      return _mapFailureToResponse(e);
    }
  }

  // 6. حذف مستخدم (Delete User)
  Future<ApiResponse<bool>> deleteUser(String id) async {
    await _initDio();
    try {
      final response = await dio!.delete("/User/$id");
      if (response.statusCode == 200) {
        return ApiResponse(data: true, statusCode: 200, message: "User Deleted Successfully");
      }
      return ApiResponse(data: false, statusCode: response.statusCode);
    } catch (e) {
      return _mapFailureToResponse(e);
    }
  }

  // ✅ الدالة السحرية التي تربط الـ Service بـ الـ ErrorHandler الخاص بكِ
  ApiResponse<T> _mapFailureToResponse<T>(dynamic e) {
    final failure = ErrorHandler.handle(e); // استخدام الكلاس تبعك
    return ApiResponse(
      statusCode: failure.statusCode ?? 0,
      message: failure.message,
    );
  }
}