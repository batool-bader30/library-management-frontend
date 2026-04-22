class SimpleBook {
  int? id;
  String? title;
  String? imageUrl;
  String? authorName;
  bool? isAvailable;

  SimpleBook({
    this.id, 
    this.title, 
    this.imageUrl, 
    this.authorName, 
    this.isAvailable,
  });

  factory SimpleBook.fromJson(Map<String, dynamic> json) {
    return SimpleBook(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      authorName: json['authorName'],
      isAvailable: json['isAvailable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'authorName': authorName,
      'isAvailable': isAvailable,
    };
  }
}