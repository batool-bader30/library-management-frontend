import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:library_management_web_front/controllers/auth_controller.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/views/widgets/CustomTextField.dart';
import 'package:library_management_web_front/views/widgets/customButton.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  // 1. تعريف الكنترولرز للحقول
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // 2. الوصول للـ AuthController
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/Loginimage.png",
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              height: 580.h, // زدنا الطول قليلاً ليتناسب مع العناصر
              width: 450.w,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
              decoration: BoxDecoration(
                color: AppColors.lightbackground.withAlpha(180),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Let's create an account",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.specialElite(
                        fontSize: 35.sp, // صغرنا الخط قليلاً للتناسب
                        fontWeight: FontWeight.bold,
                        color: AppColors.darktext,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      controller: _emailController, // ربط الكنترولر
                      label: "Email",
                      hintText: "enter your email...",
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      controller: _userNameController, // ربط الكنترولر
                      label: "UserName",
                      hintText: "enter your UserName...",
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      controller: _passwordController, // ربط الكنترولر
                      label: "Password",
                      hintText: "enter your password...",
                      isPassword: true,
                    ),
                    SizedBox(height: 30.h),
                    
                    // 3. عرض LoadingIndicator إذا كان الطلب جارياً
                    authController.isLoading 
                    ? const CircularProgressIndicator(color: Colors.brown)
                    : CustomButton(
                        text: "CREATE ACCOUNT", 
                        onPressed: () async {
                          // تنفيذ عملية التسجيل (يمكنكِ إضافة حقل الـ Role و Phone لاحقاً)
                          final response = await authController.register({
                            "userName": _userNameController.text,
                            "password": _passwordController.text,
                            "email": _emailController.text,
                            "role": "User"
                          });

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response.message ?? "Success!")),
                            );
                            // الانتقال للـ Home أو الـ Login
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response.message ?? "Error occurred")),
                            );
                          }
                        }
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}