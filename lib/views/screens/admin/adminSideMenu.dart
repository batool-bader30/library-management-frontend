import 'package:flutter/material.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/core/utils/navigator_utils.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/auth_controller.dart';

class Adminsidemenu extends StatefulWidget {
  final String? selectedTitl;
  const Adminsidemenu({super.key, this.selectedTitl});

  @override
  State<Adminsidemenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<Adminsidemenu> {
  @override
  Widget build(BuildContext context) {
    String selectedTitle = widget.selectedTitl ?? "Overview";

    final authController = Provider.of<AuthController>(context);

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topRight:Radius.circular(35) ),
              color: AppColors.darkbackground,

      ),
      width: 370,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Image(
            image: AssetImage("assets/images/logohight.png"),
            width: 200,
            height: 70,
            color: AppColors.lightbackground,
          ),
          const SizedBox(height: 25),

          // تمرير الحالة الحالية لكل عنصر
          SizedBox(height: 5),

          _menuItem(
            "Overview",
            isSelected: selectedTitle == "Overview",
            onTap: () {
              setState(() => selectedTitle = "Overview");
              NavigatorUtils.navigateToOverviewScreen(context);
            },
          ),
          SizedBox(height: 5),

          _menuItem(
            "Books Management",
            isSelected: selectedTitle == "Books Management",
            onTap: () {
              setState(() => selectedTitle = "Books Management");
              NavigatorUtils.navigateToBookManagementScreen(context);

              // أضف التنقل هنا إذا وجد
            },
          ),
          SizedBox(height: 5),

          _menuItem(
            "Authors Management",
            isSelected: selectedTitle == "Authors Management",
            onTap: () {
              setState(() => selectedTitle = "Authors Management");
              NavigatorUtils.navigateToAuthorManagementScreen(context);
            },
          ),
          SizedBox(height: 5),
          _menuItem(
            "User Management",
            isSelected: selectedTitle == "User Management",
            onTap: () {
              setState(() => selectedTitle = "User Management");
              NavigatorUtils.navigateToUsersManagementScreen(context);
            },
          ),
          SizedBox(height: 5),
          _menuItem(
            "Borrowing Requests",
            isSelected: selectedTitle == "User Management",
            onTap: () {
              setState(() => selectedTitle = "User Management");
              NavigatorUtils.navigateToFeedbackScreen(context);
            },
          ),

          const Spacer(),
          const Divider(color: Color.fromARGB(60, 239, 219, 219)),

          _menuItem(
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
    String title, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.inriaSerif(
          color: isSelected
              ? AppColors.lightbackground
              : const Color.fromARGB(255, 239, 217, 196),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 20,
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
