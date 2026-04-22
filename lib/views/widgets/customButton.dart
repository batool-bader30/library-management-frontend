import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? size;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.size,
    this.textColor, this.height,
    
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:height?? 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              backgroundColor ??
              AppColors.darkbackground.withAlpha(150), // بني غامق [cite: 6]
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.inriaSerif(
            color:textColor?? AppColors.lightbackground,
            fontSize: size ?? 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
