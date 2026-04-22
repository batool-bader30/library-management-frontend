import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // استيراد الباقة
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/core/utils/navigator_utils.dart';
import 'package:library_management_web_front/views/screens/Home/sections.dart';
import 'package:library_management_web_front/views/screens/Home/AuthorCarouselSlider.dart';
import 'package:library_management_web_front/views/screens/Home/BookCarouselSlider.dart';
import 'package:library_management_web_front/views/widgets/SidebarMenu.dart';
import 'package:provider/provider.dart';

import '../../widgets/Drawer.dart';
import '/../controllers/author_controller.dart';
import '/../controllers/book_controller.dart';
import '/../core/utils/responsive.dart';
import 'CategoryCarouselSlider.dart';
import '../../widgets/CustomSearch.dart';
import '../../widgets/QuoteSection.dart';
import '../../widgets/SmartAssistantWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookController = Provider.of<BookController>(
        context,
        listen: false,
      );
      final authController = Provider.of<AuthorController>(
        context,
        listen: false,
      );

      bookController.getAllBooks(); // جلب الكتب
      authController.gettllauthor(); // جلب بيانات المؤلفين (أو الـ Auth)
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searshcontroller = TextEditingController();
    bool isMobile = Responsive.isMobile(context);
    final CarouselSliderController controller1 = CarouselSliderController();
    final CarouselSliderController controller2 = CarouselSliderController();
    final CarouselSliderController controller3 = CarouselSliderController();
    final CarouselSliderController controller4 = CarouselSliderController();

    return Scaffold(
      backgroundColor: AppColors.darkbackground,
      drawer: isMobile ? const AppDrawer() : null,
      appBar: isMobile
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(
                color: const Color(0xFFEAD7BB),
                size: 24.sp,
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile) const SidebarMenu(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 10.w : 70.w), // مسافات متجاوبة
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar & Profile Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Customsearch(controller: searshcontroller),
                        ),
                        SizedBox(width: 15.w),
                         GestureDetector(
                          onTap: ()=>NavigatorUtils.navigateToProfileScreen(context),
                           child: CircleAvatar(
                            radius: isMobile? 20:25,
                            backgroundColor: Colors.white10,
                            child:const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                                                   ),
                         ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Sections(
                    controller: controller1,
                    title: "Popular Books",
                    carouselSlider: BookCarouselSlider(controller: controller1),
                  ),
                  SizedBox(height: 10.h),

                  Sections(
                    controller: controller2,
                    title: "New Books",
                    carouselSlider: BookCarouselSlider(
                      controller: controller2,
                      isNew: true,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Sections(
                    controller: controller3,
                    title: "Authors",
                    carouselSlider: AuthorCarouselSlider(
                      controller: controller3,
                    ),
                  ),
                  Sections(
                    controller: controller4,
                    title: "Categories",
                    carouselSlider: CategoryCarouselSlider(),
                  ),
                  SizedBox(height: isMobile ? 30.h : 80.h),

                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const QuoteSection(),
                      Positioned(
                        right: 10,
                        bottom: -40.h, // تقليل القيمة قليلاً
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque, // يضمن التقاط اللمس
                          child: const SmartAssistantWidget(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
