import 'package:flutter/material.dart';
import 'package:library_management_web_front/core/constants/assets.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/core/utils/navigator_utils.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/auth_controller.dart';

class SidebarMenu extends StatefulWidget {
  final String? selectedTitl;
  const SidebarMenu({super.key, this.selectedTitl});

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  @override
  Widget build(BuildContext context) {
    String selectedTitle = widget.selectedTitl ?? "Home";

    final authController = Provider.of<AuthController>(context);

    return Container(
      decoration:  BoxDecoration(
        borderRadius:const BorderRadius.only(topRight:Radius.circular(35) ),
              color: AppColors.lightbackground.withAlpha(100),

      ),
      width: 370,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Image(
            image: AssetImage("assets/images/logodark.png"),
            width: 180,
            height: 60,
            color: Color.fromRGBO(78, 41, 22, 1),
          ),
          const SizedBox(height: 25),

          // تمرير الحالة الحالية لكل عنصر
          _menuItem(
            Assets.home,
            "Home",
            isSelected: selectedTitle == "Home",
            onTap: () {
              setState(() => selectedTitle = "Home");
              NavigatorUtils.navigateToHomeScreen(context);
            },
          ),

          _menuItem(
            Assets.mycollection,
            "My collection",
            isSelected: selectedTitle == "My collection",
            onTap: () {
              setState(() => selectedTitle = "My collection");
              // أضف التنقل هنا إذا وجد
            },
          ),

          _menuItem(
            Assets.history,
            "Borrowing History",
            isSelected: selectedTitle == "Borrowing History",
            onTap: () {
              setState(() => selectedTitle = "Borrowing History");
              NavigatorUtils.navigateToBorrowingHistoryScreen(context);
            },
          ),

          _menuItem(
            Assets.feedback,
            "Feedback",
            isSelected: selectedTitle == "Feedback",
            onTap: () {
              setState(() => selectedTitle = "Feedback");
              NavigatorUtils.navigateToFeedbackScreen(context);
            },
          ),

          const Spacer(),
          const Divider(color: Colors.white24),

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
      // تأكد من تنسيق الخلفية عند الاختيار
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      selected: isSelected,
      selectedTileColor: Colors.white.withOpacity(
        0.2,
      ), // تغيير اللون ليكون واضحاً
    );
  }
}
