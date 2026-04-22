import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../controllers/Review_controller.dart';
import '../../../controllers/book_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/responsive.dart';

import '../../widgets/HomeDrawer.dart';
import 'HeroSection.dart';
import '../../widgets/navbar.dart';
import 'welcome_section.dart';
import 'books_section.dart';
import 'categories_section.dart';
import 'reviews_section.dart';
import '../../widgets/footer_section.dart';

class ReadHubHomePage extends StatefulWidget {
  const ReadHubHomePage({super.key});

  @override
  State<ReadHubHomePage> createState() => _ReadHubHomePageState();
}

class _ReadHubHomePageState extends State<ReadHubHomePage> {
  final HomeController _homeController = HomeController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookController>().getAllBooks();
      context.read<ReviewController>().getallreview();
    });
  }

  @override
  void dispose() {
    _homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkbackground,

      // القائمة الجانبية للموبايل
      drawer: Responsive.isMobile(context)
          ? MobileDrawer(controller: _homeController)
          : null,

      body: SingleChildScrollView(
        controller: _homeController.scrollController,
        child: Column(
          children: [
             CustomNavBar(controller: _homeController),
            // السيكشن الأول: الهيرو (يحتوي على الناف بار)
            HeroSection(controller: _homeController),
            SizedBox(height: 100.h),

            // بقية السكاشن مع تمرير المفاتيح (Keys) لضمان عمل الـ Scroll
            WelcomeSection(key: _homeController.welcomeKey),
            SizedBox(height: 50.h),

            BooksSection(key: _homeController.booksKey),
            SizedBox(height: 60.h),

            CategoriesSection(key: _homeController.categoriesKey),
            SizedBox(height: 35.h),

            ReviewsSection(key: _homeController.reviewsKey),

            FooterSection(key: _homeController.footerKey,controller: _homeController),
          ],
        ),
      ),
    );
  }
}
