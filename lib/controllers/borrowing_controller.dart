import 'package:flutter/material.dart';
import 'package:library_management_web_front/data/models/requests/borrowrequest.dart';
import 'package:library_management_web_front/data/models/responses/BorrwingDetailsModel.dart';

import '../data/models/responses/api_response.dart';
import '../data/services/borrowing_services.dart';

class BorrowingController extends ChangeNotifier {
  BorrowingServices borrowingServices = BorrowingServices();
  List<BorrwingDetailsModel> borrowing = [];
  bool isLoading = false;
  String errorMessage = '';
  String successMessage = '';

  Future<bool> postborrow(BorrowRequest request) async {
    isLoading = true;
    errorMessage = '';
    successMessage = '';
    notifyListeners(); // نبلغ الـ UI إنه صار في تحميل

    try {
      final ApiResponse<bool> response = await borrowingServices.borrowBook(
        request,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        successMessage = "Book borrowed successfully!";
        return true; // نجحت العملية
      } else {
        errorMessage = response.message ?? "Failed to borrow book";
        return false; // فشلت العملية
      }
    } catch (e) {
      errorMessage = "An unexpected error occurred: ${e.toString()}";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getBorrowDetailsByUserId(String id) async {
    errorMessage = '';
    notifyListeners();
    borrowing = [];

    try {
      final response = await borrowingServices.getBorrowingByUserId(id);

      if (response.statusCode == 200 && response.data != null) {
        borrowing = response.data!;
      } else {
        errorMessage = response.message ?? "Failed to fetch borrowing details";
      }
    } catch (e) {
      errorMessage = "An unexpected error occurred: ${e.toString()}";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBorrowing(
     {
    required int id,
    required int status,
    required DateTime returnDate,
    required String userId, // نحتاجه لإعادة جلب البيانات وتحديث الجدول بعد التعديل
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      bool success = await borrowingServices.updateBorrowingStatus(
       returnDate,
        status,
        
        id,
      );

      if (success) {
        await getBorrowDetailsByUserId(userId);
     }
    } catch (e) {
      print('Controller Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String calculateTimeLeft(String? returnDateStr) {
    if (returnDateStr == null) return "N/A";

    try {
      // تحويل النص إلى تاريخ
      DateTime returnDate = DateTime.parse(returnDateStr);
      DateTime now = DateTime.now();

      // حساب الفرق
      Duration difference = returnDate.difference(now);

      if (difference.isNegative) {
        return "Overdue"; // إذا انتهى الوقت
      } else if (difference.inDays > 0) {
        return "${difference.inDays} Days Remaining";
      } else if (difference.inHours > 0) {
        return "${difference.inHours} Hours Remaining";
      } else {
        return "Less than an hour";
      }
    } catch (e) {
      return "Invalid Date";
    }
  }
}
