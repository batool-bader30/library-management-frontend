import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/controllers/book_controller.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/data/models/responses/SimpleBook.dart';
import 'package:library_management_web_front/views/screens/admin/adminSideMenu.dart';
import 'package:library_management_web_front/views/widgets/CustomSearch.dart';
import 'package:library_management_web_front/views/widgets/CustomTextField.dart';
import 'package:library_management_web_front/views/widgets/customButton.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api_client.dart';
import '../../../core/utils/navigator_utils.dart';

class BooksManagementScreen extends StatefulWidget {
  const BooksManagementScreen({super.key});

  @override
  State<BooksManagementScreen> createState() => _BooksManagementScreenState();
}

class _BooksManagementScreenState extends State<BooksManagementScreen> {
  @override
  void initState() {
    super.initState();
    // نستخدم الـ addPostFrameCallback عشان نضمن إن الـ Build خلص
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookController>().getAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightbackground,
      body: Consumer<BookController>(
        builder: (context, controller, child) {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/addbook.bg.png"),
                fit: BoxFit.cover, // تم تغيير fill لـ cover لجمالية أفضل
              ),
            ),

            child: Row(
              children: [
                const Adminsidemenu(selectedTitl:"Books Management"), // المنيو الجانبي
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Books Management",
                          style: GoogleFonts.inriaSerif(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darktext,
                          ),
                        ),
                        const SizedBox(height: 30),

                        Expanded(
                          flex: 5,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 40.0,
                                      ),
                                      child: Customsearch(),
                                    ),
                                    const SizedBox(height: 20),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 60.0,
                                          vertical: 20,
                                        ),
                                        child: _buildBooksList(controller),
                                      ),
                                    ),
                                  ],
                                ),
                              ), // قائمة الكتب
                              SizedBox(width: 20),
                              const VerticalDivider(
                                width: 20,
                                thickness: 1,
                                color: Colors.black26,
                                endIndent: 30,
                                indent: 60,
                              ),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0,
                                    vertical: 0,
                                  ),
                                  child: _buildAddBookForm(controller, context),
                                ),
                              ), // فورم الإضافة
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
        },
      ),
    );
  }

  Widget _buildBooksList(BookController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "all books:",
          style: GoogleFonts.inriaSerif(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: c.books.length,
            itemBuilder: (context, index) => _bookItemCard(c.books[index], c),
          ),
        ),
      ],
    );
  }

  Widget _bookItemCard(SimpleBook c, BookController controller) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              (c.imageUrl != null && c.imageUrl!.startsWith('http'))
                  ? c.imageUrl!
                  : '${ApiClient.storageUrl}${c.imageUrl ?? ""}',
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.white10,
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white24,
                    size: 30.sp,
                  ),
                );
              },
              height: 50,
              width: 40,
            ),
          ),
          title: GestureDetector(
            onTap: () =>
                NavigatorUtils.navigateToBookDetailsScreen(context, c.id),

            child: Text(
              c.title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inriaSerif(
                color: AppColors.darktext,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Image.asset(
                  "assets/images/editt.png",
                  width: 40, // بديل لـ size في ImageIcon
                  height: 40,
                  fit: BoxFit.contain,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset(
                  "assets/images/deletee.png",
                  width: 40, // بديل لـ size في ImageIcon
                  height: 40,
                  fit: BoxFit.contain,
                ),
                onPressed: () {
                  controller.deleteBook(c.id ?? 1);
                },
              ),
              SizedBox(width: 20),
            ],
          ),
        ),
        Divider(
          color: const Color.fromARGB(255, 35, 18, 1).withOpacity(0.1),
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildAddBookForm(BookController controller, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Add New Book",
            style: GoogleFonts.inriaSerif(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // --- حقل عنوان الكتاب ---
          CustomTextField(
            hintText: "Book Title",
            width: 300,
            backgroundcolor: AppColors.darkbackground.withOpacity(.8),
            textcolor: AppColors.lightbackground,
            controller: controller.titleController,
          ),
          const SizedBox(height: 10),

          // --- حقل Author ID ---
          CustomTextField(
            hintText: "Author ID",
            width: 300,
            backgroundcolor: AppColors.darkbackground.withOpacity(.8),
            textcolor: AppColors.lightbackground,
            controller: controller.authorIdController,
          ),
          const SizedBox(height: 10),

          // --- حقل التصنيفات ---
          CustomTextField(
            hintText: "Category IDs (e.g. 1, 2)",
            width: 300,
            backgroundcolor: AppColors.darkbackground.withOpacity(.8),
            textcolor: AppColors.lightbackground,
            controller: controller.categoriesController,
          ),
          const SizedBox(height: 10),

          // --- حقل الوصف ---
          CustomTextField(
            hintText: "Description",
            maxLines: 1,
            width: 300,
            backgroundcolor: AppColors.darkbackground.withOpacity(.8),
            textcolor: AppColors.lightbackground,
            controller: controller.descriptionController,
          ),
          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- حقل ISBN ---
              CustomTextField(
                hintText: "ISBN",
                width: 150,
                backgroundcolor: AppColors.darkbackground.withOpacity(.8),
                textcolor: AppColors.lightbackground,
                controller: controller.isbnController,
              ),
              const SizedBox(width: 5),

              CustomTextField(
                hintText: "Page Number",
                maxLines: 1,
                width: 150,
                backgroundcolor: AppColors.darkbackground.withOpacity(.8),
                textcolor: AppColors.lightbackground,
                controller: controller.pageNumberController,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                hintText: "Language",
                width: 150,
                backgroundcolor: AppColors.darkbackground.withOpacity(.8),
                textcolor: AppColors.lightbackground,
                controller: controller.languageController,
              ),
              const SizedBox(width: 5),

              CustomTextField(
                hintText: "Publish Date",
                maxLines: 1,
                width: 150,
                backgroundcolor: AppColors.darkbackground.withOpacity(.8),
                textcolor: AppColors.lightbackground,
                controller: controller.publishdateController,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // --- حقل اختيار الصورة (Web Compatible) ---
          GestureDetector(
            onTap: () => controller.pickImage(),
            child: Column(
              children: [
                AbsorbPointer(
                  child: CustomTextField(
                    hintText:
                        controller.selectedImageName ?? "Select Image File",
                    width: 300,
                    backgroundcolor: AppColors.darkbackground.withOpacity(.8),
                    textcolor: AppColors.lightbackground,
                    controller: null, // لا يحتاج متحكم نصي لأنه للعرض فقط
                  ),
                ),

                // عرض معاينة للصورة المختارة (خاص بالويب والموبايل)
                if (controller.webImage != null &&
                    controller.selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        controller.webImage!,
                        height: 150,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // --- زر الإضافة مع مؤشر التحميل ---
          CustomButton(
            text: "      Add Book      ",
            backgroundColor: AppColors.darkbackground.withOpacity(.8),
            onPressed: () async {
              bool success = await controller.submitBook();
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Book Added Successfully!"),
                    backgroundColor: Color.fromARGB(255, 69, 49, 0),
                  ),
                );
              } else if (!success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      controller.errorMessage.isEmpty
                          ? "Failed to add book"
                          : controller.errorMessage,
                    ),
                    backgroundColor: const Color.fromARGB(255, 76, 40, 1),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
