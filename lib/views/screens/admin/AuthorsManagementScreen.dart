import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/controllers/author_controller.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/core/utils/navigator_utils.dart';
import 'package:library_management_web_front/data/models/responses/authormodel.dart';
import 'package:library_management_web_front/views/screens/admin/adminSideMenu.dart';
import 'package:library_management_web_front/views/widgets/CustomSearch.dart';
import 'package:library_management_web_front/views/widgets/CustomTextField.dart';
import 'package:library_management_web_front/views/widgets/customButton.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api_client.dart';

class Authorsmanagementscreen extends StatefulWidget {
  const Authorsmanagementscreen({super.key});

  @override
  State<Authorsmanagementscreen> createState() => _AuthorsmanagementscreenState();
}

class _AuthorsmanagementscreenState extends State<Authorsmanagementscreen> {

  @override
void initState() {
  super.initState();
  // نستخدم الـ addPostFrameCallback عشان نضمن إن الـ Build خلص
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<AuthorController>().gettllauthor();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightbackground,
      body: Consumer<AuthorController>(
        builder: (context, controller, child) {

          return Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/addauthor.bg.png"),
                fit: BoxFit.cover, // تم تغيير fill لـ cover لجمالية أفضل
              ),
            ),
            child: Row(
              children: [
                const Adminsidemenu(selectedTitl:"Authors Management"), // المنيو الجانبي
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Authors Management",
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

  Widget _buildBooksList(AuthorController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "all authors:",
          style: GoogleFonts.inriaSerif(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: c.authors.length,
            itemBuilder: (context, index) => _bookItemCard(c.authors[index], c),
          ),
        ),
      ],
    );
  }

  Widget _bookItemCard(AuthorModel c, AuthorController controller) {
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
            onTap: () => NavigatorUtils.navigateToAuthorDetailsScreen(context, c.id),
            child: Text(
              c.name ?? "",
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
                onPressed: () {
                },
              ),
              IconButton(
                icon: Image.asset(
                  "assets/images/deletee.png",
                  width: 40, // بديل لـ size في ImageIcon
                  height: 40,
                  fit: BoxFit.contain,
                ),
                onPressed: () {
                  controller.deleteAuthor(c.id ?? 1);
                },
              ),
              SizedBox(width: 20,)
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

  Widget _buildAddBookForm(AuthorController controller, BuildContext context) {
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

        

          // --- حقل Author ID ---
          CustomTextField(
            hintText: "Author Name",
            width: 300,
            backgroundcolor: AppColors.darkbackground.withOpacity(.8),
            textcolor: AppColors.lightbackground,
            controller: controller.authornameController,
          ),
          const SizedBox(height: 10),

         
          // --- حقل الوصف ---
          CustomTextField(
            hintText: "Bio",
            maxLines: 3,
            width: 300,
            backgroundcolor: AppColors.darkbackground.withOpacity(.8),
            textcolor: AppColors.lightbackground,
            controller: controller.bioController,
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
              bool success = await controller.submitAuthor();
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Author Added Successfully!"),
                    backgroundColor: Color.fromARGB(255, 69, 49, 0),
                  ),
                );
              } else if (!success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      controller.errorMessage.isEmpty
                          ? "Failed to add Author"
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
