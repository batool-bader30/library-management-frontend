import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/controllers/borrowing_controller.dart';
import 'package:library_management_web_front/data/models/responses/BorrwingDetailsModel.dart';
import 'package:library_management_web_front/views/widgets/customButton.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';

class Historycard extends StatelessWidget {
  final BorrwingDetailsModel item;
  final String userId;

  const Historycard({super.key, required this.item, required this.userId});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BorrowingController>(context, listen: false);
    // فحص إذا كان العرض أصغر من 600 بكسل (جوال)
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. صورة الكتاب (حجم متكيف)
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              item.book?.imageUrl ?? "",
              width: isMobile ? 90.w : 150.w,
              height: isMobile ? 130.h : 200.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: isMobile ? 90.w : 150.w,
                height: isMobile ? 130.h : 200.h,
                color: Colors.white10,
                child: Icon(Icons.book, size: 40.sp, color: Colors.white),
              ),
            ),
          ),

          SizedBox(width: isMobile ? 10.w : 20.w),

          // 2. حاوية المعلومات والحالة (بجانب بعضهما دائماً)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // المربع الأول: Borrow & Return
                Expanded(
                  child: _buildStyledContainer(
                    isMobile: isMobile,
                    title: "Borrow & Return",
                    children: [
                      SizedBox(height: 10.h),

                      _infoText(
                        isMobile: isMobile,
                        label: isMobile ? "B: " : "Borrowed: ",
                        value: item.borrowDate?.split('T')[0] ?? "N/A",
                      ),
                      SizedBox(height: isMobile ? 8.h : 15.h),
                      _infoText(
                        isMobile: isMobile,
                        label: isMobile ? "R: " : "Return: ",
                        value: item.returnDate?.split('T')[0] ?? "N/A",
                      ),
                      SizedBox(height: isMobile ? 8.h : 15.h),

                      _infoText(
                        isMobile: isMobile,
                        label: isMobile ? "T: " : "Time Left: ",
                        value: controller.calculateTimeLeft(item.returnDate),
                      ),
                      SizedBox(height:isMobile?18.h: 30.h),
                    ],
                  ),
                ),

                SizedBox(width: isMobile ? 8.w : 20.w),

                // المربع الثاني: Status & Actions
                Expanded(
                  child: _buildStyledContainer(
                    isMobile: isMobile,
                    title: "Status",
                    children: [
                      Text(
                        "${item.status}",
                        style: GoogleFonts.inriaSerif(
                          color: AppColors.lightbackground,
                          fontSize: isMobile ? 11.sp : 14.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: isMobile ? 10.h : 20.h),
                      CustomButton(
                        text: isMobile ? "Extend" : "Extend Duration",
                        onPressed: () => _handleExtend(context, controller),
                        size: isMobile ? 10.sp : 13.sp,
                        height: isMobile ? 30.h : 40.h,
                        backgroundColor: AppColors.lightbackground,
                        textColor: AppColors.darktext,
                      ),
                      SizedBox(height: 8.h),
                      CustomButton(
                        text: isMobile ? "Return" : "Return Book",
                        onPressed: () => _handleReturn(controller),
                        size: isMobile ? 10.sp : 13.sp,
                        height: isMobile ? 30.h : 40.h,
                        backgroundColor: AppColors.lightbackground,
                        textColor: AppColors.darktext,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ميثود بناء الحاوية المزخرفة (Bordered Box)
  Widget _buildStyledContainer({
    required bool isMobile,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 8.r : 15.r),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white.withOpacity(0.02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inriaSerif(
              color: AppColors.lightbackground,
              fontSize: isMobile ? 15.sp : 23.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: isMobile ? 8.h : 15.h),
          ...children,
        ],
      ),
    );
  }

  // ميثود بناء نصوص المعلومات
  Widget _infoText({
    required bool isMobile,
    required String label,
    required String value,
  }) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: GoogleFonts.inriaSerif(
          color: AppColors.lightbackground,
          fontSize: isMobile ? 13.sp : 16.sp,
        ),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  // منطق الإرجاع
  void _handleReturn(BorrowingController controller) {
    controller.updateBorrowing(
      id: item.id ?? 0,
      status: 1,
      returnDate: DateTime.now(),
      userId: userId,
    );
  }

  // منطق التمديد
  void _handleExtend(
    BuildContext context,
    BorrowingController controller,
  ) async {
    DateTime start = item.returnDate != null
        ? DateTime.parse(item.returnDate!)
        : DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: start.add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.updateBorrowing(
        id: item.id ?? 0,
        userId: userId,
        status: 0,
        returnDate: picked,
      );
    }
  }
}
