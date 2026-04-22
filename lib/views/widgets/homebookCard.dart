import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_management_web_front/data/models/responses/SimpleBook.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/core/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeBookCard extends StatelessWidget {
  final SimpleBook book;

  // يفضل وضعه في ملف constants لاحقاً
  static const String baseUrl = 'http://192.168.1.31:5000';

  const HomeBookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    // تعريف أبعاد الشاشة باستخدام MediaQuery
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    bool isMobile = Responsive.isMobile(context);

    return Container(
      // تحديد العرض بناءً على نوع الجهاز
      width: isMobile ? screenWidth * 0.42 : 160.w,
      height: isMobile ? 100 : 280.h,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF3D9B5),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // قسم الصورة باستخدام MediaQuery للأبعاد
          ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Image.network(
              (book.imageUrl != null && book.imageUrl!.startsWith('http'))
                  ? book.imageUrl!
                  : 'http://192.168.1.31:5000${book.imageUrl ?? ""}',
              fit: BoxFit.cover,
              width: screenWidth, // يعتمد على عرض الحاوية الأب
              height: isMobile ? screenHeight * 0.25 : 180.h,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: screenWidth,
                  height: isMobile ? screenHeight * 0.25 : 180.h,
                  color: Colors.white10,
                  child: Icon(
                    Icons.broken_image,
                    color: AppColors.darkbackground,
                    size: 40.sp,
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 12.h),

          // قسم النصوص (عنوان الكتاب والمؤلف)
          // تحديد ارتفاع ثابت للنصوص لضمان توازي الأزرار في الـ Wrap
          SizedBox(
            height: 30.h,
            child: Text(
              "${book.title}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inriaSerif(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.darktext,
              ),
            ),
          ),

          // قسم التقييم والزر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // التقييم
              Row(
                children: [
                  Text(
                    "4.0",
                    style: GoogleFonts.inriaSerif(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darktext,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.star, color: Colors.orange[800], size: 18.r),
                ],
              ),

              // زر الاستعارة
              ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkbackground,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10.w : 15.w,
                    vertical: 8.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Borrow",
                  style: GoogleFonts.inriaSerif(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
