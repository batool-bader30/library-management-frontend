import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_management_web_front/data/models/responses/authormodel.dart';
import 'package:library_management_web_front/data/services/author_services.dart';

class AuthorController extends ChangeNotifier {
  AuthorServices authorServices = AuthorServices();
  List<AuthorModel> authors = [];
  bool isLoading = false;
  String errorMessage = '';

  final authornameController = TextEditingController();
  final bioController = TextEditingController();

  // --- متغيرات الصورة ---
  XFile? selectedImage; // الملف المختار
  Uint8List? webImage; // لعرض الصورة في الويب (Preview)
  String? selectedImageName;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = image;
      selectedImageName = image.name;
      // قراءة البيانات للعرض فقط في المتصفح
      webImage = await image.readAsBytes();
      notifyListeners();
    }
  }

  Future<bool> submitAuthor() async {
    if (authornameController.text.isEmpty) {
      errorMessage = "Please enter name of author";
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await authorServices.addAuhtor(
        name: authornameController.text,
        bio: bioController.text,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        authornameController.clear();
        bioController.clear();
        await gettllauthor();
        return true;
      }
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> gettllauthor() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners(); // نبلغ الـ UI إنه صار في تحميل

    try {
      final response = await authorServices.getAllAuthors();

      if (response.statusCode == 200 && response.data != null) {
        authors = response.data!;
      } else {
        errorMessage = response.message ?? "Failed to fetch authors";
      }
    } catch (e) {
      errorMessage = "An unexpected error occurred: ${e.toString()}";
    } finally {
      isLoading = false;
      notifyListeners(); // نبلغ الـ UI يطفي الـ Loading ويعرض البيانات
    }
  }

   Future<void> deleteAuthor(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await authorServices.deleteAuthor(id);

      if (response.statusCode == 200) {
        // بعد الحذف الناجح، نقوم بإزالة الكتاب من القائمة محلياً لتحديث الـ UI فوراً
        authors.removeWhere((book) => book.id == id);
        errorMessage = '';
      } else {
        errorMessage = "Failed to delete author: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "An error occurred while deleting.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
