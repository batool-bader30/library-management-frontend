import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/responsive.dart';

class CategoryCarouselSlider extends StatelessWidget {
  CategoryCarouselSlider({super.key});

  final CarouselSliderController controller = CarouselSliderController();

  final List<String> categoryImages = [
    "assets/images/historyc.png", // تأكدي من مسح حرف الـ c الزائد هنا
    "assets/images/technology.png",
    "assets/images/fiction.png",
    "assets/images/science.png",
    "assets/images/self_development.png",
    "assets/images/children.png",
  ];

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    return CarouselSlider.builder(
      carouselController: controller,
      itemCount: categoryImages.length,
      itemBuilder: (context, index, realIndex) {
        // توحيد الحجم باستخدام SizedBox
        return Center(
          child: SizedBox(
            width: isMobile?120.w:140.w,  // عرض ثابت وموحد لكل الكروت
            height: isMobile?120.h:140.h, // اجعلي الطول يساوي العرض لضمان شكل مربع تماماً
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.r), // لمطابقة انحناء الصورة الأصلية
              child: Padding(
                padding:  EdgeInsets.all(isMobile?2:8.0),
                child: Image.asset(
                  categoryImages[index],
                  fit: BoxFit.fill, // يضمن تمدد الصورة لتملأ المساحة الموحدة بالكامل
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.broken_image),
                ),
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        // اجعلي الارتفاع هنا أكبر قليلاً من ارتفاع الـ SizedBox لتجنب القص
        height: isMobile ? 130.h : 150.h, 
        viewportFraction: isMobile ? 0.35 : 0.16,
        enableInfiniteScroll: false,
        padEnds: false,
        disableCenter: true,
      ),
    );
  }
}