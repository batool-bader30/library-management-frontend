import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/views/widgets/staticsircle.dart';

import '../widgets/SidebarMenu.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkbackground,
      body: Row(
        children: [
          const SidebarMenu(), // القائمة الجانبية التي جهزناها
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // خلفية الكتاب المفتوح
                  Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      "assets/images/book.png", // نفس الصورة المستخدمة في الفيدباك
                      width: MediaQuery.sizeOf(context).width,
                      height: 650.h,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Column(
                      children: [
                        // عنوان الصفحة وأيقونات الإعدادات
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "User Profile",
                                style: GoogleFonts.inriaSerif(
                                  fontSize: 32.sp,
                                  color: AppColors.lightbackground,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.settings,
                                    color: Colors.white70,
                                    size: 28.sp,
                                  ),
                                  SizedBox(width: 15.w),
                                  Icon(
                                    Icons.chat_bubble,
                                    color: Colors.white70,
                                    size: 28.sp,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),

                        // صورة الشخص الشخصية مع زر التعديل
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60.r,
                              backgroundColor: AppColors.lightbackground,
                              child: Icon(
                                Icons.person,
                                size: 80.r,
                                color: AppColors.darktext,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: _buildEditIcon(),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),

                        // حقول المعلومات (الاسم، الايميل، الهاتف)
                        _buildInfoField("batool osama"),
                        SizedBox(height: 10.h),
                        _buildInfoField("batool@gmail.com"),

                        SizedBox(height: 10.h),
                        _buildInfoField("078032650"),

                        SizedBox(height: 50.h),

                        // الدوائر الإحصائية
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Staticsircle(
                              label: "Reviews",
                              value: '48',
                              size: 130,
                              color: AppColors.lightbackground,
                            ),
                            SizedBox(width: 30.w),
                            const Staticsircle(
                              label: 'Currently\nReading',
                              value: '3',
                              size: 130,
                              color: AppColors.lightbackground,
                            ),
                            SizedBox(width: 30.w),
                            const Staticsircle(
                              label: 'Books\nBorrowed',
                              value: '20',
                              size: 130,
                              color: AppColors.lightbackground,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // أيقونة التعديل الصغيرة (القلم)
  Widget _buildEditIcon({double size = 15}) {
    return Container(
      padding: EdgeInsets.all(9.r),
      decoration: const BoxDecoration(
        color: Color(0xFF4E2916),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.edit, color: Colors.white, size: size.r),
    );
  }

  Widget _buildInfoField(String value) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.lightbackground.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: GoogleFonts.inriaSerif(
              color: AppColors.darktext,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    );
  }
}
