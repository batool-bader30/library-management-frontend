import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_management_web_front/core/constants/assets.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import '../../controllers/home_controller.dart';
import '../../core/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomNavBar extends StatelessWidget {
  final HomeController controller;
  const CustomNavBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20.w : 80.w,
        vertical: 15.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Section
          Row(children: [Image.asset(Assets.logolight, height: 60)]),

          // Desktop Menu
          if (!isMobile)
            Row(
              children: [
                _navItem("Home", () => controller.scrollTo(controller.heroKey)),
                _navItem(
                  "About",
                  () => controller.scrollTo(controller.welcomeKey),
                ),
                _navItem(
                  "Books",
                  () => controller.scrollTo(controller.booksKey),
                ),
                _navItem(
                  "Reviews",
                  () => controller.scrollTo(controller.reviewsKey),
                ),
                _navItem(
                  "Contact",
                  () => controller.scrollTo(controller.footerKey),
                ),
              ],
            ),

          // Mobile Menu Icon
          if (isMobile)
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color(0xFFEAD7BB),
                  size: 30,
                ),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _navItem(String title, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          title,
          style: GoogleFonts.inriaSerif(
            color: AppColors.lightbackground,
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
