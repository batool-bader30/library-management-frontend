import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final double? width;
  final Color? textcolor;
  final Color? backgroundcolor;

  const CustomTextField({
    super.key,
    this.label,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.maxLines = 1,
    this.width, this.textcolor, this.backgroundcolor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child:label!=null
          ?Text(
            label??"",
            style: GoogleFonts.inriaSerif(
              color:textcolor?? AppColors.darktext,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          )
          :null,

        ),
        SizedBox(height: 2.h),
        Container(
          width: width ?? 350,
          decoration: BoxDecoration(
            color:backgroundcolor?? AppColors.darkbackground.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextFormField(
            maxLines: maxLines,
            controller: controller,
            obscureText: isPassword,
            style: GoogleFonts.inriaSerif(color:textcolor?? Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.inriaSerif(
                color:textcolor?? Colors.white60,
                fontSize: 16.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 15.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
