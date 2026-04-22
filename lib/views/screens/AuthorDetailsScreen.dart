import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/controllers/author_controller.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/data/models/responses/authormodel.dart';
import 'package:library_management_web_front/views/widgets/authorbooks.dart';
import 'package:provider/provider.dart';

class Authordetailsscreen extends StatefulWidget {
  final int id;
  const Authordetailsscreen({super.key, required this.id});

  @override
  State<Authordetailsscreen> createState() => _AuthorDetailsScreenState();
}

class _AuthorDetailsScreenState extends State<Authordetailsscreen> {
  @override
  Widget build(BuildContext context) {
    // تحديد ما إذا كان الجهاز موبايل بناءً على عرض الشاشة
    bool isMobile = MediaQuery.sizeOf(context).width < 800;

    return Scaffold(
      body: Consumer<AuthorController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF633A24)),
            );
          }

          final author = controller.authors.firstWhere(
            (a) => a.id == widget.id,
            orElse: () => AuthorModel(id: -1, name: "Unknown"),
          );

          if (author.id == -1) {
            return const Center(child: Text("Author not found"));
          }

          return Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/author.d.bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                // تصغير المسافات الجانبية في الموبايل
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20.w : 100.w,
                  vertical: 20.h,
                ),
                child: Column(
                  children: [
                    // تبديل بين Row و Column بناءً على نوع الجهاز
                    isMobile
                        ? Column(
                            children: [
                              _buildauthorCoverSection(author, isMobile),
                              SizedBox(height: 20.h),
                              _buildauthorInfoSection(author, isMobile),
                              SizedBox(height: 20.h),
                              Authorbooks(author: author),
                            ],
                          )
                        : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100.0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      _buildauthorInfoSection(author, isMobile),
                                  
                                      SizedBox(height: 40.h),
                                      Authorbooks(author: author),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 50.w),
                                _buildauthorCoverSection(author, isMobile),
                              ],
                            ),
                        ),

                    

                    // قائمة الكتب الأفقية
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildauthorInfoSection(AuthorModel author, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (!isMobile) SizedBox(height: 80.h),
        Text(
          author.name ?? "No name",
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.inriaSerif(
            fontSize: isMobile ? 32.sp : 45.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darktext,
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          author.bio ?? "No bio available.",
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.inriaSerif(
            fontSize: isMobile ? 16.sp : 18.sp,
            color: AppColors.darktext,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildauthorCoverSection(AuthorModel author, bool isMobile) {
    return Column(
      children: [
        if (!isMobile) SizedBox(height: 100.h),
        Container(
          width: isMobile ? 250.w : 320.w,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.darktext, width: 2),
            borderRadius: BorderRadius.circular(15.r),
            color: Colors.white.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: author.imageUrl != null
                ? Image.network(
                    author.imageUrl!,
                    height: isMobile ? 300.h : 400.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.person,
                      size: 100.r,
                      color: AppColors.darktext,
                    ),
                  )
                : Placeholder(fallbackHeight: isMobile ? 300.h : 400.h),
          ),
        ),
      ],
    );
  }
}
