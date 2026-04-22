import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:library_management_web_front/data/models/responses/reviews.dart';
import 'package:library_management_web_front/data/services/review_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/responses/api_response.dart';
import '../data/services/auth_services.dart';

class ReviewController extends ChangeNotifier {
  final ReviewServices reviewServices = ReviewServices();
  final AuthServices authServices = AuthServices();

  List<ReviewsModel> allreviews = [];
  List<ReviewsModel> reviews = [];
    List<ReviewsModel>userReviews = [];

  


  bool isLoading = false;
  String errorMessage = '';
  final TextEditingController commentController = TextEditingController();
  int currentRating = 0;

  // 1. جلب كل المراجعات (للدفحة الرئيسية)
  Future<void> getallreview() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await reviewServices.getAllReviews();
      if (response.statusCode == 200 && response.data != null) {
        await _fillUsernames(response.data!);
        allreviews = response.data!;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 2. جلب مراجعات كتاب محدد من السيرفر (الخيار الأفضل للأداء)
  Future<void> fetchReviewsByBookId(int bookId) async {
    isLoading = true;
    errorMessage = '';

    try {
      final response = await reviewServices.getReviewsByBookId(bookId);
      if (response.statusCode == 200 && response.data != null) {
        List<ReviewsModel> fetchedReviews = response.data!;
        await _fillUsernames(fetchedReviews);
        reviews = fetchedReviews;
      } else {
        errorMessage = response.message ?? "Error fetching reviews";
        reviews = [];
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners(); // إخبار الشاشة بأن التحميل انتهى لعرض البيانات الجديدة
    }
  }

  // دالة مساعدة لجلب أسماء المستخدمين بناءً على الـ ID
  Future<void> _fillUsernames(List<ReviewsModel> list) async {
    await Future.wait(
      list.map((review) async {
        if (review.userId != null &&
            (review.username == null || review.username!.isEmpty)) {
          final userRes = await authServices.getUserById(review.userId!);
          if (userRes.statusCode == 200 && userRes.data != null) {
            review.username = userRes.data!.userName;
          } else {
            review.username = "User ${review.userId?.substring(0, 5)}";
          }
        }
      }),
    );
  }


 
  Future<void> fetchUserReviews(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
     final response = await reviewServices.getReviewsByUserId(userId);
      if (response.statusCode == 200 && response.data != null) {
        List<ReviewsModel> fetchedReviews = response.data!;
        await _fillUsernames(fetchedReviews);
        userReviews = fetchedReviews;
      } else {
        errorMessage = response.message ?? "Error fetching reviews";
        userReviews = [];
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners(); // إخبار الشاشة بأن التحميل انتهى لعرض البيانات الجديدة
    }
  }


  // 3. إرسال مراجعة جديدة
  Future<bool> submitReview(int bookId) async {
    if (commentController.text.trim().isEmpty || currentRating == 0) {
      errorMessage = "Please add a comment and a rating";
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("accessToken");
      String? userId = token != null ? _getUserIdFromToken(token) : null;

      if (userId == null) {
        errorMessage = "User not authenticated";
        return false;
      }

      ApiResponse<void> response = await reviewServices.createReview(
        bookId: bookId,
        userId: userId,
        comment: commentController.text.trim(),
        rating: currentRating,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        commentController.clear();
        int savedBookId = bookId; // حفظ المعرف لتحديث القائمة
        currentRating = 0;
        await fetchReviewsByBookId(savedBookId); // تحديث القائمة فوراً
        return true;
      } else {
        errorMessage = response.message ?? "Failed to submit review";
        return false;
      }
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? _getUserIdFromToken(String token) {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['UserId']?.toString();
    } catch (e) {
      return null;
    }
  }
}
