import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/utils/responsive.dart';
import 'dart:math' as math;

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  late PageController _pageController;
  int _currentPage = 2;

  // قائمة الصور - تأكدي من مطابقة المسارات في pubspec.yaml
  final List<String> categoryImages = [
    "assets/images/historyc.png",
    "assets/images/technology.png",
    "assets/images/fiction.png",
    "assets/images/science.png",
    "assets/images/self_development.png",
    "assets/images/children.png",
  ];

  @override
  void initState() {
    super.initState();
    // تعريف المتحكم في initState لتجنب إعادة إنشائه في build
    _pageController = PageController(
      initialPage: _currentPage,
      keepPage: true,
      viewportFraction: 0.4,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final Size screenSize = MediaQuery.sizeOf(context);

    // تحديث الـ viewportFraction ديناميكياً عند تغيير حجم الشاشة دون هدم المتحكم
    double targetFraction = isMobile ? 0.6 : 0.4;
    if (_pageController.viewportFraction != targetFraction) {
      _pageController = PageController(
        initialPage: _currentPage,
        viewportFraction: targetFraction,
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 400.w),
      width: screenSize.width,
      child: Column(
        children: [
          Text(
            "Categories",
            style: GoogleFonts.inriaSerif(
              color: const Color(0xFFEAD7BB),
              fontSize: isMobile ? 28.sp : 36.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: isMobile ? 280.h : 300.h,
            width: screenSize.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // أزرار التنقل تظهر فقط في الشاشات الكبيرة
                if (!isMobile)
                  _buildNavigationButton(Icons.arrow_back_ios_new, () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }),

                SizedBox(width: isMobile ? 0 : 25.w),

                Expanded(
                  child: SizedBox(
                    height: isMobile ? 250.h : 250.h,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: categoryImages.length,
                      onPageChanged: (value) {
                        setState(() {
                          _currentPage = value;
                        });
                      },
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double value = 0.0;
                            if (_pageController.hasClients &&
                                _pageController.position.haveDimensions) {
                              value =
                                  index.toDouble() -
                                  (_pageController.page ?? 0);
                            } else {
                              value =
                                  index.toDouble() - _currentPage.toDouble();
                            }

                            // حسابات التأثير البصري (Scale, Opacity, Rotation)
                            final double scale = (1 - (value.abs() * 0.2))
                                .clamp(0.8, 1.0);
                            final double opacity = (1 - (value.abs() * 0.4))
                                .clamp(0.5, 1.0);
                            final double rotation = value * (math.pi / 18);

                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001) // تأثير 3D بسيط
                                ..scale(scale)
                                ..rotateY(rotation),
                              child: Opacity(
                                opacity: opacity,
                                child: _buildImageCard(
                                  categoryImages[index],
                                  isMobile,
                                  screenSize,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(width: isMobile ? 0 : 25.w),

                if (!isMobile)
                  _buildNavigationButton(Icons.arrow_forward_ios, () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }),
              ],
            ),
          ),
          SizedBox(height: 50.h),
          // زر View All
          TextButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "view All",
                  style: GoogleFonts.inriaSerif(
                    color: const Color(0xFFEAD7BB),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 10.w),
                Icon(
                  Icons.arrow_right_alt,
                  color: const Color(0xFFEAD7BB),
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // بطاقة الصورة مع الظلال والدوران
  Widget _buildImageCard(String imagePath, bool isMobile, Size screenSize) {
    return Center(
      child: Container(
        width: isMobile ? screenSize.width * 0.45 : 300.w,
        height: isMobile ? screenSize.height * 0.25 : 240.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  // زر التنقل الدائري
  Widget _buildNavigationButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white10,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: const Color(0xFFEAD7BB), size: 24.sp),
        padding: EdgeInsets.all(12.r),
      ),
    );
  }
}
