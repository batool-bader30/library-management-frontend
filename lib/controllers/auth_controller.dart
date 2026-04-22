// lib/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:library_management_web_front/data/models/responses/user.dart';
import 'package:library_management_web_front/data/models/responses/api_response.dart';
import 'package:library_management_web_front/data/models/responses/login_response.dart';
import 'package:library_management_web_front/data/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  AuthServices authServices = AuthServices();
  UserInfo? userInfo;
  bool isLoading = false;
  List<UserInfo> users = [];
  String errorMessage = '';

  // --- دالة تسجيل الدخول (Login) ---
  Future<ApiResponse<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    ApiResponse<AuthResponse> response = await authServices.login(
      email: email,
      password: password,
    );

    if (response.statusCode == 200 && response.data != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.data!.token != null) {
        await prefs.setString("accessToken", response.data!.token!);
      }
      if (response.data!.role != null) {
        await prefs.setString("userRole", response.data!.role!);
      }
    }

    _setLoading(false);
    return response;
  }

  // داخل AuthController
  String? getUserIdFromToken(String token) {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['UserId']; // الـ Key كما ظهر في الـ Log عندك
    } catch (e) {
      return null;
    }
  }

  // --- دالة إنشاء حساب جديد (Register) ---
  Future<ApiResponse<AuthResponse>> register(
    Map<String, dynamic> userData,
  ) async {
    _setLoading(true);

    // استدعاء السيرفر لتنفيذ عملية التسجيل
    ApiResponse<AuthResponse> response = await authServices.register(userData);

    // إذا نجح التسجيل، يمكننا حفظ التوكن مباشرة إذا كان السيرفر يرجعه مع الـ Register
    if (response.statusCode == 200 && response.data != null) {
      if (response.data!.token != null) {
        saveTokenOnSharedPrefs(accessToken: response.data!.token!);
      }
    }

    _setLoading(false);
    return response;
  }

  Future<void> getAllUsers() async {
    isLoading = true;

    errorMessage = '';

    notifyListeners(); // نبلغ الـ UI إنه صار في تحميل

    try {
      final response = await authServices.getAllUsers();

      if (response.statusCode == 200 && response.data != null) {
        users = response.data!;
      } else {
        errorMessage = response.message ?? "Failed to fetch users";
      }
    } catch (e) {
      errorMessage = "An unexpected error occurred: ${e.toString()}";
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  // دالة مساعدة لتحديث حالة التحميل وتنبيه الواجهات
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setUserInfo({required UserInfo userInfo}) {
    this.userInfo = userInfo;
    notifyListeners();
  }

  void saveTokenOnSharedPrefs({required String accessToken}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("accessToken", accessToken);
  }

  Future<String?> checkAuthStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("accessToken");
    String? role = prefs.getString("userRole");
    if (token != null && role != null) {
      return role;
    }
    return null;
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    userInfo = null;
    notifyListeners();
  }
}
