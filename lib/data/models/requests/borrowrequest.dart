class BorrowRequest {
  final int? bookId;
  final String userId;
  final String borrowDate;
  final String returnDate;

  BorrowRequest({
    required this.bookId,
    required this.userId,
    required this.borrowDate,
    required this.returnDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "bookId": bookId,
      "userId": userId,
      "borrowDate": borrowDate,
      "returnDate": returnDate,
    };
  }
}