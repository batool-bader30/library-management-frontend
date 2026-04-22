
import 'package:image_picker/image_picker.dart';

class AddBookRequest {
  final String title;
  final String description;
  final String isbn;
  final int authorId;
  final String? pageNumber;
  final String? language;
  final String? publishDate;
  final XFile? imageUrl; // يمكن أن يكون XFile أو File
  final List<int> categoryIds;

  AddBookRequest({
    required this.title,
    required this.description,
    required this.isbn,
    required this.authorId,
     this.pageNumber,
     this.language,
     this.publishDate,
    required this.imageUrl,
    required this.categoryIds,
  });
}