import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/constants/assets.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/core/utils/navigator_utils.dart';
import 'package:library_management_web_front/views/widgets/CustomTextField.dart';
import 'package:library_management_web_front/views/widgets/customButton.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final authController = Provider.of<AuthController>(context);

    return Scaffold(
            resizeToAvoidBottomInset: false,

      body: Stack(
        children: [
          Image.asset(
            Assets.login,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              height: 500.h,
              width: 450.w,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
              decoration: BoxDecoration(
                color: AppColors.lightbackground.withAlpha(150),

                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "hi again",
                        style: GoogleFonts.specialElite(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darktext,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    CustomTextField(
                      controller: _emailController,
                      label: "email",
                      hintText: "enter your email...",
                    ),
                    SizedBox(height: 20.h),

                    CustomTextField(
                      controller: _passwordController,
                      label: "password",
                      hintText: "enter your password...",
                      isPassword: true,
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "forgot password?",
                          style: GoogleFonts.inriaSerif(
                            color: AppColors.darktext,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),
                    authController.isLoading
                        ? const CircularProgressIndicator(color: Colors.brown)
                        : CustomButton(
                            text: "LOG IN",
                            onPressed: () async {
                              if (_emailController.text.trim().isEmpty ||
                                  _passwordController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please enter both email and password",
                                    ),
                                  ),
                                );
                              } else {
                                final login = await authController.login(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                                if (login.statusCode == 200 ||
                                    login.statusCode == 201) {
                                  final roll = await authController
                                      .checkAuthStatus();
                                  if (roll == "User") {
                                    NavigatorUtils.navigateToHomeScreen(
                                      context,
                                    );
                                  } else {
                                    NavigatorUtils.navigateToOverviewScreen(
                                      context,
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(login.message ?? "error"),
                                    ),
                                  );
                                }
                              }
                            },
                          ),

                    SizedBox(height: 20.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "dont have account? ",
                          style: GoogleFonts.inriaSerif(
                            fontSize: 13.sp,
                            color: AppColors.darkbackground,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            NavigatorUtils.navigateToCreateAccountScreen(
                              context,
                            );
                          },
                          child: Text(
                            "create Now",
                            style: GoogleFonts.inriaSerif(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: AppColors.darktext,
                            ),
                          ),
                        ),
                      ],
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
