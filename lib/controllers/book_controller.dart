import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_management_web_front/data/models/responses/SimpleBook.dart';
import 'package:library_management_web_front/data/models/responses/bookdetails.dart';
import '../data/models/requests/AddBookRequest.dart';
import '../data/services/book_services.dart';

class BookController extends ChangeNotifier {
  final BookServices _bookServices = BookServices();

  // --- الحالات العامة (States) ---
  List<SimpleBook> books = [];
  BookDetailsModel? bookDetails;
  bool isLoading = false;
  String errorMessage = '';
  

  // --- مِيحكمات النصوص لنموذج الإضافة (Add Book Controllers) ---
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final isbnController = TextEditingController();
  final authorIdController = TextEditingController();
  final categoriesController = TextEditingController();
  final languageController = TextEditingController();
  final pageNumberController = TextEditingController();

  // --- مِيحكمات التواريخ للاستعارة ---
  final borrowDateController = TextEditingController();
  final returnDateController = TextEditingController();

  // --- متغيرات الصورة ---
  XFile? selectedImage; // الملف المختار
  Uint8List? webImage; // لعرض الصورة في الويب (Preview)
  String? selectedImageName;

  // ---------------------------------------------------------
  // 1. منطق إضافة كتاب جديد (Add Book Logic)
  // ---------------------------------------------------------

  // اختيار صورة من المعرض
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

  // تجميع البيانات وإرسالها
  Future<bool> submitBook() async {
    if (titleController.text.isEmpty || selectedImage == null) {
      errorMessage = "Please select an image file first";
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      List<int> catIds = categoriesController.text
          .split(',')
          .where((s) => s.trim().isNotEmpty)
          .map((e) => int.parse(e.trim()))
          .toList();
      // بناء الـ Request مع إرسال الملف
      final request = AddBookRequest(
        title: titleController.text,
        description: descriptionController.text,
        isbn: isbnController.text,
        authorId: int.tryParse(authorIdController.text) ?? 0,
        // ... باقي الحقول
        imageUrl: selectedImage,
        categoryIds: catIds, // نرسل الملف هنا
      );

      final response = await _bookServices.addBook(request);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _clearForm();
        webImage = null; // ✅
        notifyListeners();
        await getAllBooks(); // هنا الكتب ستعود من السيرفر ومعها اللينك http
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

  // تنظيف النموذج
  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    isbnController.clear();
    authorIdController.clear();
    categoriesController.clear();
    languageController.clear();
    pageNumberController.clear();
    webImage = null;
    selectedImage = null;
    selectedImageName = null;
    notifyListeners();
  }

  // ---------------------------------------------------------
  // 2. جلب البيانات (Fetch Data Logic)
  // ---------------------------------------------------------

  Future<void> getAllBooks() async {
    isLoading = true;

    errorMessage = '';

    notifyListeners(); // نبلغ الـ UI إنه صار في تحميل

    try {
      final response = await _bookServices.getAllBooks();

      if (response.statusCode == 200 && response.data != null) {
        books = response.data!;
      } else {
        errorMessage = response.message ?? "Failed to fetch books";
      }
    } catch (e) {
      errorMessage = "An unexpected error occurred: ${e.toString()}";
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> getBookDetailsById(int id) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final response = await _bookServices.getBookById(id);

      if (response.statusCode == 200 && response.data != null) {
        bookDetails = response.data!;
      } else {
        errorMessage = response.message ?? "Failed to fetch book details";
      }
    } catch (e) {
      errorMessage = "An unexpected error occurred: ${e.toString()}";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------
  // 3. منطق تواريخ الاستعارة (Borrowing Logic)
  // ---------------------------------------------------------

  void updateBorrowDate(DateTime pickedDate) {
    borrowDateController.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    returnDateController.clear();
    notifyListeners();
  }

  void updateReturnDate(DateTime pickedDate) {
    returnDateController.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    notifyListeners();
  }

  // ---------------------------------------------------------
  // 3. منطق حذف الكتاب ( Dellete Book)
  // ---------------------------------------------------------

  Future<void> deleteBook(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _bookServices.deleteBook(id);

      if (response.statusCode == 200) {
        // بعد الحذف الناجح، نقوم بإزالة الكتاب من القائمة محلياً لتحديث الـ UI فوراً
        books.removeWhere((book) => book.id == id);
        errorMessage = '';
      } else {
        errorMessage = "Failed to delete book: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "An error occurred while deleting.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // تحرير الذاكرة عند إغلاق الكنترولر
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    isbnController.dispose();
    authorIdController.dispose();
    categoriesController.dispose();
    borrowDateController.dispose();
    returnDateController.dispose();
    super.dispose();
  }
}
