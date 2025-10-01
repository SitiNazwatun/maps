class UserModel {
  final  username;
  final  token;
  final  role;

  UserModel({required this.username, required this.token, required this.role});

  //ini constructor untuk membuat objek UserModel dari JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // username: json['sub'] as String,
      // token: json['token'] as String,
      // role: json['role'] as String,
        username: json['username'], //sesuaikan dengan key API
        token: json['token'],
        role: json['role'],
    );
  }
}