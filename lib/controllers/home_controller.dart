import 'package:flutter/material.dart';

class HomeController {
  final ScrollController scrollController = ScrollController();

  // Keys للوصول للسكاشن
  final GlobalKey heroKey = GlobalKey();
  final GlobalKey welcomeKey = GlobalKey();
  final GlobalKey booksKey = GlobalKey();
  final GlobalKey categoriesKey = GlobalKey();
  final GlobalKey reviewsKey = GlobalKey();
  final GlobalKey footerKey = GlobalKey();

  void scrollTo(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  void dispose() {
    scrollController.dispose();
  }
}