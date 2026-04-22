import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:library_management_web_front/controllers/auth_controller.dart';
import 'package:library_management_web_front/controllers/borrowing_controller.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/core/utils/navigator_utils.dart';
import 'package:library_management_web_front/core/utils/responsive.dart';
import 'package:library_management_web_front/data/models/responses/bookdetails.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/Review_controller.dart';
import '../../controllers/book_controller.dart';
import '../../data/models/requests/borrowrequest.dart';

class BookDetailsScreen extends StatefulWidget {
  final int id;
  const BookDetailsScreen({super.key, required this.id});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookController>(
        context,
        listen: false,
      ).getBookDetailsById(widget.id);
    });
  }

  @override
  void dispose() {
    Provider.of<BookController>(
      context,
      listen: false,
    ).borrowDateController.clear();
    Provider.of<BookController>(
      context,
      listen: false,
    ).returnDateController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تحديد ما إذا كان الجهاز موبايل بناءً على عرض الشاشة
    bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      // استخدمنا SingleChildScrollView لضمان عدم حدوث Overflow في الموبايل
      body: Consumer<BookController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF633A24)),
            );
          }

          final book = controller.bookDetails;
          if (book == null) return const Center(child: Text("Book not found"));

          return Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/book.d.bg.png"),
                fit: BoxFit.cover, // تم تغيير fill لـ cover لجمالية أفضل
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                // تصغير الـ padding في الموبايل ليعطي مساحة للمحتوى
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20.w : 250.w,
                  vertical: 20.h,
                ),
                child: Column(
                  children: [
                    // استخدام الـ Row للويب والـ Column للموبايل
                    isMobile
                        ? Column(
                            children: [
                              _buildBookCoverSection(book, isMobile),
                              SizedBox(height: 20.h),
                              _buildBookInfoSection(book, isMobile),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBookCoverSection(book, isMobile),
                              SizedBox(width: 50.w),
                              Expanded(
                                child: _buildBookInfoSection(book, isMobile),
                              ),
                            ],
                          ),
                    SizedBox(height: 30.h),
                    _buildBorrowActionSection(book, context, isMobile),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookCoverSection(BookDetailsModel book, bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 300.w,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.darktext, width: 3),
        borderRadius: BorderRadius.circular(15.r),
        color: Colors.white.withOpacity(0.2), // إضافة خلفية شفافة بسيطة
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: book.imageUrl != null
                ? Image.network(
                    book.imageUrl!,
                    height: isMobile ? 250.h : 350.h,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.book, size: 80.r, color: AppColors.darktext),
                  )
                : const Placeholder(),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: book.isAvailable == true ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: book.isAvailable == true
                  ? AppColors.darktext
                  : AppColors.darktext.withAlpha(60),
              foregroundColor: book.isAvailable == true
                  ? AppColors.lightbackground
                  : AppColors.darktext,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              book.isAvailable == true ? "Borrow Now" : "Not Available",
              style: GoogleFonts.inriaSerif(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            "Give a review",
            style: GoogleFonts.inriaSerif(
              color: AppColors.darktext,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookInfoSection(BookDetailsModel book, bool isMobile) {
    double rating = (book.reviews != null && book.reviews!.isNotEmpty)
        ? book.reviews!.fold(0.0, (sum, item) => sum + (item.rating ?? 0)) /
              book.reviews!.length
        : 0.0;

    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (!isMobile) SizedBox(height: 50.h),
        Text(
          book.title ?? "No Title",
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.inriaSerif(
            fontSize: isMobile ? 30.sp : 45.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darktext,
          ),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: () => NavigatorUtils.navigateToAuthorDetailsScreen(
            context,
            book.authorId,
          ),
          child: Text(
            "by ${book.authorName ?? 'Unknown'}",
            style: GoogleFonts.inriaSerif(
              fontSize: isMobile ? 20.sp : 28.sp,
              color: const Color(0xFF633A24),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 15.h),
        // قسم التقييم
        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return Icon(
                  index < rating.round() ? Icons.star : Icons.star_border,
                  color: const Color(0xFFD4AF37),
                  size: 20.sp,
                );
              }),
            ),
            SizedBox(width: 8.w),
            Text(
              "${rating.toStringAsFixed(1)} ",
              style: GoogleFonts.inriaSerif(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
               
                NavigatorUtils.navigateToReviewsScreen(context, book.id);},
                
              
              child: Text(
                "| Reviews: (${book.reviews?.length ?? 0})",
                style: GoogleFonts.inriaSerif(
                  fontSize: 13.sp,
                  color: AppColors.primaryBrown,
                ),
              ),
            ),
            Text(
              "| Borrowing: (${book.borrowings?.length ?? 0})",
              style: GoogleFonts.inriaSerif(
                fontSize: 13.sp,
                color: AppColors.primaryBrown,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Text(
          book.description ?? "No description available.",
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.inriaSerif(
            fontSize: 15.sp,
            color: AppColors.darktext,
            height: 1.4,
          ),
        ),
        SizedBox(height: 30.h),
        // الكروت التعريفية (تتحول لـ Wrap لتنزل تحت بعضها إذا ضاق المكان)
        Wrap(
          spacing: 15.w,
          runSpacing: 15.h,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _buildInfoCard("Publish Date", book.publishDate ?? "N/A"),
            _buildInfoCard("Language", book.language ?? "N/A"),
            _buildInfoCard("Pages", book.pageNumber ?? "N/A"),
            _buildInfoCard(
              "Category",
              (book.categories?.isNotEmpty ?? false)
                  ? book.categories![0]
                  : "General",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return DottedBorder(
      color: AppColors.darkbackground,
      dashPattern: const [6, 3],
      borderType: BorderType.RRect,
      radius: Radius.circular(12.r),
      child: Container(
        width: 110.w, // تصغير العرض قليلاً ليناسب الموبايل
        padding: EdgeInsets.all(8.r),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.inriaSerif(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.inriaSerif(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBorrowActionSection(
    BookDetailsModel book,
    BuildContext context,
    bool isMobile,
  ) {
    final controller = Provider.of<BookController>(context, listen: false);
    final authcontroller = Provider.of<AuthController>(context, listen: false);

    final borrowcontroller = Provider.of<BorrowingController>(
      context,
    ); // شلنا listen: false عشان نراقب isLoading

    return Container(
      padding: EdgeInsets.all(isMobile ? 15.r : 20.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        children: [
          _buildDatePicker(
            context,
            "Borrow Date...",
            controller.borrowDateController,
            () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (picked != null) controller.updateBorrowDate(picked);
            },
            isMobile,
          ),
          SizedBox(width: isMobile ? 0 : 20.w, height: isMobile ? 15.h : 0),
          _buildDatePicker(
            context,
            "Return Date...",
            controller.returnDateController,
            () async {
              DateTime start = controller.borrowDateController.text.isNotEmpty
                  ? DateTime.parse(controller.borrowDateController.text)
                  : DateTime.now();
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: start.add(const Duration(days: 1)),
                firstDate: start,
                lastDate: DateTime(2100),
              );
              if (picked != null) controller.updateReturnDate(picked);
            },
            isMobile,
          ),
          SizedBox(width: isMobile ? 0 : 20.w, height: isMobile ? 20.h : 0),

          // زر الاستعارة مع معالجة الحالات
          ElevatedButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              // 1. جلب التوكن المخزن
              final String? token = prefs.getString('accessToken');

              if (token != null) {
                // 2. استخراج الـ ID من التوكن
                final String? userId = authcontroller.getUserIdFromToken(token);

                if (userId != null) {
                  // التأكد من أن التواريخ ليست فارغة قبل الإرسال
                  if (controller.borrowDateController.text.isEmpty ||
                      controller.returnDateController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select borrow and return dates"),
                      ),
                    );
                    return;
                  }

                  final request = BorrowRequest(
                    bookId: widget.id,
                    userId: userId,
                    borrowDate: controller.borrowDateController.text,
                    returnDate: controller.returnDateController.text,
                  );

                  // 3. إرسال الطلب واستلام النتيجة
                  // ملاحظة: تأكد أن دالة postborrow تعيد true في حال النجاح
                  final bool isSuccess = await borrowcontroller.postborrow(
                    request,
                  );

                  if (context.mounted) {
                    // للتأكد أن الـ Widget ما زال موجوداً
                    if (isSuccess) {
                      // في حال النجاح
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Borrowing successfully!"),
                          backgroundColor: Color.fromARGB(255, 65, 36, 1),
                        ),
                      );
                    } else {
                      // في حال الفشل - نعرض الرسالة القادمة من السيرفر والمخزنة في الـ Controller
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            borrowcontroller.errorMessage.isNotEmpty
                                ? borrowcontroller.errorMessage
                                : "Borrowing failed, please try again",
                          ),
                          backgroundColor: const Color.fromARGB(255, 46, 22, 1),
                        ),
                      );
                    }
                  }
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please login to borrow books")),
                );
              }
              dispose();
              controller.getBookDetailsById(widget.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darktext,
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 20.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: borrowcontroller.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    "Borrow",
                    style: GoogleFonts.inriaSerif(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String hint,
    TextEditingController controller,
    VoidCallback onTap,
    bool isMobile,
  ) {
    return SizedBox(
      width: isMobile ? double.infinity : 250.w,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: AppColors.darktext.withAlpha(30),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          suffixIcon: const Icon(
            Icons.calendar_month,
            color: Color(0xFF633A24),
          ),
        ),
      ),
    );
  }
}
