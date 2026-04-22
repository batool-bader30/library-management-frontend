import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_management_web_front/views/widgets/AuthorCircle.dart';
import 'package:provider/provider.dart';
import '../../../controllers/author_controller.dart';
import '../../../core/utils/navigator_utils.dart';
import '../../../core/utils/responsive.dart';

class AuthorCarouselSlider extends StatefulWidget {
  final CarouselSliderController controller;

  const AuthorCarouselSlider({super.key, required this.controller});

  @override
  State<AuthorCarouselSlider> createState() => _AuthorCarouselSliderState();
}

class _AuthorCarouselSliderState extends State<AuthorCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    final authorController = context.watch<AuthorController>();
    bool isMobile = Responsive.isMobile(context);

    return CarouselSlider.builder(
      carouselController: widget.controller,
      itemCount: authorController.authors.length,
      itemBuilder: (context, index, realIndex) {
        final currentauthors = authorController.authors[index];
        return GestureDetector(
          onTap: () {
              NavigatorUtils.navigateToAuthorDetailsScreen(
              context,
              currentauthors.id,
            );
          },
          child: AuthorCircle(author: currentauthors),
        );
      },
      options: CarouselOptions(
        height: isMobile ? 190.h : 200.h,
        viewportFraction: isMobile ? 0.3 : 0.16,
        enableInfiniteScroll: false,
        initialPage: 0,
        padEnds: false,
        scrollDirection: Axis.horizontal,
        disableCenter: true,
      ),
    );
  }
}
