import 'package:flutter/material.dart';

class RegisterController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;
  bool isPasswordVisible = false;

  // -------- VALIDASI --------
  bool validateInputs() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Nama wajib diisi
    nameError = name.isEmpty ? 'Nama wajib diisi' : null;

    // Email wajib diisi dan harus mengandung karakter @
    if (email.isEmpty) {
      emailError = 'Email wajib diisi';
    } else if (!email.contains('@')) {
      emailError = 'Email harus mengandung karakter @';
    } else {
      emailError = null;
    }

    // Password minimal 8 karakter
    passwordError =
        password.length < 8 ? 'Kata sandi minimal 8 karakter' : null;

    // Semua harus null supaya valid
    return nameError == null && emailError == null && passwordError == null;
  }

  // -------- VISIBILITAS PASSWORD --------
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
  }

  // -------- DISPOSE CONTROLLER --------
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
