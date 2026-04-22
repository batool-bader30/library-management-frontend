import 'package:library_management_web_front/data/models/responses/SimpleBook.dart'; // تأكدي من صحة المسار

class AuthorModel {
  int? id;
  String? name;
  String? bio;
  String? imageUrl; 
  List<SimpleBook>? books; 

  AuthorModel({this.id, this.name, this.bio, this.imageUrl, this.books});

  AuthorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    bio = json['bio'];
    imageUrl = json['imageUrl'];
    if (json['books'] != null) {
      books = <SimpleBook>[]; // الاعتماد على SimpleBook
      json['books'].forEach((v) {
        books!.add(SimpleBook.fromJson(v)); 
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['bio'] = bio;
    data['imageUrl'] = imageUrl;
    if (books != null) {
      data['books'] = books!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}