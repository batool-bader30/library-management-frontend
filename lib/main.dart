import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_management_web_front/controllers/Review_controller.dart';
import 'package:library_management_web_front/controllers/author_controller.dart';
import 'package:library_management_web_front/controllers/book_controller.dart';
import 'package:library_management_web_front/controllers/borrowing_controller.dart';
import 'package:library_management_web_front/core/utils/network_connection.dart';
import 'package:library_management_web_front/core/utils/responsive.dart';
import 'package:library_management_web_front/views/screens/Home/homapage.dart';
import 'package:library_management_web_front/views/screens/admin/AdminDashboardPage.dart';
import 'package:library_management_web_front/views/screens/login.dart';
import 'package:library_management_web_front/views/screens/read_hub_home_page/homepage.dart';
import 'package:library_management_web_front/views/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString("accessToken");
  final String? role = prefs.getString("userRole"); // جلب الدور (admin أو user)

  bool userStatus = (token != null && token.isNotEmpty);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => BookController()),
        ChangeNotifierProvider(create: (_) => AuthorController()),
        ChangeNotifierProvider(create: (_) => ReviewController()),
        ChangeNotifierProvider(create: (_) => BorrowingController()),
      ],
      // نمرر الـ Role أيضاً للـ MyApp
      child: MyApp(isLoggedIn: userStatus, userRole: role),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? userRole; // إضافة متغير الدور

  const MyApp({super.key, required this.isLoggedIn, this.userRole});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = Responsive.isWeb(context);

        return ScreenUtilInit(
          designSize: isWeb ? const Size(1528, 706) : const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'ReadHub Library',
              theme: ThemeData(
                // ... تنسيقات الثيم الخاصة بك كما هي
                useMaterial3: true,
              ),
              // المنطق الجديد للتوجيه:
              home: _getHome(),
            );
          },
        );
      },
    );
  }

  // دالة لتحديد الشاشة الرئيسية
  Widget _getHome() {
    if (kIsWeb) {
      if (!isLoggedIn) {
        return const ReadHubHomePage();
      }

      // التوجيه بناءً على الدور
      if (userRole == "Admin") {
        return const AdminDashboardScreen(); // شاشة الأدمن
      } else {
        return const HomePage(); // شاشة المستخدم العادي (مثلاً)
      }
    } else {
      return SplashScreen(isLoggedIn: isLoggedIn);
    }
  }
}
