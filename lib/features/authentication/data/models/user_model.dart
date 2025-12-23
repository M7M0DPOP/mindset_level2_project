import 'dart:convert'; // 1. Import this for jsonEncode/jsonDecode

class UserModel {
  String email;
  String userId;
  String userName;
  String userImage;

  UserModel({
    required this.email,
    required this.userId,
    required this.userName,
    required this.userImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'userId': userId,
      'userImage': userImage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      userId: map['userId'] ?? '',
      userImage: map['userImage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
