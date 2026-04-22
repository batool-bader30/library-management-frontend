import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/data/models/responses/SimpleBook.dart';

import '../../core/utils/responsive.dart';

class BookCard extends StatelessWidget {
  final SimpleBook book;
  final bool isNew;

  // 2. تحديث الـ Constructor وجعل القيمة الافتراضية false
  const BookCard({required this.book, this.isNew = false, super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    return Container(
      width: isMobile ? 120.w : 140.w,
      margin: EdgeInsets.only(right: 15.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 3. استخدمنا Stack عشان نضع الشارة فوق الصورة
          SizedBox(
            height: isMobile ? 180.h : 220,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    (book.imageUrl != null && book.imageUrl!.startsWith('http'))
                        ? book.imageUrl!
                        : 'http://192.168.1.31:5000${book.imageUrl ?? ""}',
                    fit: BoxFit.fill,
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.white10,
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white24,
                          size: 30.sp,
                        ),
                      );
                    },
                  ),
                ),

                // 4. إضافة الشارة فقط إذا كان isNew = true
                if (isNew)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8C332B), // نفس اللون من الصورة
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "New",
                        style: GoogleFonts.inriaSerif(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            book.title ?? "No Title",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.inriaSerif(
              color: const Color(0xFFEAD7BB),
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
