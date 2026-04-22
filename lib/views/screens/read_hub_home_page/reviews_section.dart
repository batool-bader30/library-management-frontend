import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/controllers/Review_controller.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/data/models/responses/reviews.dart';
import 'package:provider/provider.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewController = context.watch<ReviewController>();
    final reviews = reviewController.allreviews;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80.h, horizontal: 40.w),
      child: Column(
        children: [
          Text(
            "what’s people say",
            style: GoogleFonts.inriaSerif(
              color: AppColors.lightbackground,
              fontSize: 40.sp,
            ),
          ),
          SizedBox(height: 60.h),
          Wrap(
            spacing: 30.w,
            runSpacing: 30.h,
            alignment: WrapAlignment.center,
            children: reviews
                .take(3)
                .map((review) => _reviewCard(review))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _reviewCard(ReviewsModel review) => DottedBorder(
    color: const Color.fromRGBO(
      255,
      255,
      255,
      0.239,
    ), 
    strokeWidth: 1.5, // خمل الخط
    dashPattern: [10, 6], // خط طوله 10 وفراغ 6 (عشان يطلع شكل خطوط واضحة)
    borderType: BorderType.RRect, // لعمل زوايا دائرية
    radius: Radius.circular(20.r), // نفس الـ BorderRadius تبعك
    child: Container(
      width: 300.w,
      height: 370.h,
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        // شلنا الـ border من الـ BoxDecoration لأن الـ DottedBorder صار هو الإطار
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white10,
            child: Icon(Icons.person, color: Colors.white, size: 40),
          ),
          SizedBox(height: 20.h),
          Text(
            review.username ?? "Unknown",
            style:  GoogleFonts.inriaSerif(
              color: AppColors.lightbackground,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${review.rating}",
                style:  GoogleFonts.inriaSerif(
                  color: AppColors.lightbackground,
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 8.w),

              // هذا الجزء يولد قائمة من الصور بناءً على عدد التقييم
              ...List.generate(
                review.rating ?? 0, // عدد النجوم حسب الريتينغ
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                  child: Image.asset(
                    "assets/images/lightstar.png", // مسار صورة النجمة عندك
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 28.h),
          Text(
            review.comment ?? " ",
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inriaSerif(
              color: AppColors.lightbackground,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}
