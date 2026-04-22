import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/constants/assets.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/core/utils/responsive.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Stack(
      children: [
        // 1. الصورة الشفافة (هي البيس/الأساس)
        Opacity(
          opacity: 0.8, // الشفافية المطلوبة للصورة نفسها
          child: ClipRRect(
            // لعمل حواف دائرية للصورة لتماشي التصميم السابق
            borderRadius: BorderRadius.circular(15.r),
            child: Image.asset(
              Assets.aboutbg, // الصورة التي ترغبين بها
              width: isMobile ? 400.w : 800.w,
              height: isMobile
                  ? 300.h
                  : 650, // ارتفاع مناسب للسيكشن، يمكنك تعديله
              // fit: BoxFit.cover,
            ),
          ),
        ),

        // 2. المحتوى (النصوص والإحصائيات) فوق الصورة
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.all(35.r), // البادينج للنصوص
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // لتوسط المحتوى عمودياً
              children: [
                Text(
                  "Welcome to Our Library!",
                  style: GoogleFonts.inriaSerif(
                    fontSize: isMobile ? 26.sp : 50.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darktext,
                  ),
                ),
                SizedBox(height: isMobile ? 15.h : 50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 130),
                  child: Text(
                    "We are here to provide you with an easy and enjoyable book borrowing experience. Our goal is to offer a wide variety of books for all ages and interests, with a simple and fast borrowing service. We always strive to spread the love of reading and encourage you to explore new worlds of knowledge and imagination.",
                    maxLines: isMobile ? 6 : 7,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inriaSerif(
                      fontSize: isMobile ? 15.sp : 19.sp,
                      color: AppColors.lightbackground,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 10.h : 40.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat("50+", "Authors", isMobile), // إضافة المتغير هنا
                    _buildStat("1k+", "Books", isMobile),
                    _buildStat("40+", "Categories", isMobile),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String val, String label, bool isMobile) => Column(
    children: [
      Text(
        val,
        style: GoogleFonts.inriaSerif(
          fontWeight: FontWeight.bold,
          // إذا موبايل الحجم 18، إذا ويب الحجم 32 (أو أي رقم تفضلينه)
          fontSize: isMobile ? 18.sp : 35.sp,
          color: AppColors.lightbackground,
        ),
      ),
      Text(
        label,
        style: GoogleFonts.inriaSerif(
          // إذا موبايل الحجم 11، إذا ويب الحجم 18
          fontSize: isMobile ? 11.sp : 18.sp,
          color: AppColors.lightbackground,
        ),
      ),
    ],
  );
}
