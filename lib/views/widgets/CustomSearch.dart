import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/constants/colors.dart';

class Customsearch extends StatelessWidget {
  void Function()? onPressed;
  final TextEditingController? controller;
  Customsearch({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "search...",
          hintStyle: GoogleFonts.inriaSerif(color: AppColors.lightbackground),
          filled: true,
          fillColor: Color.fromARGB(255, 68, 35, 23),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: AppColors.lightbackground,
              width: 2.0,
            ), // لون خفيف
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.search, color: AppColors.lightbackground),
            ),
          ),
        ),
      ),
    );
  }
}
