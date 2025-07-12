import 'package:flutter/material.dart';

class LoginController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String get username => usernameController.text;
  String get password => passwordController.text;

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}
