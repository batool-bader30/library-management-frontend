class CreateAccount { 
  String? userName;
  String? password;
  String? email;
  String? phoneNumber;
  String? role;

  CreateAccount({
    this.userName,
    this.password,
    this.email,
    this.phoneNumber,
    this.role,
  });

  factory CreateAccount.fromJson(Map<String, dynamic> json) {
    return CreateAccount(
      userName: json['userName'],
      password: json['password'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
    );
  }

  // Simplified toJson using arrow syntax
  Map<String, dynamic> toJson() => {
    'userName': userName,
    'password': password,
    'email': email,
    'phoneNumber': phoneNumber,
    'role': role,
  };
}