class ReviewsModel {
  int? id;
  int? bookId;
  String? userId;
  String? comment;
  int? rating;
  String? username;

  ReviewsModel({this.id, this.bookId, this.userId, this.comment, this.rating,this.username});

  ReviewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookId = json['bookId'];
    userId = json['userId'];
    comment = json['comment'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bookId'] = bookId;
    data['userId'] = userId;
    data['comment'] = comment;
    data['rating'] = rating;
    return data;
  }
}
