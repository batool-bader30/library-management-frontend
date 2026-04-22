class UserInfo {
  String? id;
  String? userName;
  String? email;
  String? phoneNumber;
  String? accessToken; // Token من الـ Auth

  UserInfo({this.id, this.userName, this.email, this.phoneNumber, this.accessToken});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    accessToken = json['token']; // الـ API عندك بيرجعها باسم token
  }
}