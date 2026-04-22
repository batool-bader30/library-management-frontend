import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_management_web_front/core/utils/navigator_utils.dart';
import 'package:library_management_web_front/views/widgets/BookCard.dart';
import 'package:provider/provider.dart';

import '../../../controllers/book_controller.dart';
import '../../../core/utils/responsive.dart';

class BookCarouselSlider extends StatefulWidget {
  final CarouselSliderController controller;
  final bool? isNew;

  const BookCarouselSlider({super.key, required this.controller, this.isNew});

  @override
  State<BookCarouselSlider> createState() => _BookCarouselSliderState();
}

class _BookCarouselSliderState extends State<BookCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    final bookController = context.watch<BookController>();
    bool isMobile = Responsive.isMobile(context);

    return CarouselSlider.builder(
      carouselController: widget.controller,
      itemCount: bookController.books.length,
      itemBuilder: (context, index, realIndex) {
        final currentBook = bookController.books[index];
        return GestureDetector(
          onTap: () {
            NavigatorUtils.navigateToBookDetailsScreen(context, currentBook.id);
          },
          child: BookCard(book: currentBook, isNew: widget.isNew ?? false),
        );
      },
      options: CarouselOptions(
        height: isMobile ? 220.h : 250.h,
        viewportFraction: isMobile ? 0.35 : 0.16,
        enableInfiniteScroll: false,
        initialPage: 0,
        padEnds: false,
        scrollDirection: Axis.horizontal,
        disableCenter: true,
      ),
    );
  }
}
