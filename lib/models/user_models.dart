// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    User user;
    String accessToken;
    String refreshToken;
    String role;

    UserModel({
        required this.user,
        required this.accessToken,
        required this.refreshToken,
        required this.role,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: User.fromJson(json["user"]),
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "role": role,
    };
}

class User {
    String id;
    String username;
    String password;
    String name;
    String email;
    String tel;
    String role;
    int v;

    User({
        required this.id,
        required this.username,
        required this.password,
        required this.name,
        required this.email,
        required this.tel,
        required this.role,
        required this.v,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        username: json["username"],
        password: json["password"],
        name: json["name"],
        email: json["email"],
        tel: json["tel"],
        role: json["role"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "password": password,
        "name": name,
        "email": email,
        "tel": tel,
        "role": role,
        "__v": v,
    };
}
