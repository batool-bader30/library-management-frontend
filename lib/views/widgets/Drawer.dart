import 'package:flutter/material.dart';
import 'package:library_management_web_front/core/constants/assets.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/core/utils/navigator_utils.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    // استخدمنا Drawer بدل Container
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 216, 190, 163),
      child: Container(
        // استخدمنا الـ Container جوا الـ Drawer عشان نتحكم بالـ Padding والـ Alpha
        color: AppColors.lightbackground.withAlpha(100),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // اللوجو
            const Image(
              image: AssetImage("assets/images/logodark.png"),
              width: 180,
              height: 60,
              color: Color.fromRGBO(78, 41, 22, 1),
            ),

            const SizedBox(height: 25),

            // العناصر
            _menuItem(
              Assets.home,
              "Home",
              isSelected: true,
              onTap: () {
                NavigatorUtils.navigateToHomeScreen(context);
              },
            ),
            _menuItem(
              Assets.mycollection,
              "My collection",
              onTap: () {
                // Navigator.pushNamed(context, '/my_collection');
              },
            ),
            _menuItem(
              Assets.history,
              "Borrowing History",
              onTap: () =>
                  NavigatorUtils.navigateToBorrowingHistoryScreen(context),
            ),
            _menuItem(
              Assets.aboutbg,
              "About Us",
              onTap: () => NavigatorUtils.navigateToAboutUsScreen(context),
            ),

            _menuItem(
              Assets.feedback,
              "Feedback",
              onTap: () => NavigatorUtils.navigateToFeedbackScreen(context),
            ),

            const Spacer(),
            const Divider(color: Colors.white24),

            // تسجيل الخروج
            _menuItem(
              Assets.logout,
              "LOG OUT",
              onTap: () {
                authController.logout();
                NavigatorUtils.navigateToLogInScreen(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    String imagePath,
    String title, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: ImageIcon(
        AssetImage(imagePath),
        size: isSelected ? 35 : 30,
        color: isSelected
            ? const Color.fromARGB(255, 67, 35, 19)
            : AppColors.lighttext,
      ),
      title: Text(
        title,
        style: GoogleFonts.inriaSerif(
          color: isSelected
              ? const Color.fromARGB(255, 56, 29, 16)
              : AppColors.lighttext,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ), // جمالية أكثر عند الضغط
      selected: isSelected,
    );
  }
}
