import 'dart:io'; // ضروري للتعرف على الـ Platform (Android/iOS)
import 'package:flutter/foundation.dart'; // ضروري للتعرف على الـ Web (kIsWeb)
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String pcIp = "10.161.72.63"; // غيريه للـ IP تبع جهازك
static String  get storageUrl {
  if (kIsWeb) {
    return "http://localhost:5000";
  } else if (Platform.isAndroid) {
    return "http://$pcIp:5000";
  } else {
    return "http://localhost:5000";
  }
}

  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:5000/api";
    } else if (Platform.isAndroid) {
      return "http://$pcIp:5000/api";
    } else {
      return "http://localhost:5000/api";
    }
  }

  static Future<Dio> getDio() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer ${prefs.getString("accessToken")}",
      },
    );

    final dio = Dio(options);
    dio.interceptors.add(
      LogInterceptor(responseBody: true, requestBody: true),
    ); // بظهرلك كل تفاصيل الطلب
    return dio;
  }
}
