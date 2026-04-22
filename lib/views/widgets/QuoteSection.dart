import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import '../../core/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteSection extends StatelessWidget {
  const QuoteSection({super.key});

  @override
  Widget build(BuildContext context) {
    // تحديد نوع الجهاز داخل الـ build لضمان توفر الـ context
    bool isMobile = Responsive.isMobile(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            // إذا موبايل العرض كامل (بناءً على الـ LayoutBuilder)، إذا ويب العرض 500
            width: isMobile ? constraints.maxWidth : 550.w,
            // مارجن بسيط للموبايل عشان ما يلزق بالحواف
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 15.w : 0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/quote.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 50 : 140,
                    vertical: isMobile ? 20 : 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 1. العنوان
                      Text(
                        "Quote of the Day",
                        style: GoogleFonts.inriaSerif(
                          color: AppColors.darktext,
                          fontWeight: FontWeight.w900,
                          fontSize: isMobile ? 22.sp : 30.sp,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // 2. المقولة
                      Expanded(
                        child: Center(
                          child: Text(
                            '"A reader lives a thousand lives before he dies. The man who never reads lives only one."',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inriaSerif(
                              color: AppColors.darktext,
                              fontStyle: FontStyle.italic,
                              fontSize: isMobile ? 16.sp : 20.sp,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                      // 3. كاتب المقولة
                      Text(
                        "George R. R. Martin",
                        style: GoogleFonts.inriaSerif(
                          color: AppColors.darktext,
                          fontSize: isMobile ? 13.sp : 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
