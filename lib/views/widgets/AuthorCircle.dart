import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/data/models/responses/authormodel.dart';

class AuthorCircle extends StatelessWidget {
  final AuthorModel author;

  const AuthorCircle({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    String? finalImageUrl = author.imageUrl;

    if (finalImageUrl != null && !finalImageUrl.startsWith('http')) {
      finalImageUrl = 'http://192.168.1.31:5000$finalImageUrl';
    }

    return Padding(
      padding: EdgeInsets.only(right: 20.w), // جعل المسافة متجاوبة
      child: Column(
        children: [
          SizedBox(height: 16.h),

          CircleAvatar(
            radius: 50.r, // قطر متجاوب
            backgroundColor: Colors.white10,
            // استخدام Image.network داخل الـ backgroundImage أو استخدام التبديل التالي:
            backgroundImage: (finalImageUrl != null && finalImageUrl.isNotEmpty)
                ? NetworkImage(finalImageUrl)
                : const AssetImage('assets/images/author_placeholder.png')
                      as ImageProvider,

            // في حال فشل تحميل الصورة من الرابط، يظهر الـ Placeholder
            onBackgroundImageError: (exception, stackTrace) {
              // هاد الجزء اختياري عشان التطبيق ما يكرش لو الرابط خرب
            },
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: 120.w, // تحديد عرض للنص عشان ما يضرب التصميم لو الاسم طويل
            child: Text(
              author.name ?? "Unknown",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inriaSerif(
                color: const Color(0xFFE5DCD4),
                fontSize: 18.sp, // نص متجاوب
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
