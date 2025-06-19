import 'package:flutter/material.dart';

class LoginController with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _passwordError;

  bool get obscurePassword => _obscurePassword;
  String? get passwordError => _passwordError;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void validateAndLogin() {
    final password = passwordController.text;
    if (password.length < 8) {
      _passwordError = 'Kata sandi minimal 8 karakter';
    } else {
      _passwordError = null;
      // Lanjutkan proses login, misal: API call
      debugPrint("Login sukses dengan email: ${emailController.text}");
    }
    notifyListeners();
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}
