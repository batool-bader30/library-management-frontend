import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/data/models/responses/BorrwingDetailsModel.dart';
import 'package:library_management_web_front/data/models/responses/user.dart';
import 'package:library_management_web_front/views/screens/admin/adminSideMenu.dart';
import 'package:provider/provider.dart';
import '../../../controllers/Review_controller.dart';
import '../../../controllers/borrowing_controller.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/colors.dart';

class UserProfilePage extends StatefulWidget {
  final UserInfo user;
  const UserProfilePage({super.key, required this.user});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            // Sidebar
            const Adminsidemenu(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: userinfo(widget.user, context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget userinfo(UserInfo user, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 30),
      Center(
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color.fromARGB(255, 43, 32, 0),
              child: Icon(
                Icons.person,
                size: 50,
                color: AppColors.lightbackground,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user.userName ?? "",
              style: GoogleFonts.inriaSerif(
                color: AppColors.darktext,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Email:${user.email}",
                  style: TextStyle(color: AppColors.darktext, fontSize: 15),
                ),
                SizedBox(width: 20),
                Text(
                  "Phone Number:${user.phoneNumber}",
                  style: TextStyle(color: AppColors.darktext, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 40),
      Expanded(
        child: Row(
          children: [
            // Borrowing History
            Expanded(flex: 3, child:BorrowingHistoryWidget(userId: user.id ?? "")),
            // Vertical Divider
            const VerticalDivider(color: Colors.grey, thickness: 1, width: 40),
            // Reviews
             Expanded(flex: 2, child: ReviewsWidget(userId: user.id??" ",)),
          ],
        ),
      ),
    ],
  );
}

class BorrowingHistoryWidget extends StatefulWidget {
  final String userId;
  const BorrowingHistoryWidget({super.key, required this.userId});

  @override
  State<BorrowingHistoryWidget> createState() => _BorrowingHistoryWidgetState();
}

class _BorrowingHistoryWidgetState extends State<BorrowingHistoryWidget> {
  
  @override
  void initState() {
    super.initState();
    // جلب البيانات مرة واحدة فقط عند بدء تشغيل الـ Widget
    Future.microtask(() =>
      Provider.of<BorrowingController>(context, listen: false)
          .getBorrowDetailsByUserId(widget.userId)
    );
  }

  @override
  Widget build(BuildContext context) {
    // تفعيل الـ Listening ليتم تحديث الجدول فور وصول البيانات
    final borrowController = Provider.of<BorrowingController>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Borrowing History',
          style: TextStyle(
            color: AppColors.darktext,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        
        // التحقق مما إذا كانت البيانات قيد التحميل أو القائمة فارغة
        borrowController.borrowing.isEmpty 
          ? const Center(child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: AppColors.darktext),
            ))
          : Table(
              columnWidths: const {
                0: FlexColumnWidth(3), // عرض أكبر لعمود معلومات الكتاب
                1: FlexColumnWidth(2), // عرض متوسط للتاريخ
                2: FlexColumnWidth(1), // عرض أصغر للحالة
              },
              children: [
                // 1. صف العناوين (الثابت)
                _buildHeaderRow(),
                // 2. هنا السحر: تكرار الصفوف بناءً على البيانات
                ...borrowController.borrowing.map((borrowItem) {
                  return _buildBorrowingRow(borrowItem);
                }).toList(),
              ],
            ),
      ],
    );
  }

  // دالة لإنشاء صف العناوين
  TableRow _buildHeaderRow() {
    return TableRow(
      children: [
        _buildCell(Text('Book information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), isHeader: true),
        _buildCell(Text('Borrowed Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), isHeader: true),
        _buildCell(Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), isHeader: true),
      ],
    );
  }

  // دالة لإنشاء صف بيانات واحد
  TableRow _buildBorrowingRow(BorrwingDetailsModel borrow) {
    return TableRow(
      children: [
        // الخلية الأولى: الصورة والعنوان
        _buildCell(
          Row(
            children: [
              // عرض الصورة مع التعامل مع الأخطاء
              Image.network(
                (borrow.book?.imageUrl != null && borrow.book!.imageUrl!.startsWith('http'))
                    ? borrow.book!.imageUrl!
                    : '${ApiClient.storageUrl}${borrow.book?.imageUrl ?? ""}',
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 30),
                height: 40,
                width: 30,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              // استخدام Expanded لحماية النص من التجاوز
              Expanded(
                child: Text(
                  borrow.book?.title ?? "No Title", 
                  style: const TextStyle(fontSize: 12, color: AppColors.darktext)
                ),
              ),
            ],
          ),
        ),
        // الخلية الثانية: التاريخ
        _buildCell(
          Text(
            borrow.borrowDate?.split('T')[0] ?? "", // يأخذ الجزء الأول قبل المسافة
            style: const TextStyle(fontSize: 12),
          ),
        ),
        // الخلية الثالثة: الحالة مع تحديد اللون
        _buildCell(
          Text(
            borrow.status?.toString() ?? "",
            style: TextStyle(
              fontSize: 12, 
              fontWeight: FontWeight.bold,
              color: borrow.status == "Returned" ? Colors.green : Colors.red,
            ),
          )
        ),
      ],
    );
  }

  // دالة مساعدة مركزية لإضافة تنسيق المسافات والخطوط الفاصلة لكل خلية
  Widget _buildCell(Widget child, {bool isHeader = false}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        // مسافة داخلية (Padding) فوق وتحت النص لإعطاء مساحة جمالية
        padding: EdgeInsets.symmetric(vertical: isHeader ? 10.0 : 10.0),
        decoration: BoxDecoration(
          // إضافة حدود سفلية فقط لتعمل كخط فاصل خفيف
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2), // لون خط خفيف جداً
              width: 0.2, // عرض الخط
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
class ReviewsWidget extends StatefulWidget {
  final String userId;
  const ReviewsWidget({super.key, required this.userId});

  @override
  State<ReviewsWidget> createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {
  @override
  void initState() {
    super.initState();
    // جلب المراجعات الخاصة بالمستخدم عند بدء تشغيل الـ Widget
    Future.microtask(() =>
        Provider.of<ReviewController>(context, listen: false)
            .fetchUserReviews(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    final reviewController = Provider.of<ReviewController>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(
            color: AppColors.darktext,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        
        // التحقق من حالة التحميل أو القائمة الفارغة
         reviewController.userReviews.isEmpty
                ? const Text("No reviews yet.", style: TextStyle(fontSize: 12))
                : Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1), // عمود صورة الكتاب
                      1: FlexColumnWidth(2), // عمود نص المراجعة
                      2: FlexColumnWidth(1), // عمود التاريخ
                    },
                    children: [
                      // صف العناوين
                      _buildHeaderRow(),
                      // تحويل قائمة المراجعات من الكنترولر إلى صفوف في الجدول
                      ...reviewController.userReviews.map((review) => _buildReviewRow(review)).toList(),
                    ],
                  ),
      ],
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      children: [
        _buildCell(const Text('Book', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), isHeader: true),
        _buildCell(const Text('Review', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), isHeader: true),
        _buildCell(const Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), isHeader: true),
      ],
    );
  }

  TableRow _buildReviewRow(dynamic review) {
    // افترضنا هنا شكل البيانات بناءً على الـ JSON المتوقع من السيرفر
    return TableRow(
      children: [
        // عمود الصورة
        _buildCell(
          Image.network(
            // التأكد من مسار الصورة (يُفضل استخدام نفس منطق الـ ApiClient.storageUrl)
            review.book?.imageUrl ?? "", 
            height: 40,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 30),
          ),
        ),
        // عمود نص المراجعة (الكومنت)
        _buildCell(
          Text(
            review.comment ?? "No comment",
            style: const TextStyle(color: AppColors.darktext, fontSize: 12),
          ),
        ),
        // عمود التاريخ (قص الوقت)
        _buildCell(
          Text(
            review.createdAt?.toString().split('T')[0] ?? "", // تقسيم عند T أو مسافة حسب الباك أند
            style: const TextStyle(color: AppColors.darktext, fontSize: 12),
          ),
        ),
      ],
    );
  }

  // نفس دالة التنسيق المستخدمة في الـ Borrowing لإبقاء الشكل موحداً
  Widget _buildCell(Widget child, {bool isHeader = false}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isHeader ? 8.0 : 12.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 0.8,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}