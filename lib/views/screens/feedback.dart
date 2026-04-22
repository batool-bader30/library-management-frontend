import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/core/utils/responsive.dart'; // افترضنا وجود كلاس الريسبونسيف
import '../widgets/CustomTextField.dart';
import '../widgets/SidebarMenu.dart';
import '../widgets/Drawer.dart'; // إضافة الدراور للموبايل

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendFeedback() {
    String subject = _subjectController.text.trim();
    String message = _messageController.text.trim();

    if (subject.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields!"),
          backgroundColor: Color.fromARGB(255, 56, 34, 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thank you! Your feedback has been received."),
          backgroundColor: Color.fromARGB(255, 48, 30, 1),
        ),
      );
      _subjectController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // فحص إذا كان العرض للموبايل
    bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.darkbackground,
      // عرض الدراور فقط في الموبايل
      drawer: isMobile ? const AppDrawer() : null,
      appBar: isMobile 
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFFEAD7BB)),
            ) 
          : null,
      body: Row(
        children: [
          // إخفاء السايد بار في الموبايل
          if (!isMobile) const SidebarMenu(selectedTitl: "Feedback"),

          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // صورة الخلفية
                  Opacity(
                    opacity: 0.3, // تقليل الأوباسيتي لزيادة وضوح الحقول في الموبايل
                    child: Image.asset(
                      "assets/images/book.png",
                      width: MediaQuery.of(context).size.width,
                      height: isMobile ? 800.h : 600.h,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical:isMobile?20: 60.h,
                      horizontal: isMobile ? 20.w : 40.w, // إضافة بادينج جانبي في الموبايل
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "We Value Your Voice",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inriaSerif(
                            fontSize: isMobile ? 26.sp : 30.sp,
                            color: AppColors.lightbackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Help us write the next chapter of ReadHub",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inriaSerif(
                            fontSize: isMobile ? 16.sp : 20.sp,
                            color: AppColors.lightbackground.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 40.h),

                        // حقل العنوان
                        CustomTextField(
                          controller: _subjectController,
                          backgroundcolor: AppColors.lightbackground.withOpacity(0.4),
                          textcolor: AppColors.darktext,
                          hintText: "Subject...",
                          // العرض يتمدد في الموبايل ويتقيد في الويب
                          width: isMobile ? double.infinity : 400.w, 
                        ),

                        SizedBox(height: 15.h),

                        // حقل الرسالة
                        CustomTextField(
                          backgroundcolor: AppColors.lightbackground.withOpacity(0.4),
                          textcolor: AppColors.darktext,
                          controller: _messageController,
                          hintText: "Your Message...",
                          width: isMobile ? double.infinity : 400.w,
                          maxLines: isMobile ? 8 : 5, // تكبير الحقل قليلاً للموبايل
                        ),
                        
                        SizedBox(height: 30.h),

                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal:isMobile? 20.0:400),
                          child: _buildSendButton(isMobile),
                        ),
                        SizedBox(height:isMobile? 140.h:0),
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
  }

  Widget _buildSendButton(bool isMobile) {
    return GestureDetector(
      onTap: _sendFeedback,
      child: Container(
        width: isMobile ? double.infinity : null, // الزر يأخذ العرض الكامل في الموبايل
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.lightbackground.withOpacity(0.1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Send Message",
              style: GoogleFonts.inriaSerif(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 15.w),
            Icon(Icons.send, color: Colors.white70, size: 20.sp),
          ],
        ),
      ),
    );
  }
}