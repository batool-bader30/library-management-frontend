import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/constants/assets.dart';
import 'package:library_management_web_front/core/utils/navigator_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/responsive.dart';
import 'homepage.dart';

class HeroSection extends StatefulWidget {
  final HomeController controller;
  const HeroSection({super.key, required this.controller});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // جلب حالة تسجيل الدخول عند البدء
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("accessToken");

    setState(() {
      isLoggedIn = (token != null && token.isNotEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(), // جلب النسخة هنا
      builder: (context, snapshot) {
        // تعريف متغيرات افتراضية لحين اكتمال التحميل
        String? token;
        bool isLoggedIn = false;

        if (snapshot.hasData) {
          token = snapshot.data!.getString("accessToken");
          isLoggedIn = (token != null && token.isNotEmpty);
        }

        return Stack(
          key: widget.controller.heroKey,
          children: [
            // 1. صورة الخلفية
            Container(
              height: isMobile ? 400 : 700.h,
              width: MediaQuery.sizeOf(context).width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.backgroundimage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(color: Colors.black.withOpacity(0.1)),
            ),

            // 2. المحتوى
            Positioned.fill(
              child: Column(
                children: [
                  SizedBox(height: 250.h),
                  Text(
                    "ReadHub library",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inriaSerif(
                      color: AppColors.lightbackground,
                      fontSize: isMobile ? 40.sp : 80.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "\"Your Gateway to knowledge\"",
                    style: GoogleFonts.inriaSerif(
                      color: AppColors.lightbackground,
                      fontSize: isMobile ? 40.sp : 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  ElevatedButton(
                    onPressed: () {
                      isLoggedIn
                          ? NavigatorUtils.navigateToHomeScreen(context)
                          : NavigatorUtils.navigateToLogInScreen(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightbackground,
                      foregroundColor: AppColors.darktext,
                      padding: EdgeInsets.symmetric(
                        horizontal: 50.w,
                        vertical: 20.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      "GET STARTED",
                      style: GoogleFonts.inriaSerif(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
