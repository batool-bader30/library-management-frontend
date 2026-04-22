import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/views/widgets/Drawer.dart';
import '../../core/constants/colors.dart'; // تأكد من المسار الصحيح للألوان

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkbackground,
      drawer:  const AppDrawer(),
      appBar:AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(
                color: const Color(0xFFEAD7BB),
                size: 24.sp,
              ),
            ),
       
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Column(
            children: [
              Text(
                      "About Us",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inriaSerif(
                        fontSize: 35.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFEAD7BB),
                      ),
                    ),
                    SizedBox(height: 80,),
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.all(25.r),
                decoration: BoxDecoration(
                  // محاكاة شكل الورقة القديمة في الصورة
                  color: const Color(0xFF8D6E63).withOpacity(0.2), 
                  image: const DecorationImage(
                    image: AssetImage("assets/images/paper_texture.png"), // ضع صورة الملمس هنا إذا توفرت
                    fit: BoxFit.cover,
                    opacity: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   
                    
                    // العنوان الرئيسي
                    Text(
                      "Welcome to Our Library!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inriaSerif(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFEAD7BB),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    
                    // النص الوصفي
                    Text(
                      "We are here to provide you with an easy and enjoyable book borrowing experience. Our goal is to offer a wide variety of books for all ages and interests, with a simple and fast borrowing service. We always strive to spread the love of reading and encourage you to explore new worlds of knowledge and imagination.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inriaSerif(
                        fontSize: 16.sp,
                        height: 1.6,
                        color: const Color(0xFFEAD7BB).withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    
                    // الإحصائيات (الأرقام)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem("50+", "Authors"),
                        _buildStatItem("1k+", "Books"),
                        _buildStatItem("40+", "Categories"),
                      ],
                    ),
                  ],
                ),
              ),
                                  SizedBox(height: 150,),

            ],
          ),
        ),
      ),
    );
  }

  // أداة مساعدة لبناء الإحصائيات
  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.inriaSerif(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFEAD7BB),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inriaSerif(
            fontSize: 14.sp,
            color: const Color(0xFFEAD7BB).withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}