import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/constants/colors.dart';

class Staticsircle extends StatelessWidget {
  final String label;
  final String value;
  final int size;
  final Color color;

  const Staticsircle(
    {
    super.key,
    required this.label,
    required this.value,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inriaSerif(
              color: AppColors.darkbackground,
              fontSize: 14.sp,
              height: 1.2,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            value,
            style: GoogleFonts.inriaSerif(
              color:  AppColors.darkbackground,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
