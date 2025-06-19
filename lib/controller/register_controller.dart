import 'package:flutter/material.dart';

class RegisterController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool isPasswordVisible = false;

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  bool validateInputs() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    emailError =
        email.contains('@') ? null : 'Email harus mengandung karakter @';
    passwordError =
        password.length < 8 ? 'Kata sandi minimal 8 karakter' : null;

    return emailError == null && passwordError == null;
  }

  void togglePasswordVisibility(Function(bool) onChanged) {
    isPasswordVisible = !isPasswordVisible;
    onChanged(isPasswordVisible);
  }
}
