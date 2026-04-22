import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/controllers/book_controller.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/views/widgets/homebookCard.dart';
import 'package:provider/provider.dart';

class BooksSection extends StatelessWidget {
  const BooksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bookController = context.watch<BookController>();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60.h),
      child: Column(
        children: [
          Text(
            "Popular Books",
            style: GoogleFonts.inriaSerif(
              color: AppColors.lightbackground,
              fontSize: 35.sp,
            ),
          ),
          SizedBox(height: 50.h),

          Wrap(
            spacing: 25.w,
            runSpacing: 25.h,
            alignment: WrapAlignment.center,
            // جلب القائمة من البروفايدر
            children: bookController.books
                .take(4)
                .map((book) => HomeBookCard(book: book))
                .toList(),
          ),
          SizedBox(height: 50.h),
          // زر View All
          TextButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "view All",
                  style: GoogleFonts.inriaSerif(
                    color: const Color(0xFFEAD7BB),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 10.w),
                Icon(
                  Icons.arrow_right_alt,
                  color: const Color(0xFFEAD7BB),
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
