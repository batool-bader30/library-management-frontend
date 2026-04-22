class ApiResponse<T> {
  T? data;
  String? message;
  int? statusCode;

  ApiResponse({this.data,this.message,this.statusCode});
}
