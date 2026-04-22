import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/home_controller.dart';

class FooterSection extends StatelessWidget {
  final HomeController controller;
  const FooterSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/footer.png"),
          fit: BoxFit.cover,
        ),
      ),
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              const SizedBox(height: 100),
              _navItem("Home", () => controller.scrollTo(controller.heroKey)),
              _navItem(
                "About",
                () => controller.scrollTo(controller.welcomeKey),
              ),
              _navItem("Books", () => controller.scrollTo(controller.booksKey)),
            ],
          ),
          const SizedBox(width: 300),

          const SizedBox(width: 400),
          Column(
            children: [
              const SizedBox(height: 100),
              _navItem(
                "Categories",
                () => controller.scrollTo(controller.categoriesKey),
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
            fontSize: 18.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
