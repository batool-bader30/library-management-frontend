import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/responsive.dart';
import '../../data/services/ChatService.dart';
import 'package:google_fonts/google_fonts.dart';

class SmartAssistantWidget extends StatefulWidget {
  const SmartAssistantWidget({super.key});

  @override
  State<SmartAssistantWidget> createState() => _SmartAssistantWidgetState();
}

class _SmartAssistantWidgetState extends State<SmartAssistantWidget> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  bool _isLoading = false;
  String _aiResponse = "";

  void _showChatSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // يسمح للـ BottomSheet بالتوسع عند ظهور الكيبورد
      backgroundColor: const Color(0xFF3E2723),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              // هذا السطر هو الحل لمشكلة اختفاء الحقل خلف الكيبورد
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                // يضمن إمكانية التمرير إذا كان المحتوى طويلاً
                child: Container(
                  padding: EdgeInsets.all(25.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // مقبض السحب العلوي (للجمالية)
                      Container(
                        width: 50.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "ReadHub AI Assistant",
                        style: GoogleFonts.inriaSerif(
                          color: const Color(0xFFD7CCC8),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // منطقة عرض رد الذكاء الاصطناعي
                      if (_aiResponse.isNotEmpty)
                        Container(
                          constraints: BoxConstraints(maxHeight: 250.h),
                          padding: EdgeInsets.all(15.r),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _aiResponse,
                              style: GoogleFonts.inriaSerif(
                                color: Colors.white70,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: 15.h),

                      // حقل النص (TextField)
                      TextField(
                        controller: _controller,
                        autofocus: true, // يفتح الكيبورد فوراً
                        style:  GoogleFonts.inriaSerif(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "What do you feel like reading today?",
                          hintStyle:  GoogleFonts.inriaSerif(
                            color: Colors.white38,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFD7CCC8)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFD7CCC8),
                              width: 2,
                            ),
                          ),
                          suffixIcon: _isLoading
                              ? Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator(
                                    color: Color(0xFFD7CCC8),
                                  ),
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: Color(0xFFD7CCC8),
                                  ),
                                  onPressed: () {
                                    if (_controller.text.trim().isEmpty) return;

                                    String fullResponse = "";
                                    setModalState(() {
                                      _isLoading = true;
                                      _aiResponse = "";
                                    });

                                    _chatService
                                        .getAIStreamResponse(_controller.text)
                                        .listen(
                                          (newText) {
                                            fullResponse += newText;
                                            setModalState(() {
                                              _aiResponse = fullResponse;
                                            });
                                          },
                                          onError: (error) => setModalState(
                                            () => _isLoading = false,
                                          ),
                                          onDone: () => setModalState(
                                            () => _isLoading = false,
                                          ),
                                        );
                                    _controller.clear();
                                  },
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ), // مسافة إضافية عشان ما يلزق الحقل بالكيبورد
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    // نجهز قائمة العناصر أولاً عشان ما نكرر الكود
    List<Widget> children = [
      // فقاعة الكلام العلوية
      Container(
        width: isMobile ? 220.w : 120.w, // قللت الـ 200 شوي عشان الموبايل
        padding: EdgeInsets.all(isMobile ? 8.r : 12.r),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          border: Border.all(color: Colors.white24, width: 1.5),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          isMobile
              ? "Find your next read. Just ask me!"
              : "Find your\nnext read.\nJust ask me!",
          textAlign: TextAlign.center,
          style: GoogleFonts.inriaSerif(
            color: const Color(0xFFD7CCC8),
            fontSize: 14.sp,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(width: 10.w, height: 10.h), // بيشتغل بالجهتين
      // الأيقونة التفاعلية
      GestureDetector(
        onTap: () => _showChatSheet(context),
        child: CircleAvatar(
          radius: isMobile ? 35.r : 55.r, // تصغير القطر للموبايل
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: Image.asset(
              'assets/images/ai_icon.png',
              fit: BoxFit.cover,
              width: isMobile ? 70.r : 110.r,
              height: isMobile ? 70.r : 110.r,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.auto_awesome, size: 30.r, color: Colors.white),
            ),
          ),
        ),
      ),
    ];

    // هنا بنقرر إذا بنعرضهم سطر أو عمود
    return isMobile
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                MainAxisAlignment.end, // عشان يضلوا عاليمين بالموبايل
            children: children,
          )
        : Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}
