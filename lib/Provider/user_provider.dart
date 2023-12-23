import 'package:flutter/material.dart';


class UserProvider extends ChangeNotifier {
  User? currentUser;

  void setCurrentUser(User user) {
    currentUser = user;
    notifyListeners();
  }
}

class User {
  final String name;
  final String password;
  final String imageUrl;

  User({
    required this.name,
    required this.password,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
      'imageUrl': imageUrl,
    };
  }
  static User fromJson(Map<String, dynamic> json) {
    return User(
      name: json['userName'] as String,
      password: json['userPassword'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

