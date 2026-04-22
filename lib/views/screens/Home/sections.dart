import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import '../../../core/utils/responsive.dart';

class Sections extends StatefulWidget {
  final String? title;
  final Widget carouselSlider;
  final CarouselSliderController controller;

  const Sections({
    super.key,
    this.title,
    required this.carouselSlider,
    required this.controller,
  });

  @override
  State<Sections> createState() => _SectionsState();
}

class _SectionsState extends State<Sections> {
  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 4.h : 15.h,
              horizontal: isMobile ? 5.w : 20.w,
            ),
            child: Text(
              widget.title ?? "",
              style: GoogleFonts.inriaSerif(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFEAD7BB),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 0.w : 60.w,
                ),
                child: widget.carouselSlider,
              ),
              // أسهم التصفح (تظهر في الويب فقط لجمالية التصميم)
              if (!isMobile)
                Positioned(
                  left: 0,
                  child: _buildArrow(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => widget.controller.previousPage(),
                  ),
                ),
              if (!isMobile)
                Positioned(
                  right: 0,
                  child: _buildArrow(
                    icon: Icons.arrow_forward_ios,
                    onTap: () => widget.controller.nextPage(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArrow({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(13.r),
        decoration: BoxDecoration(
          color: const Color(0xffC4C4C4).withOpacity(.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.darktext, size: 20.sp, weight: 900),
      ),
    );
  }
}
