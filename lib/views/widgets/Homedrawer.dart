import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/home_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';

class MobileDrawer extends StatelessWidget {
  final HomeController controller;
  const MobileDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkbackground,
      child: ListView(
        children: [
          DrawerHeader(child: Image.asset(Assets.logolight)),
          _drawerItem("Home", controller.heroKey, context),
          _drawerItem("About", controller.welcomeKey, context),
          _drawerItem("Books", controller.booksKey, context),
          _drawerItem("Contact", controller.footerKey, context),
        ],
      ),
    );
  }

  Widget _drawerItem(String title, GlobalKey key, BuildContext context) {
    return ListTile(
      title: Text(title, style:  GoogleFonts.inriaSerif(color: AppColors.lightbackground, fontSize: 22)),
      onTap: () {
        Navigator.pop(context);
        controller.scrollTo(key);
      },
    );
  }
}