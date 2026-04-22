import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/data/models/responses/authormodel.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/navigator_utils.dart';
import 'BookCard.dart';

class Authorbooks extends StatefulWidget {
  final AuthorModel author;
  const Authorbooks({super.key, required this.author});

  @override
  State<Authorbooks> createState() => _AuthorbooksState();
}

class _AuthorbooksState extends State<Authorbooks> {
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.sizeOf(context).width < 800;

    return Column(
      children: [
        // عنوان قسم الكتب
        Align(
          alignment: isMobile ? Alignment.center : Alignment.centerLeft,
          child: Text(
            "${widget.author.name}s Books",
            style: GoogleFonts.inriaSerif(
              fontSize: isMobile ? 22.sp : 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.darktext,
            ),
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 250.h,
          child:
              (widget.author.books != null && widget.author.books!.isNotEmpty)
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.author.books!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: GestureDetector(
                        onTap: () {
                          NavigatorUtils.navigateToBookDetailsScreen(
                            context,
                            widget.author.books![index].id,
                          );
                        },
                        child: BookCard(book: widget.author.books![index]),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No books registered.",
                    style: GoogleFonts.inriaSerif(color: AppColors.darktext),
                  ),
                ),
        ),
      ],
    );
  }
}
