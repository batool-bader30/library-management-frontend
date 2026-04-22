import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/core/utils/navigator_utils.dart';
import 'package:library_management_web_front/data/models/responses/user.dart';
import 'package:library_management_web_front/views/screens/admin/adminSideMenu.dart';
import 'package:library_management_web_front/views/widgets/CustomSearch.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_controller.dart';

class Usermanagementscreen extends StatefulWidget {
  const Usermanagementscreen({super.key});

  @override
  State<Usermanagementscreen> createState() => _UsermanagementscreenState();
}

class _UsermanagementscreenState extends State<Usermanagementscreen> {
  @override
  void initState() {
    super.initState();
    // نستخدم الـ addPostFrameCallback عشان نضمن إن الـ Build خلص
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightbackground,
      body: Consumer<AuthController>(
        builder: (context, controller, child) {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/admin.bg.png"),
                fit: BoxFit.cover, // تم تغيير fill لـ cover لجمالية أفضل
              ),
            ),
            child: Row(
              children: [
                const Adminsidemenu(selectedTitl:  "Users Management"), // المنيو الجانبي
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Users Management",
                          style: GoogleFonts.inriaSerif(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darktext,
                          ),
                        ),
                        const SizedBox(height: 30),

                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 500.0),
                                child: Customsearch(),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 60,
                                    right: 260.0,
                                    top: 20,
                                  ),
                                  child: _buildUsersList(controller),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUsersList(AuthController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "all Userss:",
          style: GoogleFonts.inriaSerif(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),

        Expanded(
          child: ListView.builder(
            itemCount: c.users.length,
            itemBuilder: (context, index) => _bookItemCard(c.users[index], c),
          ),
        ),
      ],
    );
  }

  Widget _bookItemCard(UserInfo c, AuthController controller) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          leading: const CircleAvatar(
            backgroundColor: AppColors.darkbackground,
            child: const Icon(Icons.person, color: Colors.white, size: 30),
          ),

          title: Text(
            c.userName ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inriaSerif(
              color: AppColors.darktext,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Image.asset(
                  "assets/images/view.png",
                  width: 40, // بديل لـ size في ImageIcon
                  height: 40,
                  fit: BoxFit.contain,
                ),
                onPressed: () {
                  NavigatorUtils.navigateToUserInfoScreen(context,c);
                },
              ),
              IconButton(
                icon: Image.asset(
                  "assets/images/deletee.png",
                  width: 40, // بديل لـ size في ImageIcon
                  height: 40,
                  fit: BoxFit.contain,
                ),
                onPressed: () {
                  // controller.deleteAuthor(c.id ?? 1);
                },
              ),
              SizedBox(width: 20),
            ],
          ),
        ),
        Divider(
          color: const Color.fromARGB(255, 35, 18, 1).withOpacity(0.1),
          thickness: 1,
        ),
      ],
    );
  }
}
