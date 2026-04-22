import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/controllers/borrowing_controller.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/views/widgets/Drawer.dart';
import 'package:library_management_web_front/views/widgets/SidebarMenu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/auth_controller.dart';
import '../../core/utils/responsive.dart';
import '../widgets/historycard.dart';

class BorrowingHistoryScreen extends StatefulWidget {
  const BorrowingHistoryScreen({super.key});

  @override
  State<BorrowingHistoryScreen> createState() => _BorrowingHistoryScreenState();
}

class _BorrowingHistoryScreenState extends State<BorrowingHistoryScreen> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final borrowController = Provider.of<BorrowingController>(context, listen: false);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken');

    if (token != null) {
      final String? id = authController.getUserIdFromToken(token);
      if (id != null) {
        if (mounted) {
          setState(() {
            currentUserId = id;
          });
        }
        await borrowController.getBorrowDetailsByUserId(id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // تحديد ما إذا كان الجهاز موبايل أم لا
    bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.darkbackground,
      // يظهر الـ Drawer فقط في الموبايل
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
          // يظهر الـ Sidebar فقط في الويب/التابلت
          if (!isMobile) const SidebarMenu(selectedTitl: "Borrowing History"),
          Expanded(
            child: Consumer<BorrowingController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // مسافة علوية متغيرة
                      SizedBox(height: isMobile ? 20.h : 40.h),
                      
                      Padding(
                        // بادينج العنوان (70 للويب و 20 للموبايل)
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20.w : 70.w,
                        ),
                        child: Text(
                          "Borrowing History",
                          style: GoogleFonts.inriaSerif(
                            fontSize: isMobile ? 26.sp : 32.sp,
                            color: AppColors.lightbackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: isMobile ? 20.h : 40.h),

                      Padding(
                        // بادينج القائمة (40 للويب و 15 للموبايل)
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 15.w : 40.w,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.borrowing.length,
                          itemBuilder: (context, index) {
                            final item = controller.borrowing[index];
                            return Padding(
                              // المسافة الجانبية للكروت (80 للويب و 0 للموبايل)
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 0 : 80.w,
                                vertical: 10.h,
                              ),
                              child: Historycard(
                                item: item,
                                userId: currentUserId ?? "",
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 50.h), // مساحة إضافية في الأسفل
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}