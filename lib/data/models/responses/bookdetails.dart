import 'package:library_management_web_front/data/models/responses/reviews.dart';
import 'package:library_management_web_front/data/models/responses/user.dart';

class BookDetailsModel {
  int? id;
  String? title;
  String? description;
  String? isbn;
  String? imageUrl;
  bool? isAvailable;
  String? pageNumber;
  String? language;
  String? publishDate;
  int? authorId;
  String? authorName;
  List<String>? categories;
  List<ReviewsModel>? reviews;
  List<Borrowings>? borrowings;

  BookDetailsModel({
    this.id,
    this.title,
    this.description,
    this.isbn,
    this.imageUrl,
    this.isAvailable,
    this.pageNumber,
    this.language,
    this.publishDate,
    this.authorId,
    this.authorName,
    this.categories,
    this.reviews,
    this.borrowings,
  });

  BookDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    isbn = json['isbn'];
    imageUrl = json['imageUrl'];
    isAvailable = json['isAvailable'];
    pageNumber = json['pageNumber']?.toString(); // تحويل للأمان في حال وصل رقم
    language = json['language'];
    publishDate = json['publishDate'];
    authorId = json['authorId'];
    authorName = json['authorName'];
    
    // طريقة آمنة لصب القائمة
    if (json['categories'] != null) {
      categories = List<String>.from(json['categories']);
    }

    if (json['reviews'] != null) {
      reviews = (json['reviews'] as List).map((v) => ReviewsModel.fromJson(v)).toList();
    }
    
    if (json['borrowings'] != null) {
      borrowings = (json['borrowings'] as List).map((v) => Borrowings.fromJson(v)).toList();
    }
  }
}

class Borrowings {
  int? id;
  String? borrowDate;
  String? returnDate;
  String? status;
  UserInfo? user;

  Borrowings({this.id, this.borrowDate, this.returnDate, this.status, this.user});

  Borrowings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    borrowDate = json['borrowDate'];
    returnDate = json['returnDate'];
    status = json['status'];
    user = json['user'] != null ? UserInfo.fromJson(json['user']) : null;
  }
}