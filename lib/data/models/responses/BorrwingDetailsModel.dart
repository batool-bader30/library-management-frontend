import 'package:library_management_web_front/data/models/responses/SimpleBook.dart';
import 'package:library_management_web_front/data/models/responses/user.dart';

class BorrwingDetailsModel {
  int? id;
  String? borrowDate;
  String? returnDate;
  String? status;
  SimpleBook? book;
  UserInfo? user;

  BorrwingDetailsModel(
      {this.id,
      this.borrowDate,
      this.returnDate,
      this.status,
      this.book,
      this.user});

  BorrwingDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    borrowDate = json['borrowDate'];
    returnDate = json['returnDate'];
    status = json['status'];
    book = json['book'] != null ?  SimpleBook.fromJson(json['book']) : null;
    user = json['user'] != null ?  UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['borrowDate'] = this.borrowDate;
    data['returnDate'] = this.returnDate;
    data['status'] = this.status;
    if (this.book != null) {
      data['book'] = this.book!.toJson();
    }
   
    return data;
  }
}
